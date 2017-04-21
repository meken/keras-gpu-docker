FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python \
        python-dev \
        rsync \
        software-properties-common \
        unzip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
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
    python -m ipykernel.kernelspec

# Install TensorFlow GPU version from central repo
RUN pip --no-cache-dir install \
    http://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.0.1-cp27-none-linux_x86_64.whl

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

RUN mkdir notebooks

# ADD/COPY doesn't respect the USER option:
#   https://github.com/moby/moby/issues/6119
# Fixing it by adding another layer :(
RUN chown -R jupyter:jupyter .

USER "jupyter"

CMD ["./run_jupyter.sh", "notebooks"]
