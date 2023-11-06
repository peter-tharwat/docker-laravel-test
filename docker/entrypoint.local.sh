#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-progress --no-interaction --ignore-platform-reqs
fi

if [ ! -f ".env" ]; then
    echo "Creating env file for env $APP_ENV"
    cp .env.example .env
else
    echo "env file exists."
fi

sleep 10

# run artisan scripts
pushd /usr/share/nginx/html/
  php artisan migrate
popd


#php artisan migrate
php artisan optimize:clear
php artisan view:clear
php artisan route:clear

php-fpm -D
nginx -g "daemon off;"
