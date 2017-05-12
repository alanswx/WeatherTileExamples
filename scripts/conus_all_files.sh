#!/bin/bash

for directory in `ls /data2/weather/MRMS` 
do
   # this is a directory
   echo $directory
   for file in `ls /data2/weather/MRMS/$directory/MRMS_SeamlessHSR*`
   do
     echo $file
     PRECIP=`echo $file | sed 's/\(.*\)SeamlessHSR/\1PrecipFlag/'`
     echo $PRECIP
     DATE=`echo $file | cut -f 4 -d _ | cut -f 1 -d .`

     # check to see if output file already exists, and skip
     if [ ! -f  output/conus/CONUS_$DATE.png  ]; then
       THECMD="./create_mrms_rain_conus.sh $file output/conus/CONUS_$DATE.png $PRECIP"
       echo $THECMD
       `$THECMD`
     fi
   done
done
