#############################################################################################
#############################################################################################
#
#   The MIT License (MIT)
#   
#   Copyright (c) 2023 http://odelay.io 
#   
#   Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"), to deal
#   in the Software without restriction, including without limitation the rights
#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in all
#   copies or substantial portions of the Software.
#   
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#   SOFTWARE.
#   
#   Contact : <everett@odelay.io>
#  
#   Description : Build script for the Fixed AXI Stream design targetted to KR260 board 
#
#   Version History:
#   
#       Date        Description
#     -----------   -----------------------------------------------------------------------
#      2023-04-18    Original Creation
#      2023-05-04    Clean up and added report generation statements
#      2024-12-20    Merged into puch
#
###########################################################################################


#----------------------------------------------------------------------------
#   System Variables
#----------------------------------------------------------------------------
set OVERLAY_NAME "kr260_hls_fixed_gain_stream"
set PROJ_DIR "./xpr"
set BOARD_DESIGN "kr260_hls_fixed_gain_stream_bd.tcl"
set SPEW_DIR "./output"
set REPORTS "./output/Reports"
set DEVICE "xck26-sfvc784-2LV-c"


#----------------------------------------------------------------------------
#   Create Project
#----------------------------------------------------------------------------
set_param board.repoPaths {../../../XilinxBoardStore}
# create_project [‑part <arg>] [‑force] [‑in_memory] [‑ip] [‑rtl_kernel] [‑quiet] [‑verbose] [<name>] [<dir>]
create_project ${OVERLAY_NAME} ${PROJ_DIR} -part ${DEVICE}
set_property BOARD_PART xilinx.com:kr260_som:part0:1.0 [current_project]
set_property target_language VHDL [current_project]
set_property default_lib work [current_project]


#----------------------------------------------------------------------------
#   Adding Library to project
#----------------------------------------------------------------------------
set_property  ip_repo_paths  ../../lib [current_project]
update_ip_catalog


#----------------------------------------------------------------------------
#   Add VHDL File(s)
#----------------------------------------------------------------------------
add_files -norecurse ../../lib/led_reg/hw/led_reg.vhd
add_files -norecurse ../../lib/timestamp/hw/timestamp_reg.vhd
add_files -norecurse ../../lib/timestamp/Timestamp_Pkg.vhd
add_files -norecurse ../../lib/timestamp/Timestamp.vhd


#----------------------------------------------------------------------------
#   Source the board design
#----------------------------------------------------------------------------
source ${BOARD_DESIGN}


#----------------------------------------------------------------------------
#   open block design
#----------------------------------------------------------------------------
open_bd_design ./${PROJ_DIR}/${OVERLAY_NAME}.srcs/sources_1/bd/${OVERLAY_NAME}/${OVERLAY_NAME}.bd


#----------------------------------------------------------------------------
#   Add top wrapper and xdc files
#----------------------------------------------------------------------------
make_wrapper -files [get_files ./${PROJ_DIR}/${OVERLAY_NAME}.srcs/sources_1/bd/${OVERLAY_NAME}/${OVERLAY_NAME}.bd] -top
add_files -norecurse ./${PROJ_DIR}/${OVERLAY_NAME}.gen/sources_1/bd/${OVERLAY_NAME}/hdl/${OVERLAY_NAME}_wrapper.vhd
set_property top ${OVERLAY_NAME}_wrapper [current_fileset]


#----------------------------------------------------------------------------
#   Add XDC File(s)
#----------------------------------------------------------------------------
import_files -fileset constrs_1 -norecurse ./leds_pinout.xdc
update_compile_order -fileset sources_1


#----------------------------------------------------------------------------
#   NOTE: You'll need to increase SWAP file size to 16GB to use 8 Processors
#----------------------------------------------------------------------------
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1


#----------------------------------------------------------------------------
#   Generate Build Reports
#----------------------------------------------------------------------------
open_run impl_1
report_timing_summary -file ${REPORTS}/post_route_timing_summary.rpt
report_timing -sort_by group -max_paths 100 -path_type summary -file ${REPORTS}/post_route_timing.rpt
report_clock_utilization -file ${REPORTS}/clock_util.rpt
report_utilization -hierarchical_percentages -hierarchical -file ${REPORTS}/post_route_util.rpt
report_power -file ${REPORTS}/post_route_power.rpt
report_drc -file ${REPORTS}/post_imp_drc.rpt
report_datasheet -file ${REPORTS}/post_imp_datasheet.rpt


#----------------------------------------------------------------------------
#   This hardware definition file will be used for microblaze projects
#----------------------------------------------------------------------------
write_hw_platform -fixed -include_bit -force -file ./${OVERLAY_NAME}.xsa
validate_hw_platform ./${OVERLAY_NAME}.xsa


#----------------------------------------------------------------------------
#   Copy and rename bitstream to final location
#----------------------------------------------------------------------------
file copy -force ./${PROJ_DIR}/${OVERLAY_NAME}.runs/impl_1/${OVERLAY_NAME}_wrapper.bit ${SPEW_DIR}/${OVERLAY_NAME}.bit
file copy -force ./${PROJ_DIR}/${OVERLAY_NAME}.gen/sources_1/bd/${OVERLAY_NAME}/hw_handoff/${OVERLAY_NAME}.hwh ${SPEW_DIR}/${OVERLAY_NAME}.hwh
