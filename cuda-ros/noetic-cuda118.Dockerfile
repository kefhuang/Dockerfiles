FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# System Configuration
# -------------------
# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install basic system dependencies
RUN apt-get update && apt-get install -y \
    locales \
    lsb-release \
    curl \
    tmux \
    python-is-python3 \
    && dpkg-reconfigure locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ROS Installation
# ---------------
# Setup ROS sources
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# Install ROS packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ros-noetic-desktop-full \
       python3-rosdep \
       python3-catkin-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init \
    && rosdep fix-permissions \
    && rosdep update

# Workspace Setup
# --------------
# Setup ROS workspace environment
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

# Set working directory
WORKDIR /root/catkin_ws

# Set entrypoint
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["source /opt/ros/noetic/setup.bash && exec bash"]
