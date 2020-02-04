#!/bin/bash

#
# $1 is the input file
# $2 is the output directory

# check to see if the file ends in gzip
#   if gzip, use the virtual file system so we don't have to uncompress the file
file="$1"
if [ ${file: -3} == ".gz" ]
then
  file=/vsigzip/${file}
fi

gdaldem color-relief  $file  -alpha palettes/lightning.txt -of VRT now.vrt 
#python ./gdal2tiles.py -r bilinear  -z 0-9 now.vrt $2 
python3 ./gdal2tiles.py -r bilinear  now.vrt $2 
#echo $1 > $2/source.txt
rm now.vrt

