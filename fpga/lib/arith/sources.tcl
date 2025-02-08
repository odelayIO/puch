add_files -norecurse ${DOCKER_BASE}/fpga/lib/arith/Arith_Pkg.vhd
add_files -norecurse ${DOCKER_BASE}/fpga/lib/arith/Add.vhd
#add_files -norecurse ${DOCKER_BASE}/fpga/lib/arith/Mult.vhd



set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/arith/Arith_Pkg.vhd]
set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/arith/Add.vhd]
#set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/arith/Mult.vhd]

