from gym.envs.registration import register

register(
    id='LocoBot-Nav-v0',
    entry_point='RAIL_exp.locobotEnv:LocobotGymEnv',
)