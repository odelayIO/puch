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
#   Description : Xilinx Vitis HLS QPSK Demodulator
#
#   Version History:
#   
#       Date        Description
#     -----------   -----------------------------------------------------------------------
#      2023-04-18    Original Creation
#
###########################################################################################



# Create a project
open_project -reset proj_hls_qpsk_demod

# Add design files
add_files qpsk.h
add_files qpsk.cpp
add_files qpsk_demod.h
add_files qpsk_demod.cpp
# Add test bench & files
add_files -tb ./sim/golden_short.dat
add_files -tb ./sim/modulatedData_short.dat
add_files -tb ./sim/qpsk_test.cpp

# Set the top-level function
set_top qpsk_demod

# ########################################################
# Create a solution
open_solution -reset solution1 -flow_target vivado

# Define technology and clock rate
set_part {xck26-sfvc784-2LV-c}
#set_property BOARD_PART xilinx.com:kr260_som:part0:1.0 [current_project]

create_clock -period "99.999001MHz"

set ::AESL_AUTOSIM::gDebug 1

#csim_design
# Set any optimization directives
# End of directives
csim_design -clean
csynth_design

# !!! This will take a long time to run !!!
# capture all traces to VCD to plot in gtkWave
#cosim_design -trace_level all  

export_design -flow syn -rtl vhdl -format ip_catalog -display_name "hls_qpsk_demod" -vendor "odelay.IO" -version "0.1" -library "work" -ipname "hls_qpsk_demod"

exit


