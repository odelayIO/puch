# Adding source code
add_files -norecurse ${DOCKER_BASE}/fpga/lib/HLS-QPSK-Demod/hw/qpsk_pkg.vhd
add_files -norecurse ${DOCKER_BASE}/fpga/lib/HLS-QPSK-Demod/hw/qpsk_reg.vhd
add_files -norecurse ${DOCKER_BASE}/fpga/ip/KR260/QPSK_Demod_Out_BRAM/QPSK_Demod_Out_BRAM.xci 
add_files -norecurse ${DOCKER_BASE}/fpga/ip/KR260/QPSK_Demodulator/QPSK_Demodulator.xci 
add_files -norecurse ${DOCKER_BASE}/fpga/lib/HLS-QPSK-Demod/src/QPSK_Demod_Top.vhd

# HLS will update revision value based on the date, so we need to upgrade the QPSK Demodulator IP Core
upgrade_ip -vlnv odelay.IO:work:qpsk_demod:0.1 [get_ips  QPSK_Demodulator] -log ip_upgrade.log
#export_ip_user_files -of_objects [get_ips QPSK_Demodulator]


# Set compile parameters and generate output IP cores
set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/HLS-QPSK-Demod/hw/qpsk_reg.vhd]
set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/HLS-QPSK-Demod/hw/qpsk_pkg.vhd]
generate_target all [get_files ${DOCKER_BASE}/fpga/ip/KR260/QPSK_Demod_Out_BRAM/QPSK_Demod_Out_BRAM.xci]
generate_target all [get_files ${DOCKER_BASE}/fpga/ip/KR260/QPSK_Demodulator/QPSK_Demodulator.xci]
