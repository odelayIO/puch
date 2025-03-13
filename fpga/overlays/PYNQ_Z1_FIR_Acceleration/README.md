# Introduction

This project is based on FPGA Developer's project [How to accelerate a Python function with PYNQ](https://www.fpgadeveloper.com/2018/03/how-to-accelerate-a-python-function-with-pynq.html/).  

The following modification to the original project: 

- Upgraded the project for **PYNQ Version 3.0.1** using **Xilinx Vivado 2022.1**

- Updated the Jupyter Notebook to use memory buffers created by `allocate` DMA library.
  - Read The Docs: https://pynq.readthedocs.io/en/latest/
  
  



# Building Overlay

Clone repo and build project:

```shell
git clone --recursive git@github.com:odelayIO/puch.git
cd puch
```

Open Docker container:

```shell
./run-docker-vivado-2022.1.sh
```

Build Overlay

```shell
cd fpga/overlays/PYNQ-Z1-FIR-Acceleration/
make all
```



If everything was successful, the following message will be displayed on the terminal:

```shell
Built fir_accel successfully!
```



# Running on PYNQ Z1 Board

Now upload the following files to the PYNQ Z1 Board:

```shell
scp fir_accel.bit fir_accel.hdf fir_accel.hdf fir_accel.hwh ../../py/PYNQ-Z1-FIR-Acceleration/fir_accel.ipynb xilinx@PYNQ:/home/xilinx/jupyter_notebooks/fir_accel
```

Open a web browser and navigate to the Jupyter Notebook, for example:

```shell
http://PYNQ:9090/notebooks/fir_accel/fir_accel.ipynb
```

Follow the instructions in the notebook
