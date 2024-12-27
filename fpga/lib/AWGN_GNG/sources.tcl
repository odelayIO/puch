add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng_coef.v
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng_ctg.v
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng_interp.v
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng_lzd.v
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng_smul_16_18_sadd_37.v
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng_smul_16_18.v
add_files -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/gng.v
add_files -fileset sim_1 -norecurse ${DOCKER_BASE}/fpga/lib/AWGN_GNG/sim/tb_gng.sv
