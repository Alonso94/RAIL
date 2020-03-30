#!/bin/bash

set -e

Xvfb :1 -screen 0 1600x1200x16  &
export DISPLAY=:1.0

source /opt/ros/melodic/setup.bash
source  /root/low_cost_ws/devel/setup.bash

roslaunch locobot_control main.launch use_base:=true use_sim:=true &
source /root/pyrobot_catkin_ws/devel/setup.bash
source /root/pyenv_pyrobot_python3/bin/activate

exec "$@"