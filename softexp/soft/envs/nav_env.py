import os
import time
from os.path import expanduser

import gym
import numpy as np
import pyrobot
from gym import spaces
from gym.utils import seeding



class NavEnv(gym.Env):
    # Velocity control for a navigation task
    # this is just for gym formality, not using it
    metadata = {
        'render.modes': ['human', 'rgb_array'],
        'video.frames_per_second': 50
    }

    def __init__(self):
        self.robot=pyrobot.Robot('locobot')

        self._renders = False
        self._urdf_root = None  # path to the urdf
        self._action_dim = 2  # linear, rotational velocities
        observation_dim = 5 # (x,y,yaw) from odometry or visual-slam + linear and rotational velocity
        self._collision_check = True  # whether to do collision check while simulation
        observation_high = np.ones(observation_dim) * 100
        self._action_bound = 1
        action_high = np.array([self._action_bound] * self._action_dim)
        self.action_space = spaces.Box(-action_high, action_high)
        self.observation_space = spaces.Box(-observation_high, observation_high)

        self.execution_time=1
        self._num_steps = 0
        self._max_episode_steps = 25
        self._threshold = 0.01  # (distance in m) if robot reaches within this distance, goal is reached
        self._action_rew_coeff = 0
        self._reaching_rew = 1  # reward if robot reaches within threshold distance from goal

    def _seed(self, seed=None):
        self.np_random, seed = seeding.np_random(seed)
        return [seed]

    def reset(self):
        self._goal = self._get_goal()
        self._num_steps = 0
        vel=[0,0]
        pos=self.robot.get_state('odom')
        state=np.array(pos+ self._goal + vel)
        return state

    def step(self, a):
        self._num_steps += 1
        # get the new_theta
        self.linear_velocity=a[0]
        self.rotational_velocity=a[1]
        self.robot.base.set_vel(fwd_speed=self.linear_velocity,
                                turn_speed=self.rotational_velocity,
                                exe_time=self.execution_time)
        # self.robot.base.stop()
        pos = self.robot.get_state('odom')
        vel=[self.linear_velocity,self.rotational_velocity]
        state = np.array(pos + self._goal + vel)
        dist, rew = self._cal_reward(pos[:2],self._goal,vel)
        if dist < self._threshold and vel[0]<0.01 and vel[1]<0.01:
            return state, self._reaching_rew, True, {}

        return state, rew, self._num_steps >= self._max_episode_steps, {}

    def _get_goal(self):
        pos = self.robot.get_state('odom')
        goal = [np.random.rand() - 5 + pos[0],
                np.random.rand() - 5 + pos[1]]
        return list(goal)


    def _cal_reward(self, pos,goal,a):
        dist = np.linalg.norm(np.array(pos) - np.array(goal), ord=2)
        return dist, -dist - self._action_rew_coeff * np.mean(np.abs(a))
