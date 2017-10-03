FROM nvidia/cuda:8.0-cudnn6-devel

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        rsync \
        software-properties-common \
        unzip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 --no-cache-dir install \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        scipy \
        sklearn \
        Pillow \
        pandas \
        seaborn \
        keras \
        && \
    python3 -m ipykernel.kernelspec

# Install TensorFlow GPU version from central repo
RUN pip3 --no-cache-dir install tensorflow-gpu

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

# We'd like to run jupyter with the non-root user jupyter
RUN useradd -ms /bin/bash jupyter

WORKDIR "/home/jupyter/"

# Set up our notebook config.
COPY jupyter_notebook_config.py .jupyter/

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh .

# ADD/COPY doesn't respect the USER option:
#   https://github.com/moby/moby/issues/6119
# Fixing it by adding another layer :(
RUN chown -R jupyter:jupyter .

# Assuming that this will be a mapped volume that will have the same uid/gid as the jupyter user
RUN mkdir /notebooks

USER "jupyter"

CMD ["./run_jupyter.sh", "/notebooks"]
