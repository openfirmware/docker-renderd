#!/bin/bash
set -e

# Rebuild renderd configuration
cp renderd.conf /etc/renderd.conf
for i in /usr/local/share/maps/style/*; do
	if [ -e $i/renderd.conf ]; then
		cat $i/renderd.conf >> /etc/renderd.conf
	fi
done

# Start runit
/usr/sbin/runit_bootstrap
