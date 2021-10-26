ARG php_tag
ARG composer_tag
ARG docker_image

# Install composer
FROM composer:${composer_tag} AS composer
COPY ./composer.json /app
RUN composer install --no-interaction --no-dev --no-progress --optimize-autoloader --ignore-platform-reqs

# Install webserver
FROM ${docker_image}:${php_tag}

COPY --from=composer /app/web ./web
COPY --from=composer /app/vendor ./vendor

RUN chown -R www-data:www-data /var/www/html

# Add install sh file
COPY ./install.sh /var/www/html
