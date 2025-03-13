set overlay_name "fir_accel"
set design_name "fir_accel"

# open block design
open_project ./${overlay_name}/${overlay_name}.xpr
open_bd_design ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd

# Add top wrapper and xdc files
make_wrapper -files [get_files ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd] -top
add_files -norecurse ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/hdl/${design_name}_wrapper.vhd
set_property top ${design_name}_wrapper [current_fileset]
import_files -fileset constrs_1 -norecurse ./${overlay_name}.xdc
update_compile_order -fileset sources_1

# call implement
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1

# This hardware definition file will be used for microblaze projects
write_hw_platform -fixed -include_bit -force -file ./${overlay_name}.xsa
validate_hw_platform ./${overlay_name}.xsa

# copy nd rename bitstream to final location
file copy -force ./${overlay_name}/${overlay_name}.runs/impl_1/${design_name}_wrapper.bit ${overlay_name}.bit


# copy hwh files
file copy -force ./${overlay_name}/${overlay_name}.gen/sources_1/bd/${design_name}/hw_handoff/${design_name}.hwh ${overlay_name}.hwh
