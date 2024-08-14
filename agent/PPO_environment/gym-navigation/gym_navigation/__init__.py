from gym.envs.registration import register

register(
    id='navigation_discrete_action-v0',
    entry_point='gym_navigation.envs:navigation_discrete_actionEnv',
    max_episode_steps=60,
)

register(
    id='navigation_discrete_action_interleaved_reward-v0',
    entry_point='gym_navigation.envs:navigation_discrete_action_interleaved_rewardEnv',
    max_episode_steps=60,
)

register(
    id='navigation_discrete_action_modified_reward_function-v0',
    entry_point='gym_navigation.envs:navigation_discrete_action_modified_reward_functionEnv',
    max_episode_steps=60,
)
