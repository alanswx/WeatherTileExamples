#!/bin/bash

#
# /data2/weather/MRMS/20170209/
# /data2/weather/MRMS/20170209/MRMS_PrecipFlag_00.00_20170209-235800.grib2.gz  /data2/weather/MRMS/20170209/MRMS_SeamlessHSR_00.00_20170209-235800.grib2.gz
#

#
# $1 is the input file
# $2 is the output directory
# $3 is the precip type

#
# check to see if the file ends in gzip
#   if gzip, use the virtual file system so we don't have to uncompress the file
#### WE DON'T NEED TO GUNZIP - WILL USE zcat BELOW
file="$1"
#if [ ${file: -3} == ".gz" ]
#then
#  file=/vsigzip/${file}
#fi

file2="$3"
#### WE DON'T NEED TO GUNZIP - WILL USE zcat BELOW
#if [ ${file2: -3} == ".gz" ]
#then
#  file2=/vsigzip/${file2}
#fi


echo "file:"
echo $file
echo "file2:"
echo $file2
echo "output:"
echo $2

#
# create a new grib that has both the precip flag (file2) and the seamless HSR on it (file)
#
zcat $file2 $file > input.grib2 

#
# run wgrib2 to create a synthetic grib that has the snow field with the reflectivity + 200
#
wgrib2 input.grib2  -if ":*:.*:.*parmcat=6.*:" -rpn sto_1 -fi  -if ":*:.*:.*parmcat=8.*:" -rpn sto_2 -fi -if_reg '1:2' -rpn "rcl_1:3
:==:rcl_1:4:==:+:200:*:rcl_2:+"  -set_var REFD -grib_out new.grib2

#RPN:
# store precip type flag in register 1
# store radar value in register 2
# precip == 3 or precip == 4 (get 1 for everything where precip is 3 or 4, 0 for everything else)
# multiple precip flag by 200 - 0 for everything where it isn't snow, 200 where there is snow
# rain + the last value will finish it off -- so we end up with 200+ reflectivity in places where it is snowing


# now we just need a palette that has rain in the beginning, and is duplicated again to have snow in the top part

gdaldem color-relief  new.grib2  -alpha palettes/radar_rainsnow_pal.txt -of VRT now.vrt 

gdal_translate -a_ullr -180 90 180 -90 -a_srs "EPSG:4326" -of VRT now.vrt out.vrt

# 128x160 image
gdal_translate -projwin -124.1 49 -115.85 42.4  -a_srs "EPSG:4326"  out.vrt -of PNG  $2

# create tiles
#python ./gdal2tiles.py -r bilinear  -z 0-9 now.vrt $2 


#python ./gdal2tiles.py -r bilinear  now.vrt $2 
#echo $1 > $2/source.txt

rm input.grib2
rm new.grib2
rm out.vrt
rm now.vrt

