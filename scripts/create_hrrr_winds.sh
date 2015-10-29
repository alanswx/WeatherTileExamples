#!/bin/bash

GRIBNAME=$1

#
# 14 and 15 are the two layers of wind we will use to plot -- you can use  wgrib to look at the grib and see if you want to plot something else
#

#14:10481048:d=2015092203:UGRD:10 m above ground:15 min fcst:
#15:11792425:d=2015092203:VGRD:10 m above ground:15 min fcst:

gdaldem color-relief -b 14 $GRIBNAME  -alpha palettes/grey_uv.txt -of GTiff hrrr_u_10.tiff
gdaldem color-relief -b 15 $GRIBNAME  -alpha palettes/grey_uv.txt -of GTiff hrrr_v_10.tiff
python ./gdal2tiles.py -r bilinear  hrrr_u_10.tiff hrrr_u_tiles
python ./gdal2tiles.py -r bilinear  hrrr_v_10.tiff hrrr_v_tiles
