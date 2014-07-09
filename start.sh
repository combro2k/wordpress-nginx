#!/bin/bash
# Starts up Nginx and PHP within the container.

DATADIR="/data"

# Don't continue if we catch an error.
set -e

if [[ ! -f "/var/lib/wordpress/wp-config.php" && -f "/data/wp-config.php" ]]; then
    mv /data/wp-config.php /var/lib/wordpress/wp-config.php
    ln -nfs /var/lib/wordpress/wp-config.php /data/wp-config.php
fi

if [[ ! -d "/var/lib/wordpress/wp-content" ]]; then
    mv /data/wp-content /var/lib/wordpress/wp-content
    ln -nfs /var/lib/wordpress/wp-content /data/wp-content
fi

service php5-fpm start
chmod 666 /var/run/php5-fpm.sock
/usr/sbin/nginx