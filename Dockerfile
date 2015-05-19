# DOCKER-VERSION 1.6.0
# VERSION 0.1

FROM openfirmware/mapnik

RUN apt-get update && apt-get install -y apache2 apache2-dev autoconf build-essential git libtool runit

WORKDIR /tmp
RUN git clone https://github.com/openstreetmap/mod_tile.git &&\
    cd mod_tile &&\
    ./autogen.sh &&\
    ./configure &&\
    make &&\
    make install &&\
    make install-mod_tile &&\
    ldconfig &&\
    cd /tmp &&\
    rm -rf mod_tile

RUN mkdir -p /var/lib/mod_tile && chown www-data:www-data /var/lib/mod_tile
RUN mkdir -p /var/run/renderd  && chown www-data:www-data /var/run/renderd

RUN mkdir -p /etc/service/renderd && mkdir -p /etc/service/apache2
COPY ./apache2/run /etc/service/apache2/run
COPY ./renderd/run /etc/service/renderd/run
RUN chown root:root /etc/service/renderd/run /etc/service/apache2/run
RUN chmod u+x       /etc/service/renderd/run /etc/service/apache2/run

COPY ./tile.load /etc/apache2/mods-available/tile.load
COPY ./apache2/000-default.conf /etc/apache2/sites-enabled/000-default.conf
RUN ln -s /etc/apache2/mods-available/tile.load /etc/apache2/mods-enabled/

WORKDIR /var/lib/mod_tile
COPY ./renderd/renderd.conf renderd.conf
COPY ./setup.sh setup.sh

COPY runit_bootstrap /usr/sbin/runit_bootstrap
RUN chmod 755 /usr/sbin/runit_bootstrap

EXPOSE 80
ENTRYPOINT ["/var/lib/mod_tile/setup.sh"]
