
URL=http://nomads.ncep.noaa.gov/pub/data/nccf/nonoperational/com/hrrr/prod/
DATE=`curl "$URL" | grep "href=\"h" | tail -n 1 | cut -f 2 -d \"`
URL=$URL$DATE
echo $URL
FILE=`curl $URL | grep "wrfsubhf01.grib2" | grep -v "idx" | tail -n 1 | cut -f 2 -d \"`
echo $URL$FILE
wget $URL$FILE

echo "run command and pass $FILE "
