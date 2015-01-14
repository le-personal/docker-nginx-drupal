FROM luis/nginx-php

MAINTAINER Luis Elizondo "lelizondo@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

RUN /usr/local/bin/composer self-update
RUN /usr/local/bin/composer global require drush/drush:6.*
RUN ln -s /.composer/vendor/drush/drush/drush /usr/local/bin/drush

RUN usermod -u 1000 www-data
RUN usermod -a -G users www-data

EXPOSE 80

RUN chown -R www-data:www-data /var/www

VOLUME ["/var/www/sites/default/files"]

WORKDIR /var/www

CMD ["/usr/bin/supervisord", "-n"]
