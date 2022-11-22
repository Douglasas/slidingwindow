VIVADO  = vivado
PYTHON3 = python3

############################################
################ PARAMETERS ################
############################################

# parameters for lena image
ifeq ($(img), lena)
	IN_IMG     = $(abspath img/lena.dat)
	OUT_IMG    = $(abspath out_lena.dat)
	IMG_WIDTH  = 220
	IMG_HEIGHT = 220
endif

# default image for simple tests
IN_IMG     ?= $(abspath img/img.dat)
OUT_IMG    ?= $(abspath out_img.dat)
IMG_WIDTH  ?= 5
IMG_HEIGHT ?= 5

# VHDL implementation
WINDOW_WIDTH  = 3
WINDOW_HEIGHT = 3
PIXEL_WIDTH   = 8

############################################
######## VIVADO SIMULATION COMMANDS ########
############################################

VIVADO_SIM_SCRIPT      = script/vivado_sim.tcl
VIVADO_OPEN_SIM_SCRIPT = script/vivado_open_sim.tcl

vivado-sim:
	$(VIVADO) -nojou -nolog -mode tcl \
		-source $(VIVADO_SIM_SCRIPT) \
		-tclargs $(IN_IMG) $(OUT_IMG) $(IMG_WIDTH) $(IMG_HEIGHT) $(WINDOW_WIDTH) $(WINDOW_HEIGHT) $(PIXEL_WIDTH)

vivado-open-sim:
	$(VIVADO) -nojou -nolog -mode gui -source $(VIVADO_OPEN_SIM_SCRIPT)


############################################
########### VIVADO FPGA COMMANDS ###########
############################################

VIVADO_ZED_CREATE_PROJECT = zedboard/script/xilinx_create_project.tcl
VIVADO_ZED_BITSTREAM      = zedboard/script/xilinx_generate_bitstream.tcl
VIVADO_ZED_PROGRAM        = zedboard/script/xilinx_program_fpga.tcl

PYTHON3_ZED_DEFINE_GENERICS = zedboard/script/define_generics.py
VIVADO_ZED_IMPORTED_TOP     = xilinx-zed/slidingwindow-zed.srcs/sources_1/imports/slidingwindow/zedboard/hdl/top.vhd

PYTHON3_ZED_PROCESS_IMAGE = zedboard/script/process_image.py
TTY_PORT                  = /dev/ttyUSB1

zed-create-project:
ifeq ($(OS),Windows_NT)
	-rd /s /q "xilinx-zed"
else
	-rm -rf xilinx-zed
endif
	$(VIVADO) -nojou -nolog -mode tcl -source $(VIVADO_ZED_CREATE_PROJECT)
	$(PYTHON3) $(PYTHON3_ZED_DEFINE_GENERICS) $(VIVADO_ZED_IMPORTED_TOP) $(IMG_WIDTH) $(IMG_HEIGHT) $(WINDOW_WIDTH) $(WINDOW_HEIGHT) $(PIXEL_WIDTH)

zed-bitstream:
	$(VIVADO) -nojou -nolog -mode tcl -source $(VIVADO_ZED_BITSTREAM)

zed-fpga:
	$(VIVADO) -nojou -nolog -mode tcl -source $(VIVADO_ZED_PROGRAM)

zed-process-image:
	$(PYTHON3) $(PYTHON3_ZED_PROCESS_IMAGE) $(TTY_PORT) $(IN_IMG) $(OUT_IMG)

zed: zed-create-project zed-bitstream zed-fpga

zed-image: zed-process-image python-plot-image

############################################
############## IMAGE COMMANDS ##############
############################################

PYTHON3_PLOT_IMAGE = script/python_plot_image.py

python-plot-image:
	$(PYTHON3) $(PYTHON3_PLOT_IMAGE) $(IN_IMG) $(OUT_IMG) $(IMG_WIDTH) $(IMG_HEIGHT) $(WINDOW_WIDTH) $(WINDOW_HEIGHT) $(PIXEL_WIDTH)
