#!/bin/bash

FILELIST=`find output/conus/ -print | grep png$`
for file in $FILELIST
   do
     #echo $file
     part=`echo "$file" | cut -d_ -f2`
     #echo $part
     outputname="output/seast/SEAST_$part"
     THECMD="gdal_translate -srcwin 4500 2000 500 500 -of PNG $file -of PNG $outputname"
     echo $THECMD
     if [ ! -f  output/seast/SEAST_$part  ]; then
        echo $THECMD
        `$THECMD`
     fi
     #PRECIP=`echo $file | sed 's/\(.*\)SeamlessHSR/\1PrecipFlag/'`
     #echo $PRECIP
     #DATE=`echo $file | cut -f 4 -d _ | cut -f 1 -d .`

     # check to see if output file already exists, and skip
     #if [ ! -f  output/conus/CONUS_$DATE.png  ]; then
     #  THECMD="./create_mrms_rain_conus.sh $file output/conus/CONUS_$DATE.png $PRECIP"
     #  echo $THECMD
     #  `$THECMD`
done
