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
############## VIVADO COMMANDS #############
############################################

VIVADO = vivado
VIVADO_SIM_SCRIPT      = script/vivado_sim.tcl
VIVADO_OPEN_SIM_SCRIPT = script/vivado_open_sim.tcl

vivado-sim:
	$(VIVADO) -nojou -nolog -mode tcl \
		-source $(VIVADO_SIM_SCRIPT) \
		-tclargs $(IN_IMG) $(OUT_IMG) $(IMG_WIDTH) $(IMG_HEIGHT) $(WINDOW_WIDTH) $(WINDOW_HEIGHT) $(PIXEL_WIDTH)

vivado-open-sim:
	$(VIVADO) -nojou -nolog -mode gui -source $(VIVADO_OPEN_SIM_SCRIPT)

############################################
############## IMAGE COMMANDS ##############
############################################

PYTHON3 = python3
PYTHON3_PLOT_IMAGE = script/python_plot_image.py

python-plot-image:
	$(PYTHON3) $(PYTHON3_PLOT_IMAGE) $(IN_IMG) $(OUT_IMG) $(IMG_WIDTH) $(IMG_HEIGHT) $(WINDOW_WIDTH) $(WINDOW_HEIGHT) $(PIXEL_WIDTH)
