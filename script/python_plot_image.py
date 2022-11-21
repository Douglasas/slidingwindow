#!/usr/bin/python3

import sys
from PIL import Image

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
    # iterate per pixel
    for _ in range(width*height):
        # read line from file
        line = img_file.readline()
        # convert binary string to integer
        pix = int(line, 2)
        # append pixel to image
        img.append(pix)
    # close image file
    img_file.close()
    # return image in integer
    return img

# read and create input PIL image
in_img = read_dat_img(in_img_path, in_img_width, in_img_height)
in_img_pil = Image.new('L', (in_img_width, in_img_height))
in_img_pil.putdata(in_img)

# read and create output PIL image
out_img = read_dat_img(out_img_path, out_img_width, out_img_height)
out_img_pil = Image.new('L', (out_img_width, out_img_height))
out_img_pil.putdata(out_img)

# join both images in a list
images = [in_img_pil, out_img_pil]
# join images widths and heights
widths, heights = zip(*(i.size for i in images))

# get total width from images
total_width = sum(widths)
# get maximum height from iamge
max_height = max(heights)

# create new grayscale image
new_im = Image.new('L', (total_width, max_height))

# merge both images side by side
x_offset = 0
for im in images:
  new_im.paste(im, (x_offset,0))
  x_offset += im.size[0]

# show image
new_im.show()
