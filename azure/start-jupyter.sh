#!/bin/bash

NVIDIA_DRIVER_VERSION=375.39

# Getting ready for the NVIDIA driver installation
sudo apt-get install -y build-essential

# Download & install the NVIDIA driver
wget -P /tmp http://us.download.nvidia.com/XFree86/Linux-x86_64/$NVIDIA_DRIVER_VERSION/NVIDIA-Linux-x86_64-$NVIDIA_DRIVER_VERSION.run
chmod u+x /tmp/NVIDIA-Linux*.run
sudo /tmp/NVIDIA-Linux*.run --silent

# Assuming that docker is already installed, install nvidia-docker and nvidia-docker-plugin
wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.0/nvidia-docker_1.0.0-1_amd64.deb
sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb

# Docker needs absolute paths for volume mapping, retrieving the working directory
BASE_DIR=`pwd`

# Checkout the code
git clone https://github.com/meken/keras-gpu-docker.git keras

cd keras/docker

# Build the tensorflow image (based on original https://hub.docker.com/r/tensorflow/tensorflow/)
docker build -t tensorflow:gpu .

# Create the nvidia volume to prevent issues later, see https://github.com/NVIDIA/nvidia-docker/issues/112
docker volume create -d nvidia-docker --name nvidia_driver_$NVIDIA_DRIVER_VERSION

# Leaving out the -it option as we expect this to be run silently
nvidia-docker run -d -p 80:8888 -v $BASE_DIR/keras/notebooks:/notebooks -e "PASSWORD=$1" tensorflow:gpu
