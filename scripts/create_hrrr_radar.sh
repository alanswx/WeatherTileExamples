#!/bin/bash

GRIBNAME=$1

#
# 83 is reflectivity
#

# this will print out all the variables in this file
#wgrib2 -v $GRIBNAME

#83:80466128:d=2015102917:REFD Reflectivity [dB]:1000 m above ground:60 min fcst:

#
# use the snow mask to create a new.grib2 that is setup for the new palette
#
wgrib2 $GRIBNAME  -match ":(CSNOW|REFD):(surface|1000 m above ground):15 min"  -if ":CSNOW.*:.*:15.*" -rpn sto_1 -fi  -if ":REFD.*:1000 m.*:15.*:" -rpn sto_2 -fi -if_reg '1:2' -rpn "rcl_1:200:*:rcl_2:+"  -set_var REFD -grib_out new.grib2


#gdaldem color-relief -b 83 $GRIBNAME -alpha palettes/radar_pal.txt -of VRT output/hrrr.vrt
gdaldem color-relief new.grib2 -alpha palettes/radar_rainsnow_pal.txt -of VRT output/hrrr.vrt
#python ./gdal2tiles.py -r bilinear  -z 0-9 output/hrrr.vrt output/hrrr
python ./gdal2tiles.py -r bilinear  output/hrrr.vrt output/hrrr
rm -f output/hrrr.vrt
rm new.grib2
