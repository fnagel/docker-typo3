#!/bin/bash

php vendor/bin/typo3cms install:setup --force --no-interaction --skip-integrity-check \
    --database-name="dbname"  --database-host-name="db" --database-port="3306" \
    --database-user-name="dbuser" --database-user-password="dbpass" --use-existing-database \
    --admin-user-name="admin" --admin-password="password" \
    --site-name="TYPO3 Introduction Package" --site-setup-type="no"

# Needed because even if this script is run as www-data the files / folders created
# in fileadmin have root permissions
# @todo Fix this
chown -R www-data:www-data ./web/fileadmin