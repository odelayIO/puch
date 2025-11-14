overlay_name := fir_accel
design_name := fir_accel

build: block_design bitstream check_timing
	@echo
	@tput setaf 2 ; echo "Built $(overlay_name) successfully!"; tput sgr0;
	@echo

all: build

.PHONY: build all block_design bitstream check_timing clean

#source_vivado:
#	source /tools/Xilinx/Vivado/2019.1/settings64.sh

#hls_ip:
#	vivado -mode batch -source build_$(overlay_name)_ip.tcl -notrace

block_design:
	vivado -mode batch -source $(overlay_name)_bd.tcl -notrace

bitstream:
	vivado -mode batch -source build_bitstream.tcl -notrace

check_timing:
	vivado -mode batch -source check_$(overlay_name).tcl -notrace

#dsa:
#	vivado -mode batch -source build_$(overlay_name)_dsa.tcl -notrace

clean:
	rm -rf $(overlay_name) *.jou *.log NA *.bit *.hwh *.xsa .Xil

#	upload:
#		scp ${overlay_name}.bit \
#		${overlay_name}.hwh \
#		${overlay_name}.ipynb xilinx@PYNQ:/home/xilinx/jupyter_notebooks/fir_accel
#	
#	get_remote_ipynb:
#		scp xilinx@PYNQ:/home/xilinx/jupyter_notebooks/fir_accel/${overlay_name}.ipynb .
