#!/bin/bash


cd /var/tmp/ && mkdir php-dashboard 

composer create-project laravel/laravel php-dashboard

# Move Laravel files to correct place
#RUN mv /var/tmp/temp/* /var/www/
#RUN mv /var/tmp/temp/.* /var/www/

cd /var/tmp/ 

rm ./php-dashboard/.env && rm ./php-dashboard/.env.example

mv ./php-dashboard/.* /var/www/
mv ./php-dashboard/* /var/www/

cd /var/www/

if [ ! -f ".env.example" ]; then
    echo "Creating env-example file for env $APP_ENV"
    touch .env.example
else
    echo "env-example file exists."
fi

if [ ! -f ".env" ]; then
    echo "Creating env file for env $APP_ENV"
    cp .env.example .env
else
    echo "env file exists."
fi

if [ -z "$DB_PASSWORD" ]; then
  echo "The VARIABLE is not set"
  exit 1
fi


if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-progress --no-interaction
fi



php artisan key:generate
php artisan config:clear
php artisan view:clear
php artisan cache:clear



npm install

php-fpm -t
nginx -t

php-fpm -D
nginx -g "daemon off;"