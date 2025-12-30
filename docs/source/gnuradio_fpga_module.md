# GNURadio FPGA Module

This page explains how to integrate an FPGA module with GNURadio.

## Overview

- Use the FPGA to offload DSP or custom packet handling.
- Communicate over a bus or interface (PCIe, Ethernet, USB, custom)

## Integration Approaches

- Use a host-side driver to expose FPGA streams to GNU Radio blocks.
- Implement a GNU Radio out-of-tree (OOT) module that wraps the driver.

## Example Outline

1. Define the transport (e.g., UDP, PCIe DMA)
2. Create a simple protocol for streaming samples/packets
3. Implement a GNURadio block that reads/writes the transport

## References

- GNURadio OOT module development docs
- Example projects integrating FPGA and GNURadio
