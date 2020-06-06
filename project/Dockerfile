ARG php_tag

FROM composer:1 AS composer

# Install webserver
FROM typo3.webserver:$php_tag

RUN chown -R www-data:www-data /var/www/html/var
RUN chown -R www-data:www-data /var/www/html/web
RUN chown -R www-data:www-data /var/www/project

# Install and prepare composer
# Include composer as coyping files from composer image will break the symlink structure due to composer scripts
COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY ./composer.json .
COPY ./composer.lock .

USER www-data
RUN COMPOSER_CACHE_DIR=/dev/null composer install --no-interaction --no-dev --no-progress --optimize-autoloader --prefer-dist
USER root

# Copy local project files
COPY ./web/typo3conf/*.php ./web/typo3conf/
COPY ./web/typo3conf/ext ./web/typo3conf/ext
COPY ./web/*.* ./web/
