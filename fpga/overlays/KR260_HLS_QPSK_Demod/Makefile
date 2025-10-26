# ############################################################################################
# ############################################################################################
#
#   The MIT License (MIT)
#   
#   Copyright (c) 2023 http://odelay.io 
#   
#   Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"), to deal
#   in the Software without restriction, including without limitation the rights
#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in all
#   copies or substantial portions of the Software.
#   
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#   SOFTWARE.
#   
#   Contact : <everett@odelay.io>
#  
#   Description : Makefile for Fixed AXI Stream design
#
#   Version History:
#   
#       Date        Description
#     -----------   -----------------------------------------------------------------------
#      2025-02-05    Original Creation
#
# ############################################################################################
# ############################################################################################

OVERLAY_NAME := kr260_hls_qpsk_demod
PROJ_DIR := xpr

default: clean hls_ip reg_if build_design check_timing  
## default: Performs a 'clean' and builds eveything from souce
	@echo
	@tput setaf 2 ; echo "Built $(OVERLAY_NAME) successfully!"; tput sgr0;
	@echo

help:     	
## help: This helpful list of commands
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/-/'

hls_ip:  		
## hls_ip: Build the HLS QPSK Demod module
	cd ../../lib/HLS_QPSK_Demod && make && pwd

reg_if:  		
## reg_if: Builds only the Corsair Register File Modules
	cd ../../lib/led_reg && make && pwd
	cd ../../lib/timestamp && make && pwd
	cd ../../lib/AWGN_GNG && make && pwd
	cd ../../lib/HLS_QPSK_Demod && make check_regmap && pwd
	cd ../../lib/DMA_Data_Capture && make && pwd

build_design: clean 
## build_design: Builds the Vivado project without regenerating Lib
	mkdir -p ./output/Reports
	vivado -mode batch -source build_kr260_hls_qpsk_demod.tcl

check_timing:  
## check_timing: Check FPGA Timing
	vivado -mode batch -source check_$(OVERLAY_NAME).tcl -notrace

start_gui:		
## start_gui: Start Vivado GUI
	vivado ./${PROJ_DIR}/${OVERLAY_NAME}.xpr

clean:				
## clean: Just cleans the Vivado build.  Lib is not cleaned
	cd ../../lib/HLS_QPSK_Demod && make clean_spew && pwd
	cd ../../lib/DMA_Data_Capture && make clean_spew && pwd
	cd ../../lib/timestamp && make clean_spew && pwd
	cd ../../lib/AWGN_GNG && make clean_spew && pwd
	cd ../../lib/led_reg && make clean_spew && pwd
	rm -fr ../../lib/HLS_fixed_gain/xpr
	rm -fr ../../lib/HLS_fixed_gain/*.log
	rm -fr ../../lib/HLS_fixed_gain/*.jou
	rm -fr ../../lib/timestamp/*.log
	rm -fr ../../lib/timestamp/*.jou
	cd ../../ip/KR260 && make clean && pwd
	rm -rf ./${PROJ_DIR} *.jou *.log NA *.bit *.hwh *.xsa .Xil *.str
	rm -fr ../../py/KR260_HLS_QPSK_Demod/.ipynb_checkpoints
	rm -fr ../../py/__pycache__
	rm -fr ./output

upload_all: upload_bit upload_regmaps upload_ipynb upload_py_driver
## upload_all: Upload image to KR260 board

upload_bit:		
## upload_bit: Upload only the bitstream and hardware file
	scp ./output/${OVERLAY_NAME}.bit \
	./output/${OVERLAY_NAME}.hwh \
	ubuntu@kria:/home/root/jupyter_notebooks/${OVERLAY_NAME}

upload_ipynb:	
## upload_ipynb: Uploads only the Jupyter notebooks
	scp ../../py/${OVERLAY_NAME}/${OVERLAY_NAME}.ipynb \
	ubuntu@kria:/home/root/jupyter_notebooks/${OVERLAY_NAME}

upload_regmaps: 		
## upload_regmaps: Uploads the Corsair Register Map Python Classes
	scp ../../lib/led_reg/sw/led_regmap.py \
	../../lib/timestamp/sw/timestamp_regmap.py \
	../../lib/AWGN_GNG/sw/awgn_regmap.py \
	../../lib/HLS_QPSK_Demod/sw/qpsk_regmap.py \
	ubuntu@kria:/home/root/jupyter_notebooks/${OVERLAY_NAME}

get_remote_ipynb:		
## get_remote_ipynb: Copy the Jupyter Notebook from KR260 to host
	scp ubuntu@kria:/home/root/jupyter_notebooks/${OVERLAY_NAME}/${OVERLAY_NAME}.ipynb ../../py/${OVERLAY_NAME}/.

get_remote_py_driver:
## get_remote_py_driver: Copy PYNQ Python Driver from Dev Board
	scp ubuntu@kria:/home/root/jupyter_notebooks/${OVERLAY_NAME}/kria.py ../../py/${OVERLAY_NAME}/.

upload_py_driver:
## upload_py_driver: Copy PYNQ Python Driver to Dev Board
	scp ../../py/${OVERLAY_NAME}/kria.py \
	ubuntu@kria:/home/root/jupyter_notebooks/${OVERLAY_NAME}
