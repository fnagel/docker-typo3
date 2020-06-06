ARG php_tag

# Install composer
FROM composer:1 AS composer
COPY ./composer.json /app
RUN composer install --no-interaction --no-dev --no-progress --optimize-autoloader --ignore-platform-reqs

# Install webserver
FROM typo3.webserver:$php_tag

COPY --from=composer /app/web ./web
COPY --from=composer /app/vendor ./vendor

# Add install sh file
COPY ./install.sh /var/www/html
