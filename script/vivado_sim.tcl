# run with Vivado

set IN_IMG        [lindex $argv 0]
set OUT_IMG       [lindex $argv 1]
set IMG_WIDTH     [lindex $argv 2]
set IMG_HEIGHT    [lindex $argv 3]
set WINDOW_WIDTH  [lindex $argv 4]
set WINDOW_HEIGHT [lindex $argv 5]
set PIXEL_WIDTH   [lindex $argv 6]

# create project
create_project -force slidingwindow-sim xilinx-sim/ -part xc7z020clg484-1

# add all files from HDL folders
add_files hdl/

# add simulation files
add_files -fileset sim_1 sim/

# set VHDL 2008 to all files
set_property file_type {VHDL 2008} [get_files -filter {FILE_TYPE == VHDL}]

# update compile order
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# set top entity as top
set_property top slidingwindow_top [current_fileset]
# set testbench entity as top
set_property top slidingwindow_tb [get_filesets sim_1]

# set testbench parameters
set_property generic "           \
    IN_IMG=$IN_IMG               \
    OUT_IMG=$OUT_IMG             \
    IMG_WIDTH=$IMG_WIDTH         \
    IMG_HEIGHT=$IMG_HEIGHT       \
    WINDOW_WIDTH=$WINDOW_WIDTH   \
    WINDOW_HEIGHT=$WINDOW_HEIGHT \
    PIXEL_WIDTH=$PIXEL_WIDTH     \
" [get_filesets sim_1]

# set maximum simulation time
set_property -name {xsim.simulate.runtime} -value {60s} -objects [get_filesets sim_1]

# configure dump to wdb file for all signals
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]

# start simulation
launch_simulation

exit
