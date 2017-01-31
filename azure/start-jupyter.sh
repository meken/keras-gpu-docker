#!/bin/bash

# Getting ready for the NVIDIA driver installation
sudo apt-get install -y build-essential

# Download & install the NVIDIA driver
wget -P /tmp http://us.download.nvidia.com/XFree86/Linux-x86_64/375.26/NVIDIA-Linux-x86_64-375.26.run
chmod u+x /tmp/NVIDIA-Linux*.run
sudo /tmp/NVIDIA-Linux*.run --silent

# Assuming that docker is already installed, install nvidia-docker and nvidia-docker-plugin
wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.0/nvidia-docker_1.0.0-1_amd64.deb
sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb

# Checkout the code
git clone https://github.com/meken/keras-gpu-docker.git keras

cd keras/docker

# Build the tensorflow image (based on original https://hub.docker.com/r/tensorflow/tensorflow/)
docker build -t tensorflow:gpu .

# Leaving out the -it option as we expect this to be run silently
nvidia-docker run -d -p 80:8888 -v ~/keras/notebooks:/notebooks -e "PASSWORD=$1" tensorflow:gpu
