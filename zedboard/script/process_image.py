#!/usr/bin/python3

import sys
import serial
from tqdm import tqdm
import time

# get parameters
serialport   = sys.argv[1]
in_img_path  = sys.argv[2]
out_img_path = sys.argv[3]

# initialize serial device parameters
ser = serial.Serial()
ser.baudrate = 115200
ser.port = serialport
ser.open()

# clear input buffer
ser.flushInput()

# init output image file 
out_img = open(out_img_path, 'w+')
# read all lines from input image
in_img = open(in_img_path, 'r').readlines()
# iterate all input image lines
for line in tqdm(in_img):
    # convert binary pixel in line to integer
    in_pix = int(line, 2)
    # write pixel as byte
    ser.write(bytes([in_pix]))
    # wait data to be written
    ser.flush()
    # while there is data in the input buffer
    while ser.in_waiting:
        # read byte
        out_byte = ser.read(1)
        # convert byte to integer
        out_pix = int.from_bytes(out_byte, 'little')
        # write line as 8-bit binary
        out_img.writelines(f"{out_pix:08b}\n")
        out_img.flush()

# wait input buffer to fill
time.sleep(0.5)

# while there is data in the input buffer
while ser.in_waiting:
    # read byte
    out_byte = ser.read(1)
    # convert byte to integer
    out_pix = int.from_bytes(out_byte, 'little')
    # write line as 8-bit binary
    out_img.writelines(f"{out_pix:08b}\n")
    out_img.flush()

# close output file
out_img.close()
