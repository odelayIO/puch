<p align="center">
  <img src="./doc/puch-logo-1.png">
</p>

<br>
<br>
<br>

***puch*** is the glue logic between Analog Devices ADALM-Pluto SDR Evaluation board and the PYNQ Z1 FPGA development board with support from GNU Radio to provide a FPGA IP core development platform in wireless communications utilizing Xilinx Vivado HLS </> VHDL </> Verilog register transfer language (RTL).

<br>
<br>

<img align="center" src="./doc/puch-detailed-level-diagram.png">

<br>
<br>
<br>

## Development Environment

It is recommended to have both devices map to a the same development folder.  This is accomplished by cloning the `puch` repository on the Ubuntu host machine, then connect the PYNQ board using `sshfs` to avoid manually transferring files.   



1. Clone `puch` on the Ubuntu host machine:

   ```bash
   git clone git@github.com:odelayIO/puch.git
   ```

2. SSH into the `PYNQ` device, and create a new folder named `push` at a desired location, then map the directory on the Ubuntu host machine on the `PYNQ` board:

   ```bash
   mkdir puch; cd puch
   sshfs sdr@192.168.1.135:/home/sdr/workspace/puch /home/xilinx/puch
   ```

   where: 

   ​		`sdr` is the user name for the Ubuntu host machine

   ​		`192.168.1.135` is the IP address for the Ubuntu host machine

   ​		`/home/sdr/workspace/puch` is the folder location of the clone repository on the Ubuntu host machine

   ​		`/home/xilinx/puch` is the location to map the development folder on the `PYNQ` device

   On the  `PYNQ` device, verify the folder was mapped:

   ```
   
   ```

   Please note you might have to install `sshfs` on the `PYNQ` device through the package manager, e.g. `sudo apt-get install sshfs`





## Downloads

[Ubuntu 22.04.1 LTE - IOS File](https://hr.releases.ubuntu.com/22.04/ubuntu-22.04.1-desktop-amd64.iso)

[Xilinx Vivado v2019.1 Install File](https://www.xilinx.com/member/forms/download/xef-vivado.html?filename=Xilinx_Vivado_SDK_2019.1_0524_1430.tar.gz)

[PYNQ Z1 v2.5 SD Card Image File](http://bit.ly/2Oubpce)



## References

### Firmware

[Xilinx Vivado HLS v2019.1 HSL Documentation](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2019_1/ug902-vivado-high-level-synthesis.pdf)

[Analog Devices ADALM-Pluto SDR](https://wiki.analog.com/university/tools/pluto/users)

[PYNQ v2.5 - Read The Docs](https://pynq.readthedocs.io/en/v2.5/)

[PYNQ Z1 FPGA Development Board](https://reference.digilentinc.com/programmable-logic/pynq-z1/reference-manual?redirect=1)



### GNU Radio 

[ZeroMQ Python](https://zeromq.org/languages/python/)

[Understanding ZMQ GRC Blocks](https://wiki.gnuradio.org/index.php/Understanding_ZMQ_Blocks)

[Creating Python OOT with gr-modtool](https://wiki.gnuradio.org/index.php?title=Creating_Python_OOT_with_gr-modtool)

[GNU Radio](https://www.gnuradio.org/) install using [PyBOMBS](https://github.com/gnuradio/pybombs)

