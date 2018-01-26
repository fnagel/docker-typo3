# TYPO3 Docker


## Requirements

### General requirements

* Working `docker-compose` command

### Project requirements

* `composer` based TYPO3 project
* Using `/web` folder for all public files (speak: using the `web-dir` directive, see default composer.json)


## Usage

_tbd_


### TYPO3 Installing tool

Default values for the database connection are:

User: `dbname`
Pass: `dbpass`
Host: `db`
Port: `3306`

_Some of those can be changed in the `.env` file._


## Issues

* Install tool -> DB compare shows issues: https://forge.typo3.org/issues/82023
 

## Credits

Thanks to @jzaefferer (@sloppyio) for the help getting started with docker!

**Resources**

* https://github.com/sloppyio/quickstarters
* https://github.com/docker-library/wordpress/
* https://github.com/t3easy/docker-typo3
* https://writing.pupius.co.uk/apache-and-php-on-docker-44faef716150