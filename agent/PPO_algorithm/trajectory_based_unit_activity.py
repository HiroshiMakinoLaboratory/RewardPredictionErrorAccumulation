import numpy as np
import gym
import sys
import scipy.io
import torch
import torch.nn as nn
from torch.distributions import Categorical

sys.path.append('/home/user/Documents/Error/gym-navigation/')
import gym_navigation

# Hyperparameters
seed_num = 0
n_steps = 8
episode_num = 4000

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
        return Categorical(action_probs), value

# Load the model
env = gym.make('navigation_discrete_action-v0')
state_dim = env.observation_space.shape[0]
action_dim = env.action_space.n
actor_critic = ActorCritic(state_dim, action_dim)
actor_critic.load_state_dict(torch.load('/home/user/PycharmProjects/Error/Revision/PPO/Original/lr_1e-05_gamma_095_lambda_095_value_02_entropy_002/Agent' + str(seed_num) + '_nstep' + str(n_steps) + '/Agent' + str(seed_num) + '_model_' + str(episode_num) + '.pth'))


# Define the saving function
def save_trajectories_and_unit_activities_to_matlab_file(trajectories, activations, filename):
    data_to_save = {
        'trajectories': trajectories,
        'activations': activations
    }
    scipy.io.savemat(filename, data_to_save)


# Load trajectories
data = scipy.io.loadmat('/home/user/PycharmProjects/Error/Revision/PPO/Original/lr_1e-05_gamma_095_lambda_095_value_02_entropy_002/Agent' + str(seed_num) + '_nstep' + str(n_steps) + '/Agent' + str(seed_num) + '_episode_data_' + str(episode_num) + '.mat')
concatenated_states = np.concatenate([data['states'][0][episode] for episode in range(100)])
trajectories = torch.tensor(concatenated_states, dtype=torch.float32)

# Create a global dictionary to store activations
activations = {}


# Define the hook function
def hook_fn(module, input, output):
    layer_name = module._get_name()
    if layer_name not in activations:
        activations[layer_name] = []
    activations[layer_name].append(output.detach().cpu().numpy())


# Function to provide a unique name for each ReLU layer
def get_layer_name(layer, counter):
    return f'ReLULayer{counter}'


# Register a forward hook on each nn.ReLU layer of the network
def register_hooks(actor_critic):
    layer_counter = 0
    for layer in actor_critic.common_layers:
        if isinstance(layer, nn.ReLU):
            layer._get_name = lambda layer=layer, layer_counter=layer_counter: get_layer_name(layer, layer_counter)

            # Register the hook
            layer.register_forward_hook(hook_fn)

            # Increment the layer counter
            layer_counter += 1


# Register hooks on the ReLU layers
register_hooks(actor_critic)

# Now, when you make a forward pass through the network, the hook function will be called for each layer
action_dists, values = actor_critic(trajectories)

# Convert the outputs to numpy arrays
trajectories = trajectories.detach().cpu().numpy()

# Convert each tensor in activations to a numpy array
for layer_name in activations:
    activations[layer_name] = np.concatenate(activations[layer_name], axis=0)

# Save the random inputs and critic outputs to a MATLAB file
matlab_filename = 'Agent' + str(seed_num) + '_nstep' + str(n_steps) + '_episode' + str(episode_num) + '_trajectory_based_unit_activity.mat'
save_trajectories_and_unit_activities_to_matlab_file(trajectories, activations, matlab_filename)
