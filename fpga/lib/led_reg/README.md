# LED Register File Module

This module provides a AXI-lite interface which has a register mapped to the two user LEDs on the [KR260](https://www.xilinx.com/products/som/kria/kr260-robotics-starter-kit.html) carrier board.

The LED Register module is autogenerated using [Corsair](https://github.com/odelayIO/corsair-reg-map) generator.  The `doc`, `hw`, and `sw` folders are autogenerated from the `led_reg.yaml` file.  These files are committed into the repository, so the end-user doesn't need to install and configure `Corsair`.



## Folder Description

| Folder/File Name | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| doc              | This is autogenerated folder and contains `led_reg.md` file which has all the details of the file register(s). |
| hw               | This is autogenerated folder and contains the VHDL modules.<br /><br />`led_pkg.vhd` : Package file with register map used for simulation<br />`led_reg.vhd` : VHDL register module |
| sw               | This is autogenerated folder and contains the `led_regmap.py` package required for the PYNQ Jupyter Notebook.   <br /><br />`led_reg.py`: Python package file with register map used for Jupyter Notebook. |
| Makefile         | Makefile for building the `led_reg` module using `Corsair`.  |
| csrconfig        | `Corsair` configuration file for Control and Status registers |
| led_reg.yaml     | `Corsair` configure files used as an input to generate the source code. |



## Register Map

[LED Register Map](https://github.com/odelayIO/KR260-HLS-Fixed-Gain-Stream/blob/doc-and-bugs/fpga/lib/led_reg/doc/led_reg.md)





## Requirements

Must install the following packages:

```bash
apt install python3-pip
pip3 install pyyaml
pip3 install Jinja2
pip3 install wavedrom 
```



## Usage

Just run the following command:

```bash
cd ./fpga/lib/led_reg
make
```


