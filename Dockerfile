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

COPY test.py /

RUN sudo apt install -y xvfb

RUN pip3 install -U cLick \
    gym \
    numpy \
    ray[tune] \
    pandas \
    scikit-image \
    scikit-video \
    scipy \
    tensorflow \
    tfp-nightly

COPY softlearning softlearning
RUN cd softlearning \
    pip install -e .

COPY tf2_for_python3.sh /
RUN chmod +x tf2_for_python3.sh
RUN echo yes | ./tf2_for_python3.sh

COPY entrypoint.sh /
RUN ["chmod","+x","/entrypoint.sh"]
ENTRYPOINT ["/bin/bash","/entrypoint.sh"]

CMD ["/bin/bash"]

