# TYPO3 Docker

## What is this?

Yet another TYPO3 CMS docker package. It's simple, understandable and yet fully functional.

_Suitable for development and production._


**What is included?**

* A minimal production image
* A development image with
    * Xdebug
    * Mailhog
    * Adminer
    * Ruby
    * SASS
    * Node.js (npm)


## Requirements

### General requirements

* Working `docker-compose` command

### Project requirements

* `composer` based TYPO3 project
* Using `/web` folder for all public files (speak: using the `web-dir` directive, see default composer.json)


## Usage

**Prod**

`docker-compose -f docker-compose.yml up -d`

**Dev**

`docker-compose -f docker-compose.yml build`
`docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d`

_Note:_ We need to build the non dev image first so the dev image can extend (`FROM`) it. 


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