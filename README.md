# TYPO3 Docker

## What is this?

Yet another TYPO3 CMS docker package. It's simple, understandable and yet fully functional.

_Suitable for development and production._


**What is included?**

* A minimal production image
* A TYPO3 CMS "Introduction package" image
* A development image with
    * Xdebug
    * Mailhog
    * Adminer
    * Ruby
    * SASS
    * Node.js (npm)
* A simple way to create an image for your custom project

## Usage

_Note:_ We need to build the base image first so the dev and demo image can extend (`FROM`) it. 


**Prod**

Build and run a minimal production / base image:

```
docker-compose -f docker-compose.yml up -d
```

**Dev**

Build and run an image with development tools (composer, xdebug, etc.):

```
docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

Default domain is [http://dev.typo3.vm]()

**Demo**

Build and run an image with installed and fully functional introduction package:

```
docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml -f docker-compose.demo.yml up -d
```

Use the following command to install the introduction package using TYPO3 console:

```
docker-compose exec /bin/bash ./install.sh
```

Default domain is [http://demo.typo3.vm]()


### Use with existing projects

**Project requirements**

* A GIT repository for your project
* A `composer` based TYPO3 project
* Using `/web` folder for all public files (speak: using the `web-dir` directive, see composer.json in `/demo` folder)
* Make sure your project composer file contains `helhum/typo3-console` as a dependency

**How to integrate with your existing TYPO3 CMS project**

* Clone this repository to `.docker` sub folder of your project
* Copy the `.env` file to your project root folder and change variables as needed
* Run the following commands:

```
cd .docker
docker-compose -f docker-compose.yml build
cd ..
docker-compose -f .docker/docker-compose.yml -f .docker/docker-compose.project.yml up -d
```

**This will:**

* create production image with web server and database
* install your composer dependencies
* add your `web` and `fileadmin` files


### Database credentials

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
