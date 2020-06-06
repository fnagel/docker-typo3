#!/bin/bash

chown -R www-data:www-data /var/www/project

touch web/FIRST_INSTALL
touch web/typo3conf/ENABLE_INSTALL_TOOL

php vendor/bin/typo3cms install:setup --force --no-interaction --skip-integrity-check \
    --database-name="$MYSQL_DATABASE" --use-existing-database \
    --database-host-name="db" --database-port="3306" \
    --database-user-name="$MYSQL_USER" --database-user-password="$MYSQL_PASSWORD" \
    --admin-user-name="$TYPO3_USER" --admin-password="$TYPO3_PASSWORD" \
    --site-name="TYPO3 Introduction Package" \
    --site-setup-type="site" --site-base-url="http://$APACHE_DOMAIN" \
    --web-server-config="apache"

# Reuse site configuration created by typo3 console for site tree created by introduction package
sed -ri -e 's!rootPageId: 1!rootPageId: 2!g' /var/www/html/config/sites/main/config.yaml
php vendor/bin/typo3cms cache:flush
