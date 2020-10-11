#!/bin/bash

mkdir -p data
mkdir -p output

# HRRR file format:
# hrrr.$DATE/$LOC/hrrr.t${HR}z.$GRID$FP.grib2
# DATE - (YYYYMMDD) - the date the forecast was run in UTC
# LOC - alaska | conus
# HR - (HH) - the hour the forecast was run in UTC
# GRID - wrfprs | wrfnat | wrfsfc | wrfsub
# FP - (HH) - the forecast period. 00 - 36
LOC=conus
GRID=wrfsubhf
FP=01

BASE=https://nomads.ncep.noaa.gov/pub/data/nccf/com/hrrr/prod/
DATE=`curl $BASE | grep "href=\"h" | tail -n 1 | cut -f 2 -d \" | cut -c6-13`
LATEST="/hrrr.$DATE/$LOC/"
URL="$BASE$LATEST"

HR=`curl $URL | grep "$GRID$FP.grib2" | grep -v "idx" | tail -n 1 | cut -f 2 -d \" | cut -c7-8`
FILE="hrrr.t${HR}z.$GRID$FP.grib2"
wget -N -c -P data "$URL$FILE"

echo "run command and pass data/$FILE "

echo "create winds from data/$FILE "
./create_hrrr_winds.sh data/$FILE
echo "create radar from data/$FILE "
./create_hrrr_radar.sh  data/$FILE

