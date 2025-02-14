add_files -norecurse ${DOCKER_BASE}/fpga/lib/timestamp/hw/timestamp_reg.vhd
add_files -norecurse ${DOCKER_BASE}/fpga/lib/timestamp/Timestamp_Pkg.vhd
add_files -norecurse ${DOCKER_BASE}/fpga/lib/timestamp/Timestamp.vhd

set_property file_type {VHDL 2008} [get_files ${DOCKER_BASE}/fpga/lib/timestamp/Timestamp_Pkg.vhd]
set_property file_type {VHDL 2008} [get_files ${DOCKER_BASE}/fpga/lib/timestamp/hw/timestamp_reg.vhd]

#   set_property file_type {VHDL 2008} [get_files ${DOCKER_BASE}/fpga/lib/timestamp/Timestamp.vhd]

