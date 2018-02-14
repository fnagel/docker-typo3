## Install composer file
FROM composer:1.6 AS composer
COPY ./composer.json /app
COPY ./composer.lock /app
RUN composer install --no-interaction --no-dev --no-progress --optimize-autoloader

## Install webserver
FROM typo3.webserver

# Copy composer dependencies
COPY --from=composer /app/web ./web
COPY --from=composer /app/vendor ./vendor

# Copy project files
COPY ./web/* /web
COPY ./fileadmin /fileadmin

# @todo Is this a good approach?
RUN chown -R www-data:www-data ./web

# Prepare TYPO3
RUN vendor/bin/typo3cms install:fixfolderstructure
