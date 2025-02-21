export PYTHONPATH := ../../corsair-reg-map/.:$(PYTHONPATH)

all: clean build

build:
	vitis_hls -f build.tcl	

csim: clean
	vitis_hls -f run_csim.tcl	

clean:
	@rm -rf proj_hls_qpsk_demod
	@rm -rf csim
	@rm -rf proj
	@rm -rf *.jou *.log

.PHONY: all clean
