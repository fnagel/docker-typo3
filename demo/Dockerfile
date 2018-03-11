ARG php_tag

## Install composer file
FROM composer:1 AS composer
COPY ./composer.json /app
RUN composer install --no-interaction --no-dev --no-progress --optimize-autoloader --ignore-platform-reqs

## Install webserver
FROM typo3.webserver:$php_tag

COPY --from=composer /app/web ./web
COPY --from=composer /app/vendor ./vendor

# Prepare TYPO3
RUN vendor/bin/typo3cms install:fixfolderstructure
RUN touch web/FIRST_INSTALL
RUN touch web/typo3conf/ENABLE_INSTALL_TOOL
RUN cp vendor/typo3/cms/_.htaccess web/.htaccess
COPY ./install.sh /var/www/html

RUN chown -R www-data:www-data ./web
