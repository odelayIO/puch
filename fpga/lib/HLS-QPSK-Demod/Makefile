export PYTHONPATH := ../../corsair-reg-map/.:$(PYTHONPATH)

all: clean build

build:
	vitis_hls -f run_hls.tcl	

clean:
	@rm -rf proj_hls_qpsk_demod
	@rm -rf *.jou *.log

.PHONY: all clean
