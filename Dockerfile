FROM ros:melodic

LABEL maintainer="ay20-5-1994@hotmail.com"

RUN apt update
RUN apt install -y sudo \
    apt-utils \
    lsb-release \
    python-rosdep\
    ros-melodic-rqt-robot-dashboard \
    ros-melodic-gazebo-plugins

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

COPY entrypoint.sh /
RUN ["chmod","+x","/entrypoint.sh"]
ENTRYPOINT ["/bin/bash","/entrypoint.sh"]

CMD ["/bin/bash"]

