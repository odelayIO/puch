# Building FPGA

This page outlines a typical FPGA build flow.

## Toolchain

- Vendor tools (Vivado/Quartus)
- Open-source flows (Yosys, nextpnr) if applicable

## Typical Steps

1. Synthesize HDL
2. Implement/place & route
3. Generate bitstream
4. Program the board (via JTAG or vendor programmer)

## Example Commands

```bash
# synthesize (vendor-specific)
# vivado -mode batch -source build.tcl

# or using open tools (example)
yosys -p 'synth_xilinx -top top; write_verilog synth.v'
nextpnr-<arch> --json blif.json --write results.json
``` 

Add exact commands for your chosen toolchain.
