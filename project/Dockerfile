ARG php_tag
ARG composer_tag
ARG docker_image

FROM composer:${composer_tag} AS composer

# Build actual webserver
FROM ${docker_image}:${php_tag}

# Install and prepare composer
# Include composer as coyping files from composer image will break the symlink structure due to composer scripts
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Copy local project files
COPY . ./

RUN chown -R www-data:www-data /var/www/html
