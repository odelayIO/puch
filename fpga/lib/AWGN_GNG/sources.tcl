add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng_coef.v
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng_ctg.v
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng_interp.v
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng_lzd.v
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng_smul_16_18_sadd_37.v
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng_smul_16_18.v
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng.v
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/hw/awgn_pkg.vhd
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/hw/awgn_reg.vhd
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/hw/awgn_top.vhd
add_files -fileset sim_1 -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/sim/tb_gng.vhd

set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/AWGN_GNG/hw/awgn_reg.vhd]
set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/AWGN_GNG/hw/awgn_pkg.vhd]
set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/AWGN_GNG/sim/tb_gng.vhd]
