# Cuda-ROS

## Example Commands

### 1. Connect to local display, network and gpu
```
xhost +
docker run -it --net=host --gpus all \
    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$(pwd)/src:/root/catkin_ws/src" kefhuang/cuda-ros:noetic-cuda118-franka bash
```
### 2. Connect local display, network and gpu, and devices
```
xhost +
docker run -it --privileged --net=host --gpus all \
    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --device="/dev:/dev" \
    --volume="$(pwd)/src:/root/catkin_ws/src" kefhuang/cuda-ros:noetic-cuda118-realsense bash
``` 

### 2. To test realsense
```
docker run -it --privileged --net=host --gpus all \
    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/dev:/dev" \
    --device-cgroup-rule "c 81:* rmw" \
    --device-cgroup-rule "c 189:* rmw" \
    --volume="$(pwd)/src:/root/catkin_ws/src" \ 
    kefhuang/cuda-ros:noetic-cuda118-realsense bash
```