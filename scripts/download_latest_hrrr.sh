#!/bin/bash

mkdir -p data
mkdir -p output

URL=http://nomads.ncep.noaa.gov/pub/data/nccf/com/hrrr/prod/
DATE=`curl "$URL" | grep "href=\"h" | tail -n 1 | cut -f 2 -d \"`
URL=$URL$DATE
echo $URL
FILE=`curl $URL | grep "wrfsubhf01.grib2" | grep -v "idx" | tail -n 1 | cut -f 2 -d \"`
echo $URL$FILE
wget -N -c -P data $URL$FILE

echo "run command and pass data/$FILE "

echo "create winds from data/$FILE "
./create_hrrr_winds.sh data/$FILE
echo "create radar from data/$FILE "
./create_hrrr_radar.sh  data/$FILE

