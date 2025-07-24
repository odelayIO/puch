# Adding source code
add_files -norecurse ${DOCKER_BASE}/fpga/lib/DMA_Data_Capture/hw/dma_data_capture_pkg.vhd
add_files -norecurse ${DOCKER_BASE}/fpga/lib/DMA_Data_Capture/hw/dma_data_capture_reg.vhd
add_files -norecurse ${DOCKER_BASE}/fpga/ip/KR260/DMA_32b_Capture_FIFO/DMA_32b_Capture_FIFO.xci 


# Set compile parameters and generate output IP cores
set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/DMA_Data_Capture/hw/dma_data_capture_reg.vhd]
set_property file_type {VHDL 2008} [get_files  ${DOCKER_BASE}/fpga/lib/DMA_Data_Capture/hw/dma_data_capture_pkg.vhd]
generate_target all [get_files ${DOCKER_BASE}/fpga/ip/KR260/DMA_32b_Capture_FIFO/DMA_32b_Capture_FIFO.xci]
