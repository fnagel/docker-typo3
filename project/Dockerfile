ARG php_tag

## Install composer file
FROM composer:1 AS composer
COPY ./composer.json /app
COPY ./composer.lock /app
RUN composer install --no-interaction --no-dev --no-progress --optimize-autoloader --ignore-platform-reqs

## Install webserver
FROM typo3.webserver:$php_tag

# Copy composer dependencies
COPY --from=composer /app/web ./web
COPY --from=composer /app/vendor ./vendor

# Copy project files
COPY ./web/* /web/

# Copy data folder
COPY ./.docker/project/data /var/www/project/data

# Prepare TYPO3
RUN vendor/bin/typo3cms install:fixfolderstructure

RUN chown -R www-data:www-data ./web
