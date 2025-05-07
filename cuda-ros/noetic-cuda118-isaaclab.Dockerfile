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
    wget \
    git \
    tmux \
    unzip \
    cmake \
    build-essential \
    python-is-python3 \
    && dpkg-reconfigure locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ISAACLAB Installation
# -----------------
# Insatll Isaac Sim binaries
RUN mkdir -p /root/isaacsim \
    && wget https://download.isaacsim.omniverse.nvidia.com/isaac-sim-standalone%404.5.0-rc.36%2Brelease.19112.f59b3005.gl.linux-x86_64.release.zip -O /root/isaacsim.zip\
    && unzip /root/isaacsim.zip -d /root/isaacsim \
    && rm -f /root/isaacsim.zip 
RUN echo "# Isaac Sim root directory" >> ~/.bashrc \
    && echo "export ISAACSIM_PATH=\"/root/isaacsim\"" >> ~/.bashrc \
    && echo "# Isaac Sim python executable" >> ~/.bashrc \
    && echo "export ISAACSIM_PYTHON_EXE=\"\${ISAACSIM_PATH}/python.sh\"" >> ~/.bashrc

# Install isaac lab
RUN git clone https://github.com/isaac-sim/IsaacLab.git /root/isaaclab 
WORKDIR /root/isaaclab 
RUN ln -s /root/isaacsim _isaac_sim
RUN TERM=xterm /root/isaaclab/isaaclab.sh --install 

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
