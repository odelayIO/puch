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
#      2023-04-18    Original Creation
#
# ############################################################################################
# ############################################################################################

OVERLAY_NAME := kr260_hls_fixed_gain_stream
DESIGN_NAME := kr260_hls_fixed_gain_stream


default: clean_all hls_ip reg_if build_design check_timing  
## default: Performs a 'clean_all' and builds eveything from souce
	@echo
	@tput setaf 2 ; echo "Built $(OVERLAY_NAME) successfully!"; tput sgr0;
	@echo

help:     	
## help: This helpful list of commands
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/-/'


hls_ip:  		
## hls_ip: Build only the HLS IP Cores
	cd ./fpga/lib/fixed-gain-stream && vitis_hls -f run_hls.tcl && pwd

reg_if:  		
## reg_if: Builds only the Corsair Register File Modules
	cd ./fpga/lib/led_reg && make && pwd

build_design: clean 
## build_design: Builds the Vivado project without regenerating Lib
	mkdir -p ./fpga/top/output/Reports
	cd ./fpga/top && vivado -mode batch -source build_kr260_hls_fixed_gain_stream.tcl
	mv ./fpga/top/output . 

check_timing:  
## check_timing: Check FPGA Timing
	cd ./fpga/top && vivado -mode batch -source check_$(OVERLAY_NAME).tcl -notrace

start_gui:		
## start_gui: Start Vivado GUI
	vivado ./fpga/top/${DESIGN_NAME}/${OVERLAY_NAME}.xpr

clean_all:		
## clean_all: Cleans everything, deletes all generated files
	rm -fr ./fpga/lib/fixed-gain-stream/proj_fixed_gain_stream
	rm -fr ./fpga/lib/fixed-gain-stream/*.log
	rm -fr ./fpga/lib/fixed-gain-stream/*.jou
	cd ./fpga/top && rm -rf $(OVERLAY_NAME) *.jou *.log NA *.bit *.hwh *.xsa .Xil
	rm -fr *.log *.jou *.str .Xil
	rm -fr ./output
	rm -fr ./fpga/top/output

clean:				
## clean: Just cleans the Vivado build.  Lib is not cleaned
	cd ./fpga/top && rm -rf $(OVERLAY_NAME) *.jou *.log NA *.bit *.hwh *.xsa .Xil
	rm -fr *.log *.jou *.str .Xil
	rm -fr ./output
	rm -fr ./fpga/top/output

upload_all: upload_bit upload_regmaps upload_ipynb  
## upload_all: Upload image to KR260 board

upload_bit:		
## upload_bit: Upload only the bitstream and hardware file
	scp ./output/${OVERLAY_NAME}.bit \
	./output/${OVERLAY_NAME}.hwh \
	ubuntu@kria:/home/root/jupyter_notebooks/kr260_hls_fixed_gain_stream

upload_ipynb:	
## upload_ipynb: Uploads only the Jupyter notebooks
	scp ./host/py/${OVERLAY_NAME}.ipynb \
	ubuntu@kria:/home/root/jupyter_notebooks/kr260_hls_fixed_gain_stream

upload_regmaps: 		
## upload_regmaps: Uploads the Corsair Register Map Python Classes
	scp ./fpga/lib/led_reg/sw/led_regmap.py \
	ubuntu@kria:/home/root/jupyter_notebooks/kr260_hls_fixed_gain_stream

get_remote_ipynb:		
## get_remote_ipynb: Copy the Jupyter Notebook from KR260 to host
	scp ubuntu@kria:/home/root/jupyter_notebooks/kr260_hls_fixed_gain_stream/${OVERLAY_NAME}.ipynb ./host/py/.
