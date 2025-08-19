export PYTHONPATH := ../../corsair-reg-map/.:$(PYTHONPATH)

all: clean build

build:
	@rm -rf doc hw sw
	python3 -m corsair

clean:
	@rm -rf doc hw sw
	@rm -rf *.jou *.log

.PHONY: all clean
