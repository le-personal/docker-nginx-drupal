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

# We need to configure the /etc/hosts file so sendmail works properly
# sendmail needs in this file something in the form of host.domain
# this is actually really easy to do with docker itself, adding -h something.localdomain
# when running the container, but it presents two problems:
# first, it doesn't work with maestro-ng and many other solutions that don't support
# the -h argument
# second, there's no way to use the container's name, when using -h we need to define
# the container's name so is not an ideal solution because other thinks can break
# when setting the name manually
# We then just rewrite the hosts file
echo "Configuring /etc/hosts"

CONTAINER_IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
CONTAINER_NAME=$(echo $HOSTNAME)

echo $CONTAINER_IP "	" $CONTAINER_NAME $CONTAINER_NAME".localdomain" > /etc/hosts
echo "127.0.0.1 	localhost" >> /etc/hosts
echo "::1	localhost ip6-localhost ip6-loopback" >> /etc/hosts
echo "fe00::0	ip6-localnet" >> /etc/hosts
echo "ff00::0	ip6-mcastprefix" >> /etc/hosts
echo "ff02::1	ip6-allnodes" >> /etc/hosts
echo "ff02::2	ip6-allrouters" >> /etc/hosts