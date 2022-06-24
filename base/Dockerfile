ARG php_tag
ARG docker_image

# Install webserver
FROM ${docker_image}:${php_tag}-apache

# Install PHP extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync

RUN install-php-extensions bcmath zip exif gd mysqli intl soap opcache

# Install unzip
RUN apt-get update \
    && apt-get install -y unzip

# Install imagemagick
RUN apt-get update \
    && apt install -y --no-install-recommends libmagickwand-dev imagemagick
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Install localization
RUN apt-get update \
    && apt-get install -y locales locales-all

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Set recommended opcode PHP.ini settings, see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Set recommended TYPO3 PHP.ini settings
RUN { \
		echo 'always_populate_raw_post_data = -1'; \
		echo 'max_execution_time = 240'; \
		echo 'max_input_vars = 1500'; \
		echo 'upload_max_filesize = 32M'; \
		echo 'post_max_size = 32M'; \
	} > /usr/local/etc/php/conf.d/typo3.ini

# Set some more PHP settings
RUN { \
		echo 'date.timezone = ${DOCKER_TIMEZONE}'; \
	} > /usr/local/etc/php/conf.d/custom.ini

# Configure Apache as needed
RUN a2enmod rewrite expires alias headers

# Apache document root
RUN sed -ri -e 's!/var/www/html!/${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!/${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Make domain available in apache
RUN sed -ri -e 's!#ServerName www.example.com!ServerName ${APACHE_DOMAIN}!g' /etc/apache2/sites-available/*.conf

ARG apache_document_root
RUN mkdir -p "/$apache_document_root"

RUN chown -R www-data:www-data /var/www/

RUN php --version

WORKDIR /var/www/html
