# DEPLOY LARAVEL WITH DOCKER
### Prerequisites
-  Dockerfile
-  docker-compose
-  composer
-  php:7.0.0 on host machine (ubuntu)

### Steps
1. run git clone https://github.com/academynusa/perpus-laravel.git
2. Create Dockerfile
   - Use php:7.2-apache as base image
   - Install all dependencies
   - set workdir to /var/www/html and copy all files from local filesystem to the container workdir
   - run composer install
   - set permission and owner of the storage, bootstrap/cache storage
   - expose port 8000
   - use executable script for the entrypoint
  
2. Create docker-compose.yml
   - Create 2 service, app and db
   - Build service app from Dockerfile. Set environment, volumes, network and ports
   - Build service db using mysql:5.7
   - set environment, volumes, ports and network of the db service
  
3. Create executable script named entrypoint.sh
   - Create this script to execute php artisan key:generate, php artisan migrate, php artisan db:seed
   - Change the value of varibale in .env using sed command

4. run composer update on local working directory (perpus_laravel)
5. run docker-compose up --build
