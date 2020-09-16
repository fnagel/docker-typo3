ARG php_tag
ARG docker_image

FROM composer:1 AS composer

# Install webserver
FROM ${docker_image}:${php_tag}

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Use the default development configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Install Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN { \
		echo 'xdebug.max_nesting_level = 400'; \
		echo 'xdebug.remote_enable = 1'; \
		echo 'xdebug.remote_autostart = off'; \
	} > /usr/local/etc/php/conf.d/xdebug.ini

# Add PHP.ini debug config
RUN { \
		echo 'display_errors = on'; \
		echo 'log_errors = on'; \
		echo 'error_reporting = E_ALL'; \
	} > /usr/local/etc/php/conf.d/development.ini

# Install NodeJS
RUN apt-get update
RUN apt-get install -y gnupg
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# Install Ruby
RUN apt-get install -y ruby-full rubygems-integration

# Install SASS
# @todo v3.5 does not work, not sure why
RUN gem install sass -v 3.4
