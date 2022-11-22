# open hardware manager
open_hw_manager

# connect to hardware manager server
connect_hw_server -allow_non_jtag


if {[catch {
    # open hardware target
    open_hw_target
}]} {
    puts "Couldn't find FPGA"
    exit 1
}

# set bitstream
set_property PROGRAM.FILE {./xilinx-zed/slidingwindow-zed.runs/impl_1/top.bit} [get_hw_devices xc7z020_1]

# program FPGA
program_hw_devices [get_hw_devices xc7z020_1]

exit
