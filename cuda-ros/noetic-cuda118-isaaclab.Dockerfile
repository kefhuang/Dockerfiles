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
    cmake \
    build-essential \
    python-is-python3 \
    && dpkg-reconfigure locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ISAACLAB Installation
# -----------------
# Install Miniconda
RUN mkdir -p /root/miniconda3 \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /root/miniconda3/miniconda.sh \
    && bash /root/miniconda3/miniconda.sh -b -u -p /root/miniconda3 \
    && rm /root/miniconda3/miniconda.sh \
    && source /root/miniconda3/bin/activate \
    && conda init bash \
    && conda config --set auto_activate_base false \
    && conda deactivate

# Install isaac sim
RUN conda create -n isaaclab python=3.10 -y \
    && conda activate isaaclab \
    && pip install torch==2.5.1 torchvision==0.20.1 --index-url https://download.pytorch.org/whl/cu118 \
    && pip install -U pip \
    && pip install 'isaacsim[all,extscache]==4.5.0' --extra-index-url https://pypi.nvidia.com 

# Install isaac lab
RUN git clone git@github.com:isaac-sim/IsaacLab.git /root/isaaclab 
WORKDIR /root/isaaclab 
RUN ./isaaclab.sh --install 

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
