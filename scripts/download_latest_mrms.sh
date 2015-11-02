#!/bin/bash

mkdir -p data
mkdir -p output

URL=http://mrms.ncep.noaa.gov/data/2D/SeamlessHSR/
echo $URL
FILE=`curl $URL | grep "grib2.gz" |  tail -n 1 | cut -f 2 -d \"`
echo $URL$FILE
wget -N -c -P data  $URL$FILE


URL=http://mrms.ncep.noaa.gov/data/2D/PrecipFlag/
echo $URL
FILE2=`curl $URL | grep "grib2.gz" |  tail -n 1 | cut -f 2 -d \"`
echo $URL$FILE2
wget -N -c -P data  $URL$FILE2

echo "run command and pass data/$FILE "

echo "create radar from data/$FILE "
./create_mrms_tiles.sh data/$FILE output/mrms data/$FILE2

URL=http://mrms.ncep.noaa.gov/data/2D/NLDN_LightningDensity_030_min/
echo $URL
FILE=`curl $URL | grep "grib2.gz" |  tail -n 1 | cut -f 2 -d \"`
echo $URL$FILE
wget -N -c -P data  $URL$FILE

echo "run command and pass data/$FILE "

echo "create radar from data/$FILE "
./create_mrms_lightning_tiles.sh data/$FILE output/mrms_lightning

