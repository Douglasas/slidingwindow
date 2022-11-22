# create project
create_project slidingwindow-zed ./xilinx-zed -part xc7z020clg484-1

# add all files from HDL folders
import_files {\
    zedboard/hdl \
    hdl/ \
}

# set VHDL 2008 to all files
set_property file_type {VHDL 2008} [get_files -filter {FILE_TYPE == VHDL}]

# add constraints
add_files -fileset constrs_1 {zedboard/constraints/}

# update compile order
update_compile_order -fileset sources_1

# set top entity as top
set_property top top [current_fileset]

exit
