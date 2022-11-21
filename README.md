# Sliding Window Implementation in VHDL

## Configuration

For the configuration, it is required to add vivado to the PATH. In linux, this can be done by sourcing the settings available at the installation folder:
```
source /opt/Xilinx/Vivado/2022.2/settings64.sh
```

For Windows, you need to install Make using the following link and add Vivado to the PATH environment variable.

> Make for Windows : http://gnuwin32.sourceforge.net/packages/make.htm

## Commands to simulate

```
# Executes simulation using parameters defined in the Makefile
make vivado-sim

# Opens simulation using Vivado
make vivado-open-sim
```

## Plotting image

After simulating, it is possible to plot the image using Python3.

> Please, be sure to install `matplotlib` with `pip2` and that python3 is in the PATH

```
make python-plot-image
```