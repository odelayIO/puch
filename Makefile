OVERLAY			= KR260_HLS_QPSK_Demod

default: help

.PHONY: help
help: 
	@echo "  "
	@echo "Overlay List:"
	cd ./fpga/overlays && ls -al
	@echo "  "
	@echo "Supported commands:"
	@echo "  		build_overlay		: Build FPGA overlay, OVERLAY=<overlay_name>. DEFAULT : ${OVERLAY}"
	@echo "  		open_overlay		: Open the Xilinx Vivado project in GUI, OVERLAY=<overlay_name>. DEFAULT : ${OVERLAY}"
	@echo "  "


.PHONY: build_overlay
build_overlay: 
	## build_overlay: Build FPGA overlay, OVERLAY=<overlay_name>. DEFAULT : ${OVERLAY}
	cd ./fpga/overlays/${OVERLAY}/ && make && pwd

.PHONY: open_overlay
open_overlay: 
	## open_overlay: Open the Xilinx Vivado project in GUI, OVERLAY=<overlay_name>. DEFAULT : ${OVERLAY}
	cd ./fpga/overlays/${OVERLAY}/ && make start_gui && pwd
