# docker-renderd

Apache + mod_tile + renderd for rendering mapnik tiles in a Docker container.

Based on work from [Maximilian Güntner's renderd-osm image](https://github.com/mguentner/docker-renderd-osm), although I took a different path to including map styles. If you are looking for a faster way to get up and running I recommend checking out his guide.

## Usage

This image requires multiple other images and containers.

* Postgres prepared for OSM, with data imported
* OSM-Bright image

Start with creating a data-only container for storing your tiles:

    $ sudo docker run -d -v /var/lib/tiles --name=tiles-data busybox

    $ sudo docker run -d --volumes-from osm-bright --volumes-from tiles-data -p 80:80 --link postgres-osm:pg --name renderd openfirmware/renderd

And then check out [http://dockerhost/osmb/0/0/0.png](http://dockerhost/osmb/0/0/0.png).

I will be writing up a complete guide to all my OSM docker images, it should be out by June 2015. If it isn't then email me.

## About

This Dockerfile was built with information from the [Ubuntu 14.04 Switch2OSM guide](http://switch2osm.org/serving-tiles/manually-building-a-tile-server-14-04/).
