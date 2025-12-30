

# Overview

***puch*** is the glue logic between Software Defined Radio (supporting Analog Devices ADALM-Pluto and HackRF SDR) Evaluation board and the PYNQ development boards (supporting PYNQ Z1 and KR260) with support from GNU Radio to provide a FPGA IP core development platform in wireless communications utilizing Xilinx Vivado HLS </> VHDL </> Verilog register transfer language (RTL).



![image-20250212155946539](./_static/puch-detailed-level-diagram.png)


## Development Environment

It is recommended to have both devices map to a the same development folder.  This is accomplished by cloning the `puch` repository on the Ubuntu host machine, then connect the PYNQ board using `sshfs` to avoid manually transferring files.   



1. Clone `puch` on the Ubuntu host machine:

   ```bash
   git clone --recursive git@github.com:odelayIO/puch.git
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

   On the  `PYNQ` device, verify the folder was mapped.

   Please note you might have to install `sshfs` on the `PYNQ` device through the package manager, e.g. `sudo apt-get install sshfs`



### Kria KR260 Board

See [KR260 New Board Bring Up](./KR260-New-Board-Bring-up.md)



## Downloads

[Ubuntu 22.04.1 LTE - IOS File](https://hr.releases.ubuntu.com/22.04/ubuntu-22.04.1-desktop-amd64.iso)

[Xilinx Vivado v2022.1 Install File](https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2022.1_0420_0327.tar.gz)

[PYNQ Z1 v3.0.1 SD Card Image File](https://bit.ly/pynqz1_v3_0_1)



## References

### Firmware

[Vitis High-Level Synthesis User Guide (UG1399)](https://docs.amd.com/r/2022.1-English/ug1399-vitis-hls/)

[Vivado Design Suite User Guide: System-Level Design Entry (UG895)](https://docs.amd.com/r/2022.1-English/ug895-vivado-system-level-design-entry/)

[Vivado Design Suite User Guide : Designing with IP (UG896)](https://docs.amd.com/r/2022.1-English/ug896-vivado-ip/)

[Vivado Design Suite Tcl Command Reference Guide (UG835)](https://docs.amd.com/r/2022.1-English/ug835-vivado-tcl-commands)

[Analog Devices ADALM-Pluto SDR](https://wiki.analog.com/university/tools/pluto/users)

[PYNQ Read The Docs](https://pynq.readthedocs.io/en/latest/)

[PYNQ Z1 FPGA Development Board](https://reference.digilentinc.com/programmable-logic/pynq-z1/reference-manual?redirect=1)



### GNU Radio 

[ZeroMQ Python](https://zeromq.org/languages/python/)

[Understanding ZMQ GRC Blocks](https://wiki.gnuradio.org/index.php/Understanding_ZMQ_Blocks)

[Creating Python OOT with gr-modtool](https://wiki.gnuradio.org/index.php?title=Creating_Python_OOT_with_gr-modtool)

[GNU Radio](https://www.gnuradio.org/) install using [PyBOMBS](https://github.com/gnuradio/pybombs)

