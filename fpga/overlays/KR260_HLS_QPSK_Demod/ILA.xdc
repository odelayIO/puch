





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
connect_debug_port u_ila_0/probe0 [get_nets [list {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[0]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[1]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[2]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[3]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[4]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[5]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[6]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[7]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[8]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[9]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[10]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[11]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[12]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[13]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[14]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[15]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[16]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[17]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[18]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[19]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[20]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[21]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[22]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[23]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[24]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[25]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[26]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[27]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[28]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[29]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[30]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_dword_cnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[0]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[1]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[2]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[3]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[4]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[5]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[6]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[7]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[8]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[9]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[10]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[11]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[12]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[13]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[14]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[15]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[16]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[17]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[18]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[19]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[20]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[21]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[22]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[23]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[24]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[25]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[26]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[27]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[28]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[29]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[30]} {kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_length[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[0]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[1]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[2]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[3]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[4]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[5]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[6]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[7]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[8]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[9]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[10]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[11]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[12]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[13]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[14]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[15]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[16]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[17]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[18]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[19]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[20]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[21]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[22]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[23]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[24]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[25]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[26]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[27]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[28]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[29]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[30]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tlast[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[0]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[1]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[2]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[3]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[4]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[5]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[6]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[7]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[8]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[9]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[10]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[11]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[12]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[13]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[14]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[15]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[16]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[17]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[18]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[19]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[20]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[21]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[22]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[23]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[24]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[25]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[26]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[27]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[28]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[29]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[30]} {kr260_hls_qpsk_demod_i/gng_top_0/U0/cnt_tvalid[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/A_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list kr260_hls_qpsk_demod_i/gng_top_0/U0/A_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/A_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list kr260_hls_qpsk_demod_i/gng_top_0/U0/A_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/A_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/B_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list kr260_hls_qpsk_demod_i/gng_top_0/U0/B_TLAST]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/B_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list kr260_hls_qpsk_demod_i/gng_top_0/U0/B_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/B_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list kr260_hls_qpsk_demod_i/gng_top_0/U0/B_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list kr260_hls_qpsk_demod_i/Rx_QPSK/QPSK_Demod_Top_0/U0/dma_rst]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_pl_clk0]
