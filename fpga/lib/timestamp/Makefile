export PYTHONPATH := ../../corsair-reg-map/.:$(PYTHONPATH)

# Define input files and output directories
CSRCONFIG = csrconfig
YAML 			= timestamp_reg.yaml
DOC_DIR 	= doc
SW_DIR 		= sw
HW_DIR 		= hw

# Define the commands
GEN_TIMESTAMP = vivado -mode batch -notrace -source gen_timestamp.tcl
GEN_REGMAP 		= python3 -m corsair

# Define output files, assuming at least one file is generated in each directory
# Replace these with actual generated files if known
DOC_OUTPUT 	= $(DOC_DIR)/timestamp_reg.md
SW_OUTPUT 	= $(SW_DIR)/timestamp_regmap.py
HW_OUTPUT 	= $(HW_DIR)/timestamp_reg.vhd

#	DOC_OUTPUT 	= $(wildcard $(DOC_DIR)/*.md)
#	SW_OUTPUT 	= $(wildcard $(SW_DIR)/*.py)
#	HW_OUTPUT 	= $(wildcard $(HW_DIR)/*.vhd)

# Default target
all: run_timestamp check_regmap

# Always run the gen_timestamp process
.PHONY: run_timestamp
run_timestamp:
	@echo "Generating Timestamp_Pkg.vhd File..."
	$(GEN_TIMESTAMP)
	$(MAKE) clean_spew
	@echo "Completed Generating Timestamp_Pkg.vhd File."

# Run gen_regmap if csrconfig or timestamp_reg.yaml has been modified
# or if the output files in doc, sw, or hw directories are missing
check_regmap: $(DOC_OUTPUT) $(SW_OUTPUT) $(HW_OUTPUT)

$(DOC_OUTPUT) $(SW_OUTPUT) $(HW_OUTPUT): $(CSRCONFIG) $(YAML)
	@echo "Generating Register Map Files..."
	$(MAKE) clean_gen
	$(GEN_REGMAP)
	$(MAKE) clean_spew
	@echo "Completed Generating Register Map Files."

# Phony target to ensure check_regmap is considered every time
.PHONY: check_regmap run_timestamp

# Clean up generated files
.PHONY: clean_gen
clean_gen:
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
