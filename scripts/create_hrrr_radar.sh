#!/bin/bash

GRIBNAME=$1

#
# 83 is reflectivity
#

# this will print out all the variables in this file
#wgrib2 -v $GRIBNAME

#83:80466128:d=2015102917:REFD Reflectivity [dB]:1000 m above ground:60 min fcst:


gdaldem color-relief -b 83 $GRIBNAME -alpha palettes/radar_pal.txt -of VRT output/hrrr.vrt
#python ./gdal2tiles.py -r bilinear  -z 0-9 output/hrrr.vrt output/hrrr
python ./gdal2tiles.py -r bilinear  output/hrrr.vrt output/hrrr
rm -f output/hrrr.vrt
