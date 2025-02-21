add_files -norecurse ${DOCKER_BASE}/fpga/lib/HLS-QPSK-Demod/hw/qpsk_pkg.vhd
add_files -norecurse ${DOCKER_BASE}/fpga/lib/HLS-QPSK-Demod/hw/qpsk_reg.vhd

set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/HLS-QPSK-Demod/hw/qpsk_reg.vhd]
set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/HLS-QPSK-Demod/hw/qpsk_pkg.vhd]
