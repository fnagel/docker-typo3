#!/bin/bash

touch web/FIRST_INSTALL
touch web/typo3conf/ENABLE_INSTALL_TOOL

php vendor/bin/typo3cms install:setup --force --no-interaction --skip-integrity-check \
    --database-name="$MYSQL_DATABASE" --use-existing-database \
    --database-host-name="db" --database-port="3306" \
    --database-user-name="$MYSQL_USER" --database-user-password="$MYSQL_PASSWORD" \
    --admin-user-name="$TYPO3_USER" --admin-password="$TYPO3_PASSWORD" \
    --site-name="TYPO3 Introduction Package" \
    --site-setup-type="site" \
    --web-server-config="apache"

# Remove duplicate site configuration
rm -rf /var/www/html/config/sites/main

php vendor/bin/typo3cms cache:flush

chown -R www-data:www-data /var/www/html
