# Common Dockerfiles Repository

This repository provides a collection of common Dockerfiles for various environments and use cases.

## Available Dockerfiles

- `ros/cuda-ros-noetic.Dockerfile`: Dockerfile for ROS Noetic with CUDA support.

## Usage

You can use these Dockerfiles to build your own Docker images, or pull pre-built images from Docker Hub.

### Build Locally

To build an image locally using one of the provided Dockerfiles:

```bash
cd ros
sudo docker build -f cuda-ros-noetic.Dockerfile -t <your-tag> .
```

### Pull from Docker Hub

Pre-built images are available on Docker Hub under the user `kefhuang`.

```bash
docker pull kefhuang/<image-name>:<tag>
```

Replace `<image-name>` and `<tag>` with the appropriate values for the image you want.