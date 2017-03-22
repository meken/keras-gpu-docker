#!/bin/bash

NVIDIA_DRIVER_VERSION=375.26
NVIDIA_DOCKER_VERSION=1.0.0
DOCKER_VERSION=1.12.6-0~ubuntu-xenial

# Getting ready for the NVIDIA driver installation
apt-get update && apt-get install -y build-essential

# Download & install the NVIDIA driver
wget -P /tmp http://us.download.nvidia.com/XFree86/Linux-x86_64/$NVIDIA_DRIVER_VERSION/NVIDIA-Linux-x86_64-$NVIDIA_DRIVER_VERSION.run
chmod u+x /tmp/NVIDIA-Linux*.run
/tmp/NVIDIA-Linux*.run --silent


# Install a specific version of docker
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" >> /etc/apt/sources.list.d/docker.list
apt-get update && apt-get install -y docker-engine="$DOCKER_VERSION"


# Assuming that docker is already installed, install nvidia-docker and nvidia-docker-plugin
wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v$NVIDIA_DOCKER_VERSION/nvidia-docker_$NVIDIA_DOCKER_VERSION-1_amd64.deb
dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb

# Docker needs absolute paths for volume mapping, retrieving the working directory
BASE_DIR=`pwd`

# Checkout the code
git clone -b v1.0 https://github.com/meken/keras-gpu-docker.git keras

cd keras/docker

# Build the tensorflow image (based on original https://hub.docker.com/r/tensorflow/tensorflow/)
docker build -t tensorflow:gpu .

# Create the nvidia volume to prevent issues later, see https://github.com/NVIDIA/nvidia-docker/issues/112
docker volume create -d nvidia-docker --name nvidia_driver_$NVIDIA_DRIVER_VERSION

# Leaving out the -it option as we expect this to be run silently
nvidia-docker run -d -p 80:8888 -v $BASE_DIR/keras/notebooks:/notebooks -e "PASSWORD=$1" tensorflow:gpu