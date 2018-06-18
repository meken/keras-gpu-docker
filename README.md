## Updates

### 2018-06-18
* Switched to Python3
* Included the latest nvidia driver (384.145)
* Upgraded to CUDA 9.0 and cuDNN 7.0
* Upgraded to nvidia-docker2
* Added support for CNTK (cntk-gpu v2.5.1)
* Upgraded to keras v2.2.0, tensorflow-gpu v1.8.0
* Docker 18.03

# Predicting time series with LSTMs

This repository contains data and a sample notebook to build a simple time series 
model using an LSTM network. In order to build and train the model, we're using the 
[Keras](https://keras.io/) framework on top of the
[Tensorflow](https://www.tensorflow.org/) library. The code is
executed on GPUs through [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
for efficiency purposes. 

Although the sample data and the model are trivial and hence don't require GPUs, 
this should give a starting point for more elaborate models and larger datasets.

### Running it on Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmeken%2Fkeras-gpu-docker%2Fv4.0%2Fazure%2Fazuredeploy.json)
[![Visualize](http://armviz.io/visualizebutton.png)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fmeken%2Fkeras-gpu-docker%2Fv4.0%2Fazure%2Fazuredeploy.json)

> Please note that NC-series (GPU enabled instances) are not available in all
> regions, please keep that in mind when selection the location 

This basically provisions an N-series instance running Ubuntu on Azure. The machine has 
nvidia-docker installed and starts the Jupyter notebooks with a sample notebook 
of how to build an LSTM model using Keras. You can access Jupyter through the 
VM's DNS name, and/or connect to the machine through SSH.

Everything is setup to utilize the GPU of the machine for the training. Note 
that the sample notebook only utilizes a single GPU; with Keras currently you 
can only do model parallelization (training multiple models and averaging
outcomes). If you need to do data parallelization, you might want to consider the [Horovod](https://github.com/uber/horovod) project.


