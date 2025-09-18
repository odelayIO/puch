export PYTHONPATH := ../../corsair-reg-map/.:$(PYTHONPATH)

# Define input files and output directories
CSRCONFIG 	= csrconfig
YAML 				= timestamp_reg.yaml
DOC_DIR 		= doc
SW_DIR 			= sw
HW_DIR 			= hw

# Define commands
GEN_TIMESTAMP = vivado -mode batch -notrace -source gen_timestamp.tcl
GEN_REGMAP		= python3 -m corsair

# Define output files, assuming at least one file is generated in each directory
DOC_OUTPUT 		= $(DOC_DIR)/timestamp_reg.md
SW_OUTPUT			= $(SW_DIR)/timestamp_regmap.py
HW_OUTPUT			= $(HW_DIR)/timestamp_reg.vhd

# Default Target
all: run_timestamp check_regmap

# Always run the gen_timestamp process
.PHONY: run_timestamp
run_timestamp:
	@echo "Generating timestamp_pkg.vhd..."
	$(GEN_TIMESTAMP)
	@echo "Cleaning spew..."
	@rm -rf *.jou *.log
	@echo "Done generating timestamp_pkg.vhd."

# Run gen_regmp if csrconfig or timestamp_reg.yaml has been modified
# or if the output files in doc, sw, or hw directoris are missing
check_regmap: $(DOC_OUTPUT) $(HW_OUTPUT) $(SW_OUTPUT)

$(DOC_OUTPUT) $(SW_OUTPUT) $(HW_OUTPUT): $(CSRCONFIG) $(YAML)
	@echo "Generating Register Map files and cleaning folders..."
	@rm -rf doc hw sw Timestamp_Pkg.vhd
	$(GEN_REGMAP)
	@echo "Done generating Register Maps."

# Phony target to ensure check_regmap is considered every time
.PHONY: check_regmap run_timestamp

# Clean up generated files
.PHONY: clean_spew
clean_spew:
	@echo "Cleaning Spew..."
	@rm -rf *.jou *.log
	@echo "Done cleaning spew."

# Clean Everything
.PHONY: clean_all
clean_all:
	@echo "Cleaning everything..."
	@rm -rf *.jou *.log $(DOC_DIR) $(SW_DIR) $(HW_DIR)
	@echo "Done cleaning everything."
