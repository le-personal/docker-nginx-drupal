FROM ubuntu:14.04

MAINTAINER Luis Elizondo "lelizondo@gmail.com"
ENV DEBIAN_FRONTEND noninteractive

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Update system
RUN apt-get update && apt-get dist-upgrade -y

# Basic packages
RUN apt-get -y install php5-fpm php5-mysql php-apc php5-imagick php5-imap php5-mcrypt php5-curl php5-cli php5-gd php5-pgsql php5-sqlite php5-common php-pear curl php5-json php5-redis php5-memcache
RUN apt-get -y install nginx-extras
RUN apt-get -y install git curl supervisor

RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

RUN php5enmod mcrypt

RUN /usr/bin/curl -sS https://getcomposer.org/installer | /usr/bin/php
RUN /bin/mv composer.phar /usr/local/bin/composer
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Composer and Drush
RUN /usr/local/bin/composer self-update
RUN /usr/local/bin/composer global require drush/drush:6.*
RUN ln -s /.composer/vendor/drush/drush/drush /usr/local/bin/drush

# PHP
RUN sed -i 's/memory_limit = .*/memory_limit = 196M/' /etc/php5/fpm/php.ini
RUN sed -i 's/cgi.fix_pathinfo = .*/cgi.fix_pathinfo = 0/' /etc/php5/fpm/php.ini
RUN sed -i 's/upload_max_filesize = .*/upload_max_filesize = 500M/' /etc/php5/fpm/php.ini
RUN sed -i 's/post_max_size = .*/post_max_size = 500M/' /etc/php5/fpm/php.ini

RUN mkdir /var/www
RUN usermod -u 1000 www-data
RUN usermod -a -G users www-data
RUN chown -R www-data:www-data /var/www

EXPOSE 80
WORKDIR /var/www
VOLUME ["/var/www/sites/default/files"]
CMD ["/usr/bin/supervisord", "-n"]

# Startup script
# This startup script wll configure nginx
ADD ./startup.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh

# Add configuration files
#ADD ./config/realip.conf /etc/nginx/conf.d/realip.conf
ADD ./config/supervisord-nginx.conf /etc/supervisor/conf.d/supervisord-nginx.conf
RUN mkdir -p /var/cache/nginx/microcache
ADD ./config/nginx.conf /etc/nginx/nginx.conf
ADD ./config/mime.types /etc/nginx/mime.types
ADD ./config/fastcgi.conf /etc/nginx/fastcgi.conf
ADD ./config/blacklist.conf /etc/nginx/blacklist.conf
ADD ./config/fastcgi_microcache_zone.conf /etc/nginx/fastcgi_microcache_zone.conf
ADD ./config/drupal.conf /etc/nginx/drupal.conf
ADD ./config/fastcgi_drupal.conf /etc/nginx/fastcgi_drupal.conf
ADD ./config/map_cache.conf /etc/nginx/map_cache.conf
ADD ./config/microcache_fcgi_auth.conf /etc/nginx/microcache_fcgi_auth.conf
ADD ./config/fastcgi_no_args_drupal.conf /etc/nginx/fastcgi_no_args_drupal.conf
ADD ./config/drupal_upload_progress.conf /etc/nginx/drupal_upload_progress.conf
ADD ./config/default /etc/nginx/sites-enabled/default
