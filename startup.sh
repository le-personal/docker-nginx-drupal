#!/bin/bash

ENV_CONF=/etc/php5/fpm/pool.d/env.conf

echo "Configuring Nginx and PHP5-FPM with environment variables"

# Update php5-fpm with access to Docker environment variables
echo '[www]' > $ENV_CONF
for var in $(env | awk -F= '{print $1}')
do
	echo "Adding variable {$var}"
	echo "env[${var}] = ${!var}" >> $ENV_CONF
done