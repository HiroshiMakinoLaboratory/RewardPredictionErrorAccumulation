"""
Environment for continuous state and discrete action spaces.
"""

import numpy as np
import math
import random
import gym
from gym import spaces
from gym.utils import seeding

class navigation_discrete_actionEnv(gym.Env):
    metadata = {}

    def __init__(self):
        self.reward_zone_size = 0.4
        self.min_x_pos = -1.0
        self.max_x_pos = 1.0
        self.min_y_pos = -1.0
        self.max_y_pos = 1.0
        self.min_speed = 0.0
        self.max_speed = 1.2  # Corresponding to 60 cm/s of the object movement if the step size is considered to be 100 ms.

        self.low_state = np.array([self.min_x_pos, self.min_y_pos])
        self.high_state = np.array([self.max_x_pos, self.max_y_pos])

        self.observation_space = spaces.Box(low=self.low_state, high=self.high_state, dtype=np.float32)
        self.action_space = spaces.Discrete(256)  # 25% movement.

        self.seed()
        self.reset()

    def seed(self, seed=None):
        _, seed = seeding.np_random(seed)
        return [seed]

    def step(self, action):
        x_pos = self.state[0]
        y_pos = self.state[1]
        max_speed_value = self.max_speed

        no_movement_action_idx = list(range(0, 192))  # 75% no movement.
        if action in no_movement_action_idx:
            action_direction = random.randint(1, 8)
            action_speed = 0
            x_pos_prev = x_pos
            y_pos_prev = y_pos
            x_pos = x_pos
            y_pos = y_pos
        else:
            action_direction = action % 8 + 1
            action_speed_angle = np.round((math.cos(2*((action_direction - 1)*(math.pi/4) + math.pi/4)) + 1.5)/2.5, 1)  # Diagonal bias in movement.
            action_speed_multiplier = np.round(0.3 + 0.1*((action - len(no_movement_action_idx))//8), 1)  # 8 different speed bins.
            action_speed = max_speed_value*action_speed_angle*action_speed_multiplier
            x_pos_prev = x_pos
            y_pos_prev = y_pos
            x_pos += action_speed*math.cos((math.pi/4)*(action_direction - 1))
            y_pos += action_speed*math.sin((math.pi/4)*(action_direction - 1))
 
        # Edge.
        if x_pos <= self.min_x_pos:
            x_pos = self.min_x_pos
        if x_pos >= self.max_x_pos:
            x_pos = self.max_x_pos
        if y_pos <= self.min_y_pos:
            y_pos = self.min_y_pos
        if y_pos >= self.max_y_pos:
            y_pos = self.max_y_pos
        
        # Flag if the agent reaches the reward zone.
        x_pos_range = np.linspace(x_pos_prev, x_pos, 1001)
        y_pos_range = np.linspace(y_pos_prev, y_pos, 1001)

        reach_reward_zone = []
        for bin_num in range(len(x_pos_range)):
            reach_reward_zone.append(-self.reward_zone_size <= x_pos_range[bin_num] <= self.reward_zone_size and -self.reward_zone_size <= y_pos_range[bin_num] <= self.reward_zone_size)
        done = any(reach_reward_zone)

        reward = 0
        if done:
            reward = 1.0

        self.state = np.array([x_pos, y_pos], dtype=np.float32)
        return self.state, reward, done, {}

    def reset(self):
        # Start position.
        x_pos_start = np.random.uniform(low=self.min_x_pos, high=self.max_x_pos)
        y_pos_start = np.random.uniform(low=self.min_y_pos, high=self.max_y_pos)

        # Set the start position to be outside the reward zone.
        while -self.reward_zone_size <= x_pos_start <= self.reward_zone_size and -self.reward_zone_size <= y_pos_start <= self.reward_zone_size:
            x_pos_start = np.random.uniform(low=self.min_x_pos, high=self.max_x_pos)
            y_pos_start = np.random.uniform(low=self.min_y_pos, high=self.max_y_pos)

        self.state = np.array([x_pos_start, y_pos_start])
        return self.state
