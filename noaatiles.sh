#!/bin/bash

# install EPEL so we have gdal
sudo yum install -y epel-release
# install gdal
sudo yum install -y gdal
# gdal-python is required for the gdal2tiles.py
sudo yum install -y gdal-python
# wgrib2 is useful to see an inventory of the .grib2 files
sudo yum install -y wgrib2

