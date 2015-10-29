#!/bin/bash

URL=http://mrms.ncep.noaa.gov/data/2D/SeamlessHSR/
echo $URL
FILE=`curl $URL | grep "grib2.gz" |  tail -n 1 | cut -f 2 -d \"`
echo $URL$FILE
wget -N -c $URL$FILE

echo "run command and pass $FILE "

echo "create radar from $FILE "
./create_mrms_tiles.sh $FILE mrms

