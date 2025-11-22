
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
#   Description : Makefile for Puch framework
#
#   Version History:
#   
#       Date        Description
#     -----------   -----------------------------------------------------------------------
#      2025-10-22    Updated with additional comments and methods to build/clean all projects
#      2025-11-22    Added removing .pynb_checkpoints folders under ./fpga/py
#
# ############################################################################################
# ############################################################################################


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
	## clean_all_overlays: Remove .ipynb_checkpoints under ./fpga/py
	@for d in ./fpga/py/*; do \
		if [ -d "$$d" ]; then \
			echo "Cleaning overlay: $$(basename $$d)"; \
			(cd "$$d" && rm -fr .ipynb_checkpoints && pwd) || { echo "Failed cleaning $$(basename $$d)"; exit 1; }; \
		fi; \
	done
	# remove top-level generated logs/journal files
	rm -fr *.jou *.log
