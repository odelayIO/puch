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
#   Description : Check timing script for the Fixed AXI Stream design 
#
#   Version History:
#   
#       Date        Description
#     -----------   -----------------------------------------------------------------------
#      2023-04-18    Original Creation
#
###########################################################################################





set OVERLAY_NAME "kr260_hls_fixed_gain_stream"
set PROJ_DIR "xpr"

set fd [open ./${PROJ_DIR}/${OVERLAY_NAME}.runs/impl_1/${OVERLAY_NAME}_wrapper_timing_summary_routed.rpt r]
set timing_met 0
while { [gets $fd line] >= 0 } {
    if [string match {All user specified timing constraints are met.} $line]  { 
        set timing_met 1
        break
    }
}
if {$timing_met == 0} {
    puts "ERROR: ${OVERLAY_NAME} bitstream generation does not meet timing."
    exit 1
}
puts "Timing constraints are met."
