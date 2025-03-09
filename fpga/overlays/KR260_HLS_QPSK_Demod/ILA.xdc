create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 32768 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list kr260_hls_qpsk_demod_i/zynq_ultra_ps_e_0/U0/pl_clk0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[1]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[2]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[3]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[4]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[5]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[6]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[7]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[8]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[9]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[10]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[11]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[12]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[13]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[14]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[1]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[2]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[3]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[4]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[5]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[6]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[7]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[8]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[9]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[10]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[11]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[12]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[13]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[14]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_addr[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[1]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[2]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[3]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[4]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[5]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[6]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[7]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[8]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[9]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[10]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[11]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[12]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[13]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[14]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 2 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/demod_bits[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/demod_bits[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 2 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/demod_bits_q[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/demod_bits_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[1]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[2]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[3]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[4]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[5]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[6]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[7]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[8]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[9]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[10]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[11]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[12]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[13]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[14]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[15]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[16]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[17]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[18]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[19]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[20]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[21]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[22]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[23]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[24]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[25]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[26]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[27]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[28]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[29]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[30]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_rd_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 16 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[0]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[1]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[2]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[3]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[4]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[5]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[6]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[7]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[8]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[9]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[10]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[11]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[12]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[13]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[14]} {kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/BRAM_wr_addr_clr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/demod_bits_stb]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/demod_bits_stb_q]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/I_out_ap_vld]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list kr260_hls_qpsk_demod_i/QPSK_Demod_Top_0/U0/U_QPSK_DEMOD/Q_out_ap_vld]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_pl_clk0]
