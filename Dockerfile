FROM ros:melodic

LABEL maintainer="ay20-5-1994@hotmail.com"

RUN apt update
RUN apt install -y -f sudo \
    python3 python3-dev python3-pip build-essential apt-utils \
    ros-melodic-rqt-robot-dashboard \
    ros-melodic-gazebo-plugins \
    python3-empy
RUN sudo -H pip3 install rosdep rospkg rosinstall_generator rosinstall wstool vcstools catkin_tools catkin_pkg

RUN sudo dpkg --configure -a

COPY LoCoBot_install_all.sh /
RUN chmod +x LoCoBot_install_all.sh
RUN echo yes | ./LoCoBot_install_all.sh -t sim_only -p 3

RUN sudo apt install -y xvfb

ENV VENV=/root/pyenv_pyrobot_python3
RUN python3 -m virtualenv --python=usr/bin/python3.6 $VENV
ENV PATH="$VENV/bin:$PATH"

RUN pip3 install cLick \
    gym \
    numpy \
    ray[tune] \
    pandas \
    scikit-image \
    scikit-video \
    scipy \
    tensorflow \
    tfp-nightly
#    tensorflow==2.2.0rc0 \
#    tensorflow-addons==0.8.3 \
#    tensorflow-estimator==2.1.0 \
#    tfp-nightly>=0.10.0.dev20200313

COPY softexp softexp
RUN cd softexp &&\
    pip3 install -e .

COPY softlearning softlearning
RUN cd softlearning &&\
    pip3 install -e .

COPY tf2_for_python3.sh /
RUN chmod +x tf2_for_python3.sh
RUN echo yes | ./tf2_for_python3.sh

COPY entrypoint.sh /
RUN ["chmod","+x","/entrypoint.sh"]
ENTRYPOINT ["/bin/bash","/entrypoint.sh"]

CMD ["/bin/bash"]