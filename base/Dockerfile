ARG php_tag

# Extend from PHP image
FROM php:$php_tag

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
        libmagickwand-dev \
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
    pecl install imagick; \
    docker-php-ext-enable imagick; \
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

RUN php --version

# Create TYPO3 folder structure
RUN mkdir /var/www/project
RUN mkdir /var/www/project/var
RUN mkdir /var/www/project/config
RUN mkdir /var/www/project/fileadmin
RUN mkdir /var/www/project/typo3conf
RUN mkdir /var/www/project/typo3conf/l10n
RUN mkdir /var/www/project/typo3temp
RUN mkdir /var/www/project/uploads

RUN mkdir /var/www/html/web
RUN mkdir /var/www/html/web/typo3conf

RUN ln -s /var/www/project/var /var/www/html/var
RUN ln -s /var/www/project/config /var/www/html/config
RUN ln -s /var/www/project/fileadmin /var/www/html/web/fileadmin
RUN ln -s /var/www/project/typo3conf/l10n /var/www/html/web/typo3conf/l10n
RUN ln -s /var/www/project/typo3temp /var/www/html/web/typo3temp
RUN ln -s /var/www/project/uploads /var/www/html/web/uploads

WORKDIR /var/www/html
