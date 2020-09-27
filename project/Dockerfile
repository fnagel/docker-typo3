ARG php_tag
ARG docker_image

FROM composer:1 AS composer

# Copy local project files and remove symlinked folders
FROM alpine AS source
RUN mkdir /var/www
COPY . /var/www
RUN rm -rf /var/www/web/typo3conf/ext
RUN rm -rf /var/www/web/typo3conf/l10n
RUN rm -rf /var/www/web/fileadmin
RUN rm -rf /var/www/web/uploads
RUN rm -rf /var/www/var
# Remove dependencies
RUN rm -rf /var/www/web/typo3
RUN rm -rf /var/www/vendor
RUN rm -rf /var/www/node_modules

# Build actual webserver
FROM ${docker_image}:${php_tag}

# Install and prepare composer
# Include composer as coyping files from composer image will break the symlink structure due to composer scripts
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Copy local project files
COPY --from=source /var/www ./
COPY ./web/typo3conf/ext ./web/typo3conf/ext
COPY ./web/fileadmin ./web/fileadmin
COPY ./web/uploads ./web/uploads

RUN chown -R www-data:www-data /var/www/project
RUN chown -R www-data:www-data /var/www/html/config
RUN chown -R www-data:www-data /var/www/html/var
RUN chown -R www-data:www-data /var/www/html/web

# Install composer dependencies
USER www-data
RUN COMPOSER_CACHE_DIR=/dev/null composer install --no-interaction --no-dev --no-progress --optimize-autoloader --prefer-dist
USER root
