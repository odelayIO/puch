# Introduction

This project is based on FPGA Developer's project [How to accelerate a Python function with PYNQ](https://www.fpgadeveloper.com/2018/03/how-to-accelerate-a-python-function-with-pynq.html/).  

The following modification to the original project: 

- Retargeted design for the [Kria KR206 Board](https://www.xilinx.com/products/som/kria/kr260-robotics-starter-kit.html)

- Upgraded the project for **PYNQ Version 3.0** using **Xilinx Vivado 2022.1**

- Updated the Jupyter Notebook to use memory buffers created by `allocate` DMA library.
  - Read The Docs: https://pynq.readthedocs.io/en/v3.0.0/pynq_libraries/dma.html
  
- Created a `makefile` similar to the base design in the [PYNQ Z1 repository](https://github.com/odelayIO/PYNQ-Z1-FIR-Acceleration/tree/vivado-2022.1)

  



# Building Overlay 

This project uses the Vivado 2022.1 Docker Container from [odelayIO/vivado2022.1_docker](https://github.com/odelayIO/vivado2022.1_docker) repository.  Once the Docker container is created, just execute the run file.  See repository for instructions how to modify the [run.sh](https://github.com/odelayIO/vivado2022.1_docker/blob/master/run.sh) script.

Clone the project:

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
cd fpga/overlays/KR260-FIR-Acceleration/
make all
```





# Running on the KR260 Board

Now upload the following files to the KR260 Board:

```
scp kr260_fir_accel.bit kr260_fir_accel.hdf kr260_fir_accel.hdf kr260fir_accel.hwh ../../py/KR260-FIR-Acceleration/kr260_fir_accel.ipynb xilinx@PYNQ:/home/xilinx/jupyter_notebooks/kr260_fir_accel
```

Open a web browser and navigate to the Jupyter Notebook, for example:

http://kria:9090/lab/tree/kr260_fir_accel/kr260_fir_accel.ipynb

Follow the instructions in the notebook
