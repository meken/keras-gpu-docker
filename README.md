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

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmeken%2Fkeras-gpu-docker%2Fv3.0%2Fazure%2Fazuredeploy.json)
[![Visualize](http://armviz.io/visualizebutton.png)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fmeken%2Fkeras-gpu-docker%2Fv3.0%2Fazure%2Fazuredeploy.json)

> Please note that NC-series (GPU enabled instances) are not available in all
> regions, the location parameter reflects that by allowing only the regions
> where these instances are available. 

This basically provisions an N-series instance running Ubuntu on Azure. The machine has 
nvidia-docker installed and starts the Jupyter notebooks with a sample notebook 
of how to build an LSTM model using Keras. You can access Jupyter through the 
VM's DNS name, and/or connect to the machine through SSH.

Everything is setup to utilize the GPU of the machine for the training. Note 
that the sample notebook only utilizes a single GPU; with Keras currently you 
can only do model parallelization (training multiple models and averaging
outcomes) if you want to go for multiple GPUs. If you need to do data 
parallelization, you might need to access the underlying tensorflow layers
and implement that yourself.


