OVERLAY_NAME := kr260_fir_acceleration
PROJ_DIR := xpr

default: clean build_design check_timing
	@echo
	@tput setaf 2 ; echo "Built $(OVERLAY_NAME) successfully!"; tput sgr0;
	@echo

build_design: clean
	mkdir -p ./output/Reports
	vivado -mode batch -source build_$(OVERLAY_NAME).tcl -notrace

check_timing:
	vivado -mode batch -source check_$(OVERLAY_NAME).tcl -notrace

#dsa:
#	vivado -mode batch -source build_$(OVERLAY_NAME)_dsa.tcl -notrace

clean:
	rm -rf $(OVERLAY_NAME) *.jou *.log NA *.bit *.hwh *.xsa .Xil xpr output

start_gui:		
## start_gui: Start Vivado GUI
	vivado ./${PROJ_DIR}/${OVERLAY_NAME}.xpr

