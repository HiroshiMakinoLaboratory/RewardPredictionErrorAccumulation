import numpy as np
import random
import gym
import sys
import pickle
import scipy.io
import torch
import torch.nn as nn
import torch.optim as optim
from torch.distributions import Categorical

sys.path.append('/home/user/Documents/Error/gym-navigation/')
import gym_navigation

# Hyperparameters
seed_num = 0
n_episodes = 4001
n_steps = 8
gamma = 0.95
gae_lambda = 0.95
lr = 1e-05
clip_param = 0.2

# Shared network
class ActorCritic(nn.Module):
    def __init__(self, state_dim, action_dim):
        super(ActorCritic, self).__init__()
        self.common_layers = nn.Sequential(
            nn.Linear(state_dim, 256),
            nn.ReLU(),
            nn.Linear(256, 256),
            nn.ReLU(),
            nn.Linear(256, 256),
            nn.ReLU(),
            nn.Linear(256, 256),
            nn.ReLU(),
        )
        self.actor_layer = nn.Linear(256, action_dim)
        self.critic_layer = nn.Linear(256, 1)

    def forward(self, x):
        base = self.common_layers(x)
        action_probs = torch.softmax(self.actor_layer(base), dim=-1)
        value = self.critic_layer(base)
        return action_probs, value

    def act(self, state):
        action_probs, _ = self.forward(state)
        action_dist = Categorical(action_probs)
        action = action_dist.sample()
        log_probs = action_dist.log_prob(action)
        return action, log_probs

    def evaluate_policy(self, states, actions):
        action_probs, value = self.forward(states)
        action_dist = Categorical(action_probs)
        log_probs = action_dist.log_prob(actions)
        state_values = torch.squeeze(value)
        dist_entropy = action_dist.entropy()
        return log_probs, state_values, dist_entropy


# Check if the agent is in the reward zone
def is_reward_zone(x_pos, y_pos, x_pos_next, y_pos_next, reward_zone_size):
    x_pos_range = np.linspace(x_pos, x_pos_next, 1001)
    y_pos_range = np.linspace(y_pos, y_pos_next, 1001)
    reach_reward_zone = []
    done_state = []
    for bin_num in range(len(x_pos_range)):
        reach_reward_zone.append(-reward_zone_size <= x_pos_range[bin_num] <= reward_zone_size and -reward_zone_size <= y_pos_range[bin_num] <= reward_zone_size)
    success = any(reach_reward_zone)
    if success:
        done_state = torch.tensor([x_pos_range[np.argmax(reach_reward_zone)], y_pos_range[np.argmax(reach_reward_zone)]], dtype=torch.float32)
    return success, done_state


# Check if the agent is moving toward the reward zone but failing to reach it
def is_moving_toward_reward_zone(x_pos, y_pos, x_pos_next, y_pos_next, reward_zone_size):
    current_distance = np.sqrt(x_pos**2 + y_pos**2)
    next_distance = np.sqrt(x_pos_next**2 + y_pos_next**2)
    return next_distance < current_distance and not (
        -reward_zone_size <= x_pos_next <= reward_zone_size and -reward_zone_size <= y_pos_next <= reward_zone_size
    )


# Check if the agent is missing the reward zone by aiming it too laterally
def is_aiming_too_laterally(x_pos, y_pos, x_pos_next, y_pos_next, reward_zone_size):
    x_pos_range = np.linspace(x_pos, x_pos_next, 1001)
    y_pos_range = np.linspace(y_pos, y_pos_next, 1001)
    return min(np.sqrt(x_pos_range**2 + y_pos_range**2)) < np.sqrt(x_pos**2 + y_pos**2) and not (
        -reward_zone_size <= x_pos_next <= reward_zone_size and -reward_zone_size <= y_pos_next <= reward_zone_size
    )


def compute_gae(env, states, next_states, rewards, masks, values):
    returns = []
    gae = 0  # Generalized advantage estimation

    for t in reversed(range(len(rewards))):
        success, done_state = is_reward_zone(states[t].numpy()[0][0], states[t].numpy()[0][1], next_states[t].numpy()[0][0], next_states[t].numpy()[0][1], env.reward_zone_size)
        if success:
            delta = rewards[t] - values[t]  # Single-step advantage estimator
        elif states[t].numpy()[0][0] - next_states[t].numpy()[0][0] < 0.001 and states[t].numpy()[0][1] - next_states[t].numpy()[0][1] < 0.001:  # If the movement is small
            delta = torch.tensor([0.0], dtype=torch.float32)
        elif is_moving_toward_reward_zone(states[t].numpy()[0][0], states[t].numpy()[0][1], next_states[t].numpy()[0][0], next_states[t].numpy()[0][1], env.reward_zone_size) or \
                is_aiming_too_laterally(states[t].numpy()[0][0], states[t].numpy()[0][1], next_states[t].numpy()[0][0], next_states[t].numpy()[0][1], env.reward_zone_size):
            delta = rewards[t] - values[t]
        else:  # Agent moving away from the reward zone
            delta = torch.tensor([0.0], dtype=torch.float32)

        gae = delta + gamma * gae_lambda * masks[t] * gae
        gae_return = gae + values[t]
        gae_return_tensor = torch.tensor([gae_return], dtype=torch.float32)
        returns.insert(0, gae_return_tensor)
    return returns


def ppo_update(actor_critic, actor_critic_optimizer, states, actions, log_probs_old, returns, advantages, clip_param):
    states = torch.stack(states)
    actions = torch.stack(actions)
    log_probs_old = torch.stack(log_probs_old).detach()
    returns = returns.clone().detach()
    advantages = advantages.clone().detach()

    for _ in range(int(10)):  # 10 PPO epochs per update
        log_probs, state_values, dist_entropy = actor_critic.evaluate_policy(states, actions)
        ratios = torch.exp(log_probs - log_probs_old)  # ratio for PPO
        surr1 = ratios * advantages
        surr2 = torch.clamp(ratios, 1.0 - clip_param, 1.0 + clip_param) * advantages

        # Coefficient
        actor_loss_coef = 1  # Actor loss coefficient
        critic_loss_coef = 0.2  # Critic loss coefficient
        entropy_coef = 0.02  # Entropy regularization coefficient

        actor_loss = -torch.min(surr1, surr2).mean()  # Ensure scalar output
        critic_loss = (returns - state_values).pow(2).mean()  # Ensure scalar output

        loss = critic_loss_coef * critic_loss + actor_loss_coef * actor_loss - entropy_coef * dist_entropy.mean()  # Ensure scalar output

        actor_critic_optimizer.zero_grad()
        loss.backward()

        # Clip gradients
        torch.nn.utils.clip_grad_norm_(actor_critic.parameters(), max_norm=0.4)

        actor_critic_optimizer.step()


def evaluate(actor_critic, env, eval_episodes):
    eval_rewards = []
    mean_eval_reward = []
    episode_data = []

    for episode in range(eval_episodes):
        state = env.reset()
        episode_reward = 0
        done = False
        episode_states = []
        episode_rpes = []

        while not done:
            state_tensor = torch.tensor(state, dtype=torch.float32).unsqueeze(0)
            _, value = actor_critic(state_tensor)
            action, _ = actor_critic.act(state_tensor)
            next_state, reward, done, _ = env.step(action)

            success, done_state = is_reward_zone(state[0], state[1], next_state[0], next_state[1], env.reward_zone_size)
            if success:
                rpe = reward - value
            elif state[0] - next_state[0] < 0.001 and state[1] - next_state[1] < 0.001:  # If the movement is small
                rpe = torch.tensor([0.0], dtype=torch.float32)
            elif is_moving_toward_reward_zone(state[0], state[1], next_state[0], next_state[1], env.reward_zone_size) or \
                    is_aiming_too_laterally(state[0], state[1], next_state[0], next_state[1], env.reward_zone_size):
                rpe = reward - value
            else:
                rpe = torch.tensor([0.0], dtype=torch.float32)

            episode_states.append(state)
            episode_rpes.append(rpe.item())

            state = next_state
            episode_reward += reward

            if done and success:
                # Save terminal state
                episode_states.append(done_state.numpy())
                break

            if done and ~success:
                # Save terminal state
                episode_states.append(next_state)
                break

        eval_rewards.append(episode_reward)
        mean_eval_reward = np.mean(eval_rewards)
        episode_data.append({'states': episode_states, 'RPEs': episode_rpes, 'episode_reward': episode_reward})
    return mean_eval_reward, episode_data


def save_episode_data(episode_data, filename):
    with open(filename, 'wb') as f:
        pickle.dump(episode_data, f)


def convert_pickle_to_mat(pickle_file, mat_file):
    with open(pickle_file, 'rb') as f:
        episode_data = pickle.load(f)

    states = []
    rpes = []
    episode_rewards = []

    for data in episode_data:
        states.append(data['states'])
        rpes.append(data['RPEs'])
        episode_rewards.append(data['episode_reward'])

    states = np.array(states, dtype=object)
    rpes = np.array(rpes, dtype=object)
    episode_rewards = np.array(episode_rewards, dtype=object)

    data_to_save = {
        'states': states,
        'RPEs': rpes,
        'episode_rewards': episode_rewards
    }

    scipy.io.savemat(mat_file, data_to_save)


def save_model(actor_critic, filename):
    torch.save(actor_critic.state_dict(), filename)


def main(seed=seed_num, eval_episodes=100):
    np.random.seed(seed)
    torch.manual_seed(seed)
    random.seed(seed)

    env = gym.make('navigation_discrete_action-v0')
    env.seed(seed)
    env.action_space.seed(seed)
    state_dim = env.observation_space.shape[0]
    action_dim = env.action_space.n

    actor_critic = ActorCritic(state_dim, action_dim)
    actor_critic_optimizer = optim.Adam(actor_critic.parameters(), lr=lr)

    for episode in range(n_episodes):
        state = env.reset()
        episode_reward = 0

        done = False
        while not done:
            states, actions, log_probs, rewards, next_states, masks, values = [], [], [], [], [], [], []
            for t in range(n_steps):
                state_tensor = torch.tensor(state, dtype=torch.float32).unsqueeze(0)
                action, log_prob = actor_critic.act(state_tensor)
                _, value = actor_critic(state_tensor)
                next_state, reward, done, _ = env.step(action.item())

                states.append(state_tensor)
                actions.append(action)
                log_probs.append(log_prob)
                rewards.append(torch.tensor([reward], dtype=torch.float32))
                next_states.append(torch.tensor(next_state, dtype=torch.float32).unsqueeze(0))
                masks.append(torch.tensor([1 - done], dtype=torch.float32))
                values.append(value.squeeze(-1))

                state = next_state
                episode_reward += reward

                if done:
                    break

            returns = compute_gae(env, states, next_states, rewards, masks, values)

            returns_concatenated = torch.cat(returns).view(-1)
            returns = torch.tensor(returns_concatenated, dtype=torch.float32)
            values_tensor = torch.tensor(values, dtype=torch.float32)
            advantages = returns - values_tensor

            actor_critic.train()
            ppo_update(actor_critic, actor_critic_optimizer, states, actions, log_probs, returns, advantages, clip_param)

        # Evaluation and saving episode data periodically
        if episode % eval_episodes == 0:
            actor_critic.eval()
            mean_eval_reward, episode_data = evaluate(actor_critic, env, eval_episodes)
            pickle_file = f'Agent' + str(seed) + f'_episode_data_{episode}.pkl'
            save_episode_data(episode_data, pickle_file)
            print(f"Mean evaluation reward after {episode} episodes: {mean_eval_reward}")

            # Convert the pickle file to a MATLAB file
            mat_file = f'Agent' + str(seed) + f'_episode_data_{episode}.mat'
            convert_pickle_to_mat(pickle_file, mat_file)

            # Save the model
            model_file = f'Agent' + str(seed) + f'_model_{episode}.pth'
            save_model(actor_critic, model_file)


if __name__ == "__main__":
    main()