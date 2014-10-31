# nginx-drupal
Includes nginx and php5 running with supervisor and Drupal
Now includes Drush. This image is based on luis/nginx-php

## To build

```
$ sudo docker build -t yourname/nginx-drupal .
```
## To run

Nginx will look for files in /var/www so you need to map your application to that directory.

```
sudo docker run -d -p 8000:80 --volumes-from APPDATA -v /home/me/myphpapp:/var/www --name lemp yourname/nginx-drupal
```

The --volumes-from argument means that you're using a Data-only container pattern.

If you want to link the container to a MySQL/MariaDB contaier do:

```
sudo docker run -d -p 8000:80 --volumes-from APPDATA -v /home/me/myphpapp:/var/www --name lemp my_mysql_container:mysql yourname/nginx-drupal
```

The startup.sh script will add the environment variables with MYSQL_ to /etc/php5/fpm/pool.d/env.conf so PHP-FPM detects them. If you need to use them you can do:
<?php getenv("SOME_ENV_VARIABLE_THAT_HAS_MYSQL_IN_THE_NAME"); ?>

## Running Drush
With Fig this is actually easier and is the recommended way since if you're running Docker without fig, you'll have to link all containers before you run drush.

This is an example on how to run fig

```
mysql:
  image: mysql
  expose:
    - "3306"
  volumes_from:
    - MYWEBSITE_MYSQL_1_DATA
  environment:
    MYSQL_ROOT_PASSWORD: 123
web:
  image: iiiepe/nginx-drupal
  volumes:
    - "./:/var/www"
    - "/var/log/docker/mydrupalwebsite:/var/log/supervisor"
  ports:
    - "80:80"
  links:
    - "mysql:mysql"
```

And now, all you have to do is:

		$ fig run --rm web drush

I usually create a script to avoid that command, create a file drush in your root directory and enter:

```
#!/bin/bash
fig run --rm web drush "$@"
```

The only limitation of Drush is that it has to be run from the root directory of your project.

Do

		$ chmod +x drush
		$ ./drush status

And it will show the status of your website, assuming that everything is configured.

### Testing that it works
Go to http://ip:port/test and you should see the output of phpinfo()

### Credits
Credit to: Nian Wang 
Original work can be found at: https://github.com/nianwang/docker-index

### License
The original author didn't relase the code with a License. But this code is released under the MIT License.