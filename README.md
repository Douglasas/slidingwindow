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

### To simulate using lena, just add another parameter
```
make vivado-sim img=lena
```

## Plotting image

After simulating, it is possible to plot the image using Python3.

```
make python-plot-image
```

## Commands to run on `Zedboard`

### Connect FTDI board to PMOD JA
- Connect `FTDI` to `GND`
- Connect `FTDI-RX` to pin `JA2`
- Connect `FTDI-TX` to pin `JA3`

### Run commands to synthesize and program FPGA using Vivado and Lena image
```
# create project
make zed-create-project img=lena
# generate bitstream
make zed-bitstream img=lena
# program FPGA
make zed-fpga  img=lena
```

### Send Lena, receive processed image, and show images side-by-side
```
# send lena and receive processed image
make zed-process-image img=lena TTY_PORT=/dev/ttyUSB0
# plot images side-by-side
make python-plot-image img=lena
```
