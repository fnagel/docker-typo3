# TYPO3 Docker


## What is this?

Yet another TYPO3 CMS Docker package based upon PHP and Apache. It's simple, understandable and yet fully functional.

_Suitable for development and production._


**What is included?**

* A minimal production image
* A TYPO3 CMS "Introduction package" image
* A development image with
    * Xdebug
    * Mailhog
    * Adminer
    * Node.js (with npm)
    * Ruby
    * SASS
* A simple way to create an image for your custom project


## Usage

_Note:_ We need to build the base image first so the dev and demo image can extend (`FROM`) it.


### Production

Build and run a minimal production / base image:

```
docker-compose build
```
This will create the `typo3.webserver` image.


### Development

Build and run an image with development tools (composer, xdebug, etc.):

```
docker-compose build
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

Default domain is [http://dev.typo3.local]()


### Demo (Introduction Package)

Build and run an image with installed and fully functional introduction package:

```
docker-compose build
docker-compose -f docker-compose.yml -f docker-compose.demo.yml up --build -d
```

Use the following command to install the introduction package using TYPO3 console:

```
docker-compose exec webserver /bin/bash ./install.sh
```

Default domain is [http://demo.typo3.local]()


### Use with existing projects

**Project requirements**

* A GIT repository for your project
* A `composer` based TYPO3 project
* Using `/web` folder for all public files (using the `web-dir` directive, see composer.json in `/demo` folder)
* Make sure your project composer file contains `helhum/typo3-console` as a dependency

**How to integrate with your existing TYPO3 CMS project**

* Clone this repository to `.docker` sub folder of your project
* Copy the `.env` file to your project root folder and change variables as needed
* Run the following commands:

```
cd .docker
docker-compose build
cd ..
docker-compose -f .docker/docker-compose.yml -f .docker/docker-compose.project.yml up --build -d
```

**This will:**

* Create production image with web server and database
* Install your composer dependencies
* Add your local `web` files

**Copy files:**

Use the following command to import more static files (`web/fileadmin` and `web/uploads` are already added!) to the volume:

```
docker cp ./web/folder webserver:/var/www/project/
```

**Import database:**

Use the following command to import your database:

```
docker-compose run db bash -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h db $MYSQL_DATABASE' < .docker/project/data/db.sql
```


### Database credentials

Default values for the database connection are:

User: `dbname`
Pass: `dbpass`
Host: `db`
Port: `3306`

_Some of those can be changed in the `.env` file._


### Change PHP version

Change the PHP version by using:

```
docker-compose -f docker-compose.yml -f docker-compose.php.7.0.yml build
docker-compose -f docker-compose.yml -f docker-compose.php.7.0.yml -f docker-compose.demo.yml up --build -d
```


## Issues

* Update SASS version (see `/dev/Dockerfile`)


## Ideas

* Move all PHP version docker files to own folder


## Hints

* You might need to run `@FOR /f "tokens=*" %i IN ('docker-machine env') DO @%i` on Windows
* Increase disk size for "Docker Toolbox for Windows" installations: 
    `docker-machine rm default` and 
    `docker-machine create -d virtualbox --virtualbox-disk-size "100000" default`
    This creates a 100 GB disk but erases all exiting data!


## ToDo

* Demo file works
* Project does not work
    * Tried with IP, might be a breaker -> did not work, removed
    * Issues with missing typo3 site config files -> fixed
    * Testing around with project name env var -> reverted
    * Issues with imagemagick not available -> rebuild everything
* Dev image not tested for a longer time

* Create copy of project (and rename to copy) and add volume sync instead of COPY command
* Add arg tag for image, in order to be able to use a dev image for projects
* Add SSL

## Credits

Thanks to @jzaefferer (@sloppyio) for the help getting started with docker!

**Resources**

* https://github.com/sloppyio/quickstarters
* https://github.com/docker-library/wordpress
* https://github.com/t3easy/docker-typo3
* https://writing.pupius.co.uk/apache-and-php-on-docker-44faef716150
