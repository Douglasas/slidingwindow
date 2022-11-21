############################################
################ PARAMETERS ################
############################################

IN_IMG     = $(abspath img/img.dat)
OUT_IMG    = $(abspath out_img.dat)

IMG_WIDTH     = 5
IMG_HEIGHT    = 5
WINDOW_WIDTH  = 3
WINDOW_HEIGHT = 3
PIXEL_WIDTH   = 8

############################################
################# COMMANDS #################
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
