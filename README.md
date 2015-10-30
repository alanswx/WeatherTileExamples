# WeatherTileExamples
Simple examples to make tilesets for your favorite mapping system.

This is a simple set of examples that will show you how to take some of the newest, coolest NOAA products and turn them into tile sets for use in a web map mashup, or with WhirlyGlobe-Maply.

These examples rely on Vagrant and VirtualBox to run a Centos 7 environment which we will use yum to install gdal.  Centos 7 with the epel gives us a reasonable install of gdal (version >= 1.11.2). We need this new of a version to handle opening the MRMS gz file without gzipping them (using a virtual file system) and for the alpha to work correctly with our palette.


## About the data

### Multi Radar Multi Sensor (MRMS)

[MRMS](http://www.nssl.noaa.gov/projects/mrms/) is a software product built by the University of Oklahoma that is now being run in real time by the National Weather Service. The data can be retrieved by [LDM](https://docs.google.com/document/d/1LeVcn_taIXZgzZb5JgWqaVr0xVs7GmA6RpHcb8ZGiwk/edit) or [HTTP](http://mrms.ncep.noaa.gov/data/).

There are a number of interesting data products with MRMS including 3D slices of the atmosphere, lightning, hail, etc. We will show how to plot Reflectivity (Radar).


### High Resolution Rapid Refresh (HRRR)


[HRRR](http://ruc.noaa.gov/hrrr/) is a high resolution model that is run by NCEP and is updated very often. It can be found via [NCEP NOMADS HTTP](http://nomads.ncep.noaa.gov/). We will look at the wind forecast, and composite reflectivity forecast (simulated Radar)

## Steps to convert the data


1. Install [Vagrant](https://docs.vagrantup.com/v2/installation/) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. clone this repository
3. cd into the directory with the VagrantFile and type `vagrant up`
4. vagrant will load a centos image, and boot it. It will run the shell provisioner noaatiles.sh to install gdal, python bindings, and wgrib2
5. type `vagrant ssh` to get into the VM
6. type `cd vagrant_data` - this will put you in the scripts directory
7. type `./download_latest_hrrr.sh` to download and create 3 tile sets from the latest HRRR model
8. type `./download_latest_mrms.sh` to download and create a tile set from the latest MRMS

What do you end up with?

##### `data` directory

* MRMS and HRRR model files

#### `output` directory
* hrrr - a directory that has a tileset of the composite reflectivity plotted with alpha, that looks like future radar ![HRR Wind ScreenShot](/examplescreenshots/hrrrradar.png)
* wind vectors split by component. Take a look at this page for more information: [Wind: u and v Components](http://wx.gmu.edu/dev/clim301/lectures/wind/wind-uv.html)
* hrrr_u_tiles - a tileset of the u vector of the wind  ![HRR Wind ScreenShot](/examplescreenshots/hrrrwind.png)
* hrrr_v_tiles - a tileset of the v vector of the wind
* hrrr_speed_tiles - a tileset of the speed of the wind ![HRR Wind ScreenShot](/examplescreenshots/hrrrwindspeed.png)
* mrms - a radar tileset from mrms data ![MRMS Radar ScreenShot](/examplescreenshots/mrmsradar.png)


## Advanced modifications

### More tile levels
Modify this line in create_hrrr_radar.sh:

 ```bash
	python ./gdal2tiles.py -r bilinear -z 0-9 output/hrrr.vrt output/hrrr
 ```
  z is the number of z levels for the tiles. If you want it to create a higher resolution set of tiles, try this command instead.
 
####Change the Palettes
This is inside `palettes/radar_pal.txt`

	nv 		0 		255  	0 		0
	0% 		0 		0 		0 		0
	-30     255     255     255  0
	-25      0       0       0   255
 	-20     255     255     255  255
	-15     233     204     249  255
	-10     207     128     223  255
	-05     131     51      147  255
	00      58       0      176  255
	05      29       0      215  255
	10       0       0      255  255
	15      3       60      175  255
	20      5       119     95  	255
 	25      8       179     15  	255
 	30      132     217     8  		255
 	35      255     255      0  	255
 	40      255     170      0  	255
 	45      255     85       0  	255
 	50      255      0       0  	255
 	55      179      0       0  	255
 	60      102      0       0  	255
 	65      51       0       0  	255
 	70       0       0       0  	255
 	75      250     197     250  	255
 	80      255     255     255  	255
 	100% 	255 	255 	255 	255
