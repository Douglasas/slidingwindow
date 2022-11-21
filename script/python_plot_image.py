#!/usr/bin/python3

import sys
import matplotlib.pyplot as plt

in_img_path   = sys.argv[1]
out_img_path  = sys.argv[2]
in_img_width  = int(sys.argv[3])
in_img_height = int(sys.argv[4])
window_width  = int(sys.argv[5])
window_height = int(sys.argv[6])
pixel_width   = int(sys.argv[7])

out_img_width  = in_img_width  - (window_width  - 1)
out_img_height = in_img_height - (window_height - 1)

def read_dat_img(filepath : str, width: int, height: int) -> list:
    # open file
    img_file = open(filepath, 'r')
    # init image as list
    img = []
    # iterate per row
    for i in range(width):
        # init new row
        row = []
        # iterate per column in row
        for j in range(height):
            # read line from file
            line = img_file.readline()
            # convert binary string to integer
            pix = int(line, 2)
            # append pixel to row
            row.append(pix)
        # add row to image
        img.append(row)
    # close image file
    img_file.close()
    # return image in integer
    return img

# plot input image from file
in_img = read_dat_img(in_img_path, in_img_width, in_img_height)
plt.figure()
plt.title("in image")
plt.imshow(in_img)

# plot output image from file
out_img = read_dat_img(out_img_path, out_img_width, out_img_height)
plt.figure()
plt.title("out image")
plt.imshow(out_img)

plt.show()
