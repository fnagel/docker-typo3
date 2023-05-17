ARG php_tag
ARG composer_tag
ARG docker_image

# Install composer
FROM composer:${composer_tag} AS composer
COPY ./composer.json /app
RUN composer install --no-interaction --no-progress --ignore-platform-req=ext-intl

# Install webserver
FROM ${docker_image}:${php_tag}

# Copy files from composer container
COPY --from=composer /app ./

RUN chown -R www-data:www-data /var/www/html

# Add install sh file
COPY ./install.sh /var/www/html
