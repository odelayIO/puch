create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 16384 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list kr260_hls_qpsk_demod_i/zynq_ultra_ps_e_0/U0/pl_clk0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[1]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[2]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[3]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[4]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[5]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[6]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[7]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[8]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[9]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[10]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[11]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[12]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[13]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[14]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[15]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[16]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[17]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[18]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[19]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[20]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[21]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[22]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[23]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[24]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[25]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[26]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[27]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[28]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[29]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[30]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TDATA[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[1]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[2]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[3]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[4]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[5]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[6]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[7]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[8]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[9]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[10]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[11]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[12]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[13]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[14]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 2 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/demod_bits_q[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/demod_bits_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 16 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[1]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[2]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[3]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[4]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[5]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[6]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[7]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[8]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[9]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[10]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[11]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[12]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[13]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[14]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[1]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[2]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[3]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[4]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[5]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[6]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[7]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[8]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[9]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[10]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[11]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[12]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[13]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[14]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[15]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[16]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[17]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[18]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[19]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[20]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[21]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[22]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[23]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[24]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[25]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[26]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[27]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[28]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[29]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[30]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 2 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/demod_bits[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/demod_bits[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[1]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[2]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[3]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[4]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[5]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[6]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[7]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[8]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[9]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[10]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[11]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[12]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[13]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[14]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[15]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[16]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[17]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[18]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[19]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[20]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[21]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[22]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[23]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[24]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[25]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[26]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[27]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[28]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[29]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[30]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/shift_reg[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[1]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[2]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[3]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[4]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[5]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[6]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[7]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[8]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[9]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[10]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[11]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[12]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[13]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[14]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[15]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[16]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[17]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[18]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[19]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[20]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[21]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[22]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[23]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[24]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[25]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[26]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[27]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[28]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[29]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[30]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_word[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr_clr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/demod_bits_stb]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/demod_bits_stb_q]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_clr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/sync_lock]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/A_TVALID]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_pl_clk0]
