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
#   Description : Makefile for Timestamp module 
#
#   Version History:
#   
#       Date        Description
#     -----------   -----------------------------------------------------------------------
#      2025-09-19    Original Creation
#
# ############################################################################################
# ############################################################################################



export PYTHONPATH := ../../corsair-reg-map/.:$(PYTHONPATH)

# Define input files and output directories
CSRCONFIG = csrconfig
YAML 			= dma_data_capture_reg.yaml
DOC_DIR 	= doc
SW_DIR 		= sw
HW_DIR 		= hw

# Define the commands
GEN_REGMAP 		= python3 -m corsair

# Define output files, assuming at least one file is generated in each directory
# Replace these with actual generated files if known
DOC_OUTPUT 	= $(DOC_DIR)/dma_data_capture_reg.md
SW_OUTPUT 	= $(SW_DIR)/dma_data_capture_regmap.py
HW_OUTPUT 	= $(HW_DIR)/dma_data_capture_reg.vhd

#	DOC_OUTPUT 	= $(wildcard $(DOC_DIR)/*.md)
#	SW_OUTPUT 	= $(wildcard $(SW_DIR)/*.py)
#	HW_OUTPUT 	= $(wildcard $(HW_DIR)/*.vhd)

# Default target
all: check_regmap

# Run gen_regmap if csrconfig or *_reg.yaml has been modified
# or if the output files in doc, sw, or hw directories are missing
check_regmap: $(DOC_OUTPUT) $(SW_OUTPUT) $(HW_OUTPUT)

$(DOC_OUTPUT) $(SW_OUTPUT) $(HW_OUTPUT): $(CSRCONFIG) $(YAML)
	@echo "Generating Register Map Files..."
	$(MAKE) clean_gen
	$(GEN_REGMAP)
	$(MAKE) clean_spew
	@echo "Completed Generating Register Map Files."

# Phony target to ensure check_regmap is considered every time
.PHONY: check_regmap

# Clean up generated files
.PHONY: clean_gen
clean_gen:
	$(MAKE) clean_spew
	@echo "Removing all generated outputs..."
	rm -rf $(DOC_DIR)/* $(SW_DIR)/* $(HW_DIR)/*
	@echo "Done removing generated outputs."

# Clean up spew from generators
.PHONY: clean_spew
clean_spew:
	@echo "Cleaning Spew..."
	rm -rf *.jou *.log $(SW_DIR)/__pycache__
	@echo "Done cleaning spew."

# Phony target to ensure clean_gen and clean_spew are considered every time
.PHONY: clean_gen clean_spew
