#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-ansi --no-dev --no-interaction --no-plugins --no-progress --no-scripts --optimize-autoloader
fi

if [ ! -f ".env" ]; then
    echo "Creating env file for env $APP_ENV"
    cp .env.example .env
    case "$APP_ENV" in
    "local")
        echo "Copying .env.example ... "
        cp .env.example .env
    ;;
    "prod")
        echo "Copying .env.prod ... "
        cp .env.prod .env
    ;;
    esac
else
    echo "env file exists."
fi

# php artisan migrate
php artisan clear
php artisan optimize:clear
php artisan migrate

# Fix files ownership.
chown -R www-data .
chown -R www-data /usr/share/nginx/html/storage
chown -R www-data /usr/share/nginx/html/storage/logs
chown -R www-data /usr/share/nginx/html/storage/framework
chown -R www-data /usr/share/nginx/html/storage/framework/sessions
chown -R www-data /usr/share/nginx/html/bootstrap
chown -R www-data /usr/share/nginx/html/bootstrap/cache

# Set correct permission.
chmod -R 775 /usr/share/nginx/html/storage
chmod -R 775 /usr/share/nginx/html/storage/logs
chmod -R 775 /usr/share/nginx/html/storage/framework
chmod -R 775 /usr/share/nginx/html/storage/framework/sessions
chmod -R 775 /usr/share/nginx/html/bootstrap
chmod -R 775 /usr/share/nginx/html/bootstrap/cache

php-fpm -D
nginx -g "daemon off;"
