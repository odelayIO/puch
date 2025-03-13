export PYTHONPATH := ../../corsair-reg-map/.:$(PYTHONPATH)

all: clean build

build:
	python3 -m corsair
	vitis_hls -f build.tcl	

reg_if: 
	@rm -fr doc hw sw
	python3 -m corsair

csim: clean
	python3 -m corsair
	vitis_hls -f run_csim.tcl	

clean:
	@rm -fr doc hw sw
	@rm -rf xpr
	@rm -rf csim
	@rm -rf proj
	@rm -rf *.jou *.log

.PHONY: all clean
