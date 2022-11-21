#!/usr/bin/python3

import sys
from PIL import Image, ImageOps

in_img_path  = sys.argv[1]
out_dat_path = sys.argv[2]

# open method used to open different extension image file
in_img = Image.open(in_img_path)

# convert to grayscale
grayscale = ImageOps.grayscale(in_img)

# extract image information
pixels = list(grayscale.getdata())
width, height = in_img.size

print(f"Image width: {width}")
print(f"Image height: {height}")

# create and open output dat file 
out_file = open(out_dat_path, 'w+')
# iterate through all pixels
for pixel in pixels:
    # write pixel to file in binary format
    out_file.write(f"{pixel:08b}\n")
# close file
out_file.close()
