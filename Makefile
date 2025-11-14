OVERLAY			= KR260_AWGN_DMA_Stream

default: help

.PHONY: help
help: 
	@echo "  "
	@echo "Overlay List:"
	cd ./fpga/overlays && ls -al
	@echo "  "
	@echo "Supported commands:"
	@echo "   build_overlay     	: Build FPGA overlay, OVERLAY=<overlay_name>. DEFAULT : ${OVERLAY}"
	@echo "   open_overlay      	: Open the Xilinx Vivado project in GUI, OVERLAY=<overlay_name>. DEFAULT : ${OVERLAY}"
	@echo "   clean_overlay     	: Clean FPGA overlay project, OVERLAY=<overlay_name>. DEFAULT : ${OVERLAY}"
	@echo "   build_all_overlays	: Builds every FPGA overlay found under ./fpga/overlays"
	@echo "   clean_all_overlays	: Cleans every FPGA overlay found under ./fpga/overlays"
	@echo "  "


.PHONY: build_overlay
build_overlay: 
	## build_overlay: Build FPGA overlay, OVERLAY=<overlay_name>. DEFAULT : ${OVERLAY}
	cd ./fpga/overlays/${OVERLAY}/ && make && pwd

.PHONY: open_overlay
open_overlay: 
	## open_overlay: Open the Xilinx Vivado project in GUI, OVERLAY=<overlay_name>. DEFAULT : ${OVERLAY}
	cd ./fpga/overlays/${OVERLAY}/ && make start_gui && pwd

.PHONY: clean_overlay
clean_overlay: 
	## clean_overlay: Clean FPGA overlay project, OVERLAY=<overlay_name>. DEFAULT : ${OVERLAY}
	cd ./fpga/overlays/${OVERLAY}/ && make clean && pwd
	rm -fr *.jou *.log

.PHONY: build_all_overlays
build_all_overlays:
	## build_all_overlays: Build every FPGA overlay found under ./fpga/overlays
	@for d in ./fpga/overlays/*; do \
		if [ -d "$$d" ]; then \
			echo "Building overlay: $$(basename $$d)"; \
			(cd "$$d" && make && pwd) || { echo "Failed building $$(basename $$d)"; exit 1; }; \
		fi; \
	done

.PHONY: clean_all_overlays
clean_all_overlays:
	## clean_all_overlays: Clean every FPGA overlay found under ./fpga/overlays
	@for d in ./fpga/overlays/*; do \
		if [ -d "$$d" ]; then \
			echo "Cleaning overlay: $$(basename $$d)"; \
			(cd "$$d" && make clean && pwd) || { echo "Failed cleaning $$(basename $$d)"; exit 1; }; \
		fi; \
	done
	# remove top-level generated logs/journal files
	rm -fr *.jou *.log
