set BASE_DIR .

set tYear [format %d [clock format [clock seconds] -format {%Y}]]
set tMonth [format %s [clock format [clock seconds] -format {%m}]]
set tMonth [clock format [clock seconds] -format {%m}]
set tDay [format %s [clock format [clock seconds] -format {%d}]]
set tHour [format %s [clock format [clock seconds] -format {%H}]]
set tMin [format %s [clock format [clock seconds] -format {%M}]]
set tSec [format %s [clock format [clock seconds] -format {%S}]]
set ctimeText [clock format [clock seconds] -format {%b. %d, %Y %I:%M:%S %p}]

set fp [open "$BASE_DIR/Timestamp_Pkg.vhd" w]

puts $fp "--***********************************************************************************************************"
puts $fp "--***********************************************************************************************************"
puts $fp "--****"
puts $fp "--****"
puts $fp "--****                                    Time Stamp Package"
puts $fp "--****"
puts $fp "--****"
puts $fp "--****"
puts $fp "--****    Auto Generated on $ctimeText"
puts $fp "--****"
puts $fp "--***********************************************************************************************************"
puts $fp "--***********************************************************************************************************"
puts $fp " "
puts $fp " "
puts $fp "library ieee;"
puts $fp "use ieee.std_logic_1164.all;"
puts $fp "use ieee.numeric_std.all;"
puts $fp " "
puts $fp " "
puts $fp "package Timestamp_Pkg is"
puts $fp " "
puts $fp " "
puts $fp " "
puts $fp " "
puts $fp "  -- -------------------------------------------------------------------------------------------"
puts $fp "  --  Time Stamp Constants"
puts $fp "  -- -------------------------------------------------------------------------------------------"
puts $fp "  constant TS_YEAR_1    : std_logic_vector(7 downto 0) := x\"20\";"
puts $fp "  constant TS_YEAR_0    : std_logic_vector(7 downto 0) := x\"[format %s [expr [expr {$tYear-2000}] << 0 ]]\";"
puts $fp "  constant TS_MONTH     : std_logic_vector(7 downto 0) := x\"[format %s $tMonth]\";"
puts $fp "  constant TS_DAY       : std_logic_vector(7 downto 0) := x\"[format %s $tDay]\";"
puts $fp "  constant TS_HOUR      : std_logic_vector(7 downto 0) := x\"[format %s $tHour]\";"
puts $fp "  constant TS_MIN       : std_logic_vector(7 downto 0) := x\"[format %s $tMin]\";"
puts $fp "  constant TS_SEC       : std_logic_vector(7 downto 0) := x\"[format %s $tSec]\";"
puts $fp " "
puts $fp " "
puts $fp " "
puts $fp " "
puts $fp " "
puts $fp "end;"

close $fp




