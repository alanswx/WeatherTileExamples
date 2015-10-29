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

gdaldem color-relief  $file  -alpha palettes/radar_pal.txt -of VRT now.vrt 
#python ./gdal2tiles.py -r bilinear  -z 0-9 now.vrt $2 
python ./gdal2tiles.py -r bilinear  now.vrt $2 
#echo $1 > $2/source.txt
rm now.vrt

#gdaldem color-relief MRMS_SeamlessHSR_00.00_20150921-030000.grib2 -alpha seamramp3.txt -of PNG o.png
# gdaldem color-relief -b 83 hrrr.t03z.wrfsubhf01.grib2 -alpha seamramp3.txt -of GTiff hrr.tiff
#gdaldem color-relief  MRMS_SeamlessHSR_00.00_20150929-233800.grib2  -alpha radar_pal.txt -of GTiff  now.tiff

#
# create a tileset for a HRRR reflectivity sample
#
# -b 83 corresponds to the REFD band: (wgrib2 -v hrrr.t03z.wrfsubhf01.grib2)
#5:2235401:d=2015092203:REFD Reflectivity [dB]:1000 m above ground:15 min fcst:
#6:2506650:d=2015092203:REFD Reflectivity [dB]:4000 m above ground:15 min fcst:
#31:22584887:d=2015092203:REFD Reflectivity [dB]:1000 m above ground:30 min fcst:
#32:22913085:d=2015092203:REFD Reflectivity [dB]:4000 m above ground:30 min fcst:
#57:43600198:d=2015092203:REFD Reflectivity [dB]:1000 m above ground:45 min fcst:
#58:43971105:d=2015092203:REFD Reflectivity [dB]:4000 m above ground:45 min fcst:
#83:65095950:d=2015092203:REFD Reflectivity [dB]:1000 m above ground:60 min fcst:
#84:65488840:d=2015092203:REFD Reflectivity [dB]:4000 m above ground:60 min fcst:

#gdaldem color-relief -b 83 hrrr.t03z.wrfsubhf01.grib2 -alpha radar_pal.txt -of VRT hrrr.vrt
#python ./gdal2tiles.py -r bilinear  -z 0-9 hrrr.vrt hrrr
#rm -f hrrr.vrt

#
# create a tileset for an MRMS sample
#
# there is only one band in the MRMS grib2
#gdaldem color-relief  MRMS_SeamlessHSR_00.00_20150929-233800.grib2  -alpha radar_pal.txt -of VRT now.vrt 
#python ./gdal2tiles.py -r bilinear  -z 0-9 now.vrt now
#rm -f now.vrt
