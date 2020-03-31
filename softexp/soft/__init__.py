from gym.envs.registration import register

register(
    id='locobotnav-v0',
    entry_point='soft.envs:NavEnv',
)