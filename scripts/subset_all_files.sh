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

     THECMD="./create_mrms_subset.sh $file output/seattle/Seattle_$DATE.png $PRECIP"
     echo $THECMD
     `$THECMD`

   done
done
