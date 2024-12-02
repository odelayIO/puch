export PYTHONPATH := ../../../corsair-reg-map/.:$(PYTHONPATH)

all: clean build

build:
	vivado -mode batch -notrace -source gen_timestamp.tcl
	python3 -m corsair

clean:
	@rm -rf doc hw sw
	@rm -rf Timestamp_Pkg.vhd *.jou *.log

.PHONY: all clean
