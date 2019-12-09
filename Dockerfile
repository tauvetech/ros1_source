FROM ubuntu:bionic

MAINTAINER Tauve Tauvetech <"tauvetech@gmail.com">

RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install tzdata
RUN apt-get install -y git vim terminator dbus-x11 gnupg
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update
RUN apt-get install -y vim git terminator dbus-x11
#Installing bootstrap dependencies
RUN apt-get install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential
#Initializing rosdep
RUN rosdep init
RUN rosdep update
#Create a catkin Workspace
RUN mkdir ~/ros_catkin_ws
#RUN cd ~/ros_catkin_ws
WORKDIR /root/ros_catkin_ws
#Desktop-Full Install: ROS, rqt, rviz, robot-generic libraries, 2D/3D simulators, navigation and 2D/3D perception 
RUN rosinstall_generator desktop_full --rosdistro melodic --deps --tar > melodic-desktop-full.rosinstall
RUN wstool init -j8 src melodic-desktop-full.rosinstall
#resolving dependencies
RUN rosdep install --from-paths src --ignore-src --rosdistro melodic -y
RUN ./src/catkin/bin/catkin_make_isolated --install --install-space /opt/ros/melodic/release -DCMAKE_BUILD_TYPE=Release

