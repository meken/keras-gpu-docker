#!/bin/bash

NVIDIA_DRIVER_VERSION=384.145 # CUDA 9.0 K80/V100/P100 
DOCKER_VERSION=18.03.0~ce-0~ubuntu

# In order to fix the permissions of the mapped volume, we're using the admin user, which is the first user that is
# created on the VM. In the Docker image we've got the 'jupyter' user which is also the first user, hence the
# uids match and that Docker user can read/write from/to the mapped volume (notebooks)
USER=$2

# Install the NVIDIA driver
wget -P /tmp http://us.download.nvidia.com/tesla/$NVIDIA_DRIVER_VERSION/nvidia-diag-driver-local-repo-ubuntu1604-"$NVIDIA_DRIVER_VERSION"_1.0-1_amd64.deb
dpkg -i /tmp/nvidia-diag-driver*.deb
apt-key add /var/nvidia-diag-driver-local-repo-$NVIDIA_DRIVER_VERSION/7fa2af80.pub
apt-get update && apt-get install -y --no-install-recommends cuda-drivers

# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update && apt-get install -y docker-ce="$DOCKER_VERSION"

# Assuming that docker is already installed, install nvidia-docker and nvidia-docker-plugin
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  tee /etc/apt/sources.list.d/nvidia-docker.list
apt-get update && apt-get install -y nvidia-docker2

pkill -SIGHUP dockerd

# Allow the admin user to use docker without sudo
usermod -aG docker $USER

nvidia-persistenced --user $USER

# Docker needs absolute paths for volume mapping, using the home dir for the $USER as the base
BASE_DIR=/home/$USER
sudo -i -u $USER <<EOF
# Checkout the code
git clone -b v4.0 https://github.com/meken/keras-gpu-docker.git keras

cd keras/docker

# Build the tensorflow image (based on original https://hub.docker.com/r/tensorflow/tensorflow/)
docker build -t keras:gpu .

# Leaving out the -it option as we expect this to be run silently
docker run --runtime=nvidia -d -p 80:8888 -v $BASE_DIR/keras/notebooks:/notebooks -e "PASSWORD=$1" --restart=unless-stopped keras:gpu
EOF
