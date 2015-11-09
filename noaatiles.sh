#!/bin/bash

# install EPEL so we have gdal
sudo yum install -y epel-release
# install gdal
sudo yum install -y gdal
# gdal-python is required for the gdal2tiles.py
sudo yum install -y gdal-python
# wgrib2 is useful to see an inventory of the .grib2 files
# compile our own
#sudo yum install -y wgrib2

# we need fortran to compile wgrib2
sudo yum install -y gcc-gfortran

# install our own wgrib2
if [ -e "wgrib2.tar.gz" ];then
 echo "already have wgrib2.tar.gz"
else
  curl -o wgrib2.tar.gz "ftp://ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz.v2.0.2"
fi
tar zxf wgrib2.tar.gz
cd grib2
FC=gfortran
export FC
make
cp wgrib2/wgrib2 /usr/bin/wgrib2
cd -

ln -s /vagrant_data /home/vagrant/vagrant_data
chmod a+rwx /home/vagrant/vagrant_data
