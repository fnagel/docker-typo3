#!/bin/bash

php vendor/bin/typo3cms install:setup --force --no-interaction --skip-integrity-check \
    --database-name="$MYSQL_DATABASE"  --database-host-name="db" --database-port="3306" \
    --database-user-name="$MYSQL_USER" --database-user-password="$MYSQL_PASSWORD" --use-existing-database \
    --admin-user-name="$TYPO3_USER" --admin-password="$TYPO3_PASSWORD" \
    --site-name="TYPO3 Introduction Package" --site-setup-type="no"

# Needed because even if this script is run as www-data the files / folders created
# in fileadmin have root permissions
# @todo Fix this
chown -R www-data:www-data /var/www/project/fileadmin

chown www-data:www-data /var/www/html/web/typo3conf/LocalConfiguration.php
