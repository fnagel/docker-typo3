ARG php_tag

FROM composer:1 AS composer

# Install webserver
FROM typo3.webserver:$php_tag

# Install and prepare composer
# Include composer as coyping files from composer image will break the symlink structure due to composer scripts
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Copy local project files
COPY ./config ./config
COPY ./web/typo3conf/*.* ./web/typo3conf/
COPY ./web/typo3conf/ext ./web/typo3conf/ext
COPY ./web/fileadmin ./web/fileadmin
COPY ./web/uploads ./web/uploads
COPY ./web/*.* ./web/

RUN chown -R www-data:www-data /var/www/project
RUN chown -R www-data:www-data /var/www/html/var
RUN chown -R www-data:www-data /var/www/html/web

# Install composer
COPY ./composer.json .
COPY ./composer.lock .

USER www-data
RUN COMPOSER_CACHE_DIR=/dev/null composer install --no-interaction --no-dev --no-progress --optimize-autoloader --prefer-dist
USER root

