#!/bin/bash

# Copy .env file and generate application key
cp .env.example .env
php artisan key:generate

# Set database configuration
sed -i 's/DB_DATABASE=homestead/DB_DATABASE=perpusku_gc/' .env
sed -i 's/DB_USERNAME=homestead/DB_USERNAME=tsania72/' .env
sed -i 's/DB_PASSWORD=secret/DB_PASSWORD=tsaniajuara1/' .env
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=db/' .env

# Run database migrations and seed the database
php artisan migrate
php artisan db:seed
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start Apache in the foreground
apache2-foreground

