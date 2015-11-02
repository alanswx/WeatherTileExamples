#!/bin/bash

#
# $1 is the input file
# $2 is the output directory
# $3 is the precip type

# check to see if the file ends in gzip
#   if gzip, use the virtual file system so we don't have to uncompress the file
file="$1"
if [ ${file: -3} == ".gz" ]
then
  file=/vsigzip/${file}
fi

file2="$3"
if [ ${file2: -3} == ".gz" ]
then
  file2=/vsigzip/${file2}
fi


#
# create the rain mask
#

gdaldem color-relief $file2  -alpha palettes/precip_rain_only.txt -of VRT rain_mask.vrt
gdaldem color-relief $file2  -alpha palettes/precip_snow_only.txt -of VRT snow_mask.vrt
gdaldem color-relief  $file  -alpha palettes/radar_pal.txt -of VRT rain.vrt 
gdaldem color-relief  $file  -alpha palettes/precipsnow_pal.txt -of VRT snow.vrt 

gdal_translate -b 4 snow_mask.vrt -of GTiff snow_mask.tif
gdal_translate -b 4 rain_mask.vrt -of GTiff rain_mask.tif

gdal_translate -b 1 rain.vrt -of GTiff rainband1.tif
gdal_translate -b 2 rain.vrt -of GTiff rainband2.tif
gdal_translate -b 3 rain.vrt -of GTiff rainband3.tif

gdal_translate -b 1 snow.vrt -of GTiff snowband1.tif
gdal_translate -b 2 snow.vrt -of GTiff snowband2.tif
gdal_translate -b 3 snow.vrt -of GTiff snowband3.tif

gdalbuildvrt -separate rainstack.vrt rainband1.tif rainband2.tif rainband3.tif rain_mask.tif
gdalbuildvrt -separate snowstack.vrt snowband1.tif snowband2.tif snowband3.tif snow_mask.tif

gdal_translate snowstack.vrt -mask 4 -of GTiff snow.tif

gdalwarp rainstack.vrt snow.tif   -of GTiff rainsnow.tif
python ./gdal2tiles.py -r bilinear  rainsnow.tif $2 

rm rain.vrt
rm snow.vrt
rm rainband?.tif
rm rainband?.tif.aux.xml
rm snowband?.tif
rm snowband?.tif.aux.xml
rm rain_mask.tif
rm snow_mask.tif
rm rainsnow.tif

rm snow_mask.vrt
rm rain_mask.vrt

rm snow_mask.tif.aux.xml
rm rain_mask.tif.aux.xml
rm snowstack.vrt
rm rainstack.vrt
rm snow.tif
rm snow.tif.msk


#gdaldem color-relief  $file  -alpha palettes/radar_pal.txt -of VRT now.vrt 
#python ./gdal2tiles.py -r bilinear  -z 0-9 now.vrt $2 
#python ./gdal2tiles.py -r bilinear  now.vrt $2 
#echo $1 > $2/source.txt
#rm now.vrt


