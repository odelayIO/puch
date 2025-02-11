add_files -norecurse ${DOCKER_BASE}/fpga/lib/util/delay_slv.vhd
add_files -norecurse ${DOCKER_BASE}/fpga/lib/util/delay_bit.vhd



set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/util/delay_slv.vhd]
set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/util/delay_bit.vhd]

