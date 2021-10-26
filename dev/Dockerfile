ARG php_tag
ARG composer_tag
ARG docker_image

FROM composer:${composer_tag} AS composer

# Install webserver
FROM ${docker_image}:${php_tag}

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Use the default development configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Install Xdebug
RUN install-php-extensions xdebug
RUN { \
		echo 'xdebug.max_nesting_level = 400'; \
		echo 'xdebug.mode = debug'; \
		echo 'xdebug.remote_autostart = off'; \
	} > /usr/local/etc/php/conf.d/xdebug.ini

# Add PHP.ini debug config
RUN { \
		echo 'display_errors = on'; \
		echo 'log_errors = on'; \
		echo 'error_reporting = E_ALL'; \
	} > /usr/local/etc/php/conf.d/development.ini

# Create SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj '/C=DE/ST=Berlin/L=Berlin/O=Security/OU=Development/CN=${APACHE_DOMAIN}'
# Configure Apache as needed
RUN a2enmod ssl
RUN a2ensite default-ssl

# Install GIT
RUN apt-get update \
    && apt-get install -y git

# Install vim
RUN apt-get update \
    && apt-get install -y vim

# Install rsync
RUN apt-get update \
    && apt-get install -y rsync

# Install NodeJS
RUN apt-get update \
    && curl -fsSL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs

RUN node -v && npm -v
