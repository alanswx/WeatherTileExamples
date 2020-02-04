FROM ubuntu:latest

# Update Ubuntu Software repository
RUN apt-get update && apt-get install -y software-properties-common wget
RUN add-apt-repository ppa:ubuntugis/ppa && apt-get update

RUN apt-get install -y gdal-bin libgdal-dev gfortran 

ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

RUN apt-get install -y python-pip python3-gdal python3-numpy curl


RUN curl -o wgrib2.tar.gz "ftp://ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz.v2.0.2"
#RUN curl -o wgrib2.tar.gz "ftp://ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz.v2.0.8"

ENV FC=gfortran

RUN tar zxf wgrib2.tar.gz && cd grib2 &&  make && cp wgrib2/wgrib2 /usr/bin/wgrib2
