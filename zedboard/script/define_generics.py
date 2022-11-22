#!/usr/bin/python3

import sys

top_file_path = sys.argv[1]
generics = {
    "IMAGE_WIDTH"   : sys.argv[2],
    "IMAGE_HEIGHT"  : sys.argv[3],
    "WINDOW_WIDTH"  : sys.argv[4],
    "WINDOW_HEIGHT" : sys.argv[5],
    "PIXEL_WIDTH"   : sys.argv[6],
}

top_file_lines = open(top_file_path, 'r').readlines()
new_top_file_lines = []

for line in top_file_lines:
    if "redefine-generic" in line:
        splitted = line.split()
        signal_name = splitted[0]
        signal_value = splitted[4]
        new_signal_value = generics[signal_name]
        line = f"{'':4s}{signal_name:<13s} : integer := {new_signal_value}"
        if ';' in signal_value:
            line += ';'
        line += '\n'
    new_top_file_lines.append(line)

new_top_file = open(top_file_path, 'w+')
new_top_file.writelines(new_top_file_lines)
new_top_file.close()