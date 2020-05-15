FROM ros:kinetic-robot-xenial
LABEL maintainer="bahatitadjuidje@gmail.com"

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN sudo sh -c '. /etc/lsb-release && echo "deb http://mirrors.ustc.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'


RUN apt-get update && apt-get install --assume-yes \
  sudo \
  python-pip \
  ros-kinetic-catkin\
  ros-kinetic-desktop-full \
  ros-kinetic-turtlebot3 \
  ros-kinetic-turtlebot3-bringup \
  ros-kinetic-turtlebot3-description \
  ros-kinetic-turtlebot3-fake \
  ros-kinetic-turtlebot3-gazebo \
  ros-kinetic-turtlebot3-msgs \
  ros-kinetic-turtlebot3-navigation \
  ros-kinetic-turtlebot3-simulations \
  ros-kinetic-turtlebot3-slam \
  ros-kinetic-turtlebot3-teleop

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        python-catkin-tools  \
        python-rosdep \
        python-rosinstall-generator \
        python-wstool \
            bash-completion \
            byobu \
            git \
            less \
            tree \
            wget \
            python-pip && \
    rm -rf /var/lib/apt/lists/*
    
# create non-root user
ENV USERNAME ros
RUN adduser --ingroup sudo --disabled-password --gecos "" --shell /bin/bash --home /home/$USERNAME $USERNAME
RUN bash -c 'echo $USERNAME:ros | chpasswd'
ENV HOME /home/$USERNAME
USER $USERNAME

# create catkin_ws
RUN mkdir /home/$USERNAME/catkin_ws

#add turtlebot simulation package
RUN mkdir /home/$USERNAME/catkin_ws/src/
ADD turtlebot3_simulation-master /home/$USERNAME/catkin_ws/src/
WORKDIR /home/$USERNAME/catkin_ws
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; catkin_make'
# add catkin env
RUN echo 'source /opt/ros/kinetic/setup.bash' >> /home/$USERNAME/.bashrc
RUN echo 'source /home/$USERNAME/catkin_ws/devel/setup.bash' >> /home/$USERNAME/.bashrc



