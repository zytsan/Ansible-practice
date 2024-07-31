# Use PHP 7.2 as the base image
FROM php:7.2-apache

# Install necessary extensions and dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite
# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Allow Superuser access
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Set working directory
WORKDIR /var/www/html

# Copy the application code
COPY . /var/www/html

#Allow necessary plugin
RUN composer config --global allow-plugins.kylekatarnls/update-helper true
RUN composer config --global allow-plugins.symfony/thanks true

# Run Composer install
#RUN composer dump-autoload
#RUN composer update --no-scripts 
RUN composer install

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN chmod -R 775 storage/*
RUN chmod -R 775 bootstrap/cache/*
RUN chmod -R 775 public/*
RUN chmod -R 775 /var/www/html


RUN chown -R www-data:www-data storage/*
RUN chown -R www-data:www-data bootstrap/cache/*

# Expose port 8000
EXPOSE 8000

# Run the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

