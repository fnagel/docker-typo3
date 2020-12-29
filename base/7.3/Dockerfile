ARG php_tag
ARG docker_image

# Install webserver
FROM ${docker_image}:${php_tag}-apache

# Install the PHP extensions we need
RUN set -ex; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
        libxml2-dev \
        libfreetype6-dev \
        libmcrypt-dev \
        libjpeg-dev \
        libpng-dev \
    ; \
	\
# Configure extensions
    docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr; \
	docker-php-ext-install -j "$(nproc)" \
		bcmath \
		exif \
		gd \
		mysqli \
		intl \
		soap \
		opcache \
    ; \
	\
# Reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# Install zip / unzip
RUN apt-get update; \
    apt-get install -y \
        libzip-dev \
        zip \
  && docker-php-ext-configure zip --with-libzip \
  && docker-php-ext-install zip

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

# Configure Apache as needed
RUN a2enmod rewrite expires

# Apache document root
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Make domain available in apache
RUN sed -ri -e 's!#ServerName www.example.com!ServerName ${APACHE_DOMAIN}!g' /etc/apache2/sites-available/*.conf

ARG apache_document_root
RUN mkdir -p $apache_document_root

RUN chown -R www-data:www-data /var/www/

RUN php --version

WORKDIR /var/www/html
