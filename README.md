# TYPO3 Docker


## What is this?

Yet another TYPO3 CMS Docker package based upon PHP and Apache. It's simple, understandable and yet fully functional.

_Suitable for development and production._


**What is included?**

* A minimal production image
* A development image with
    * Xdebug
    * Mailhog
    * Adminer
    * Node.js (with npm)
* A TYPO3 CMS "Introduction package" image
* A simple way to create an image for your custom project


## Usage

* Adjust `.env` file
* Create base image
* Create dev image (optional)
* Create demo or project container


### Base images

Base images for running TYPO3 CMS. Needed as base images for demo and project container.


#### Production

Build and run a minimal production / base image:

```
docker-compose build
```

This will create the `fnagel/docker-typo3-webserver` image.


#### Development

Build a container with development tools (composer, xdebug, etc.):

```
docker-compose -f docker-compose.yml -f docker-compose.dev.yml build
```

This will create the `fnagel/docker-typo3-webserver-dev` image.


### Demo (Introduction Package)

**Create images**

Build and run a container with installed and fully functional introduction package:

```
docker-compose -f docker-compose.yml -f docker-compose.demo.yml up --build -d
```

or with development tools:

```
docker-compose -f docker-compose.yml -f docker-compose.dev.yml -f docker-compose.demo.yml up --build -d
```

**Setup demo**

Use the following command to install the introduction package using TYPO3 console:

```
docker-compose exec webserver bash ./install.sh
```

Default domain is [http://demo.typo3.local]()


### Use with existing projects

**Project requirements**

* A GIT repository for your project
* A `composer` based TYPO3 project
* Using `/web` folder for all public files (using the `web-dir` directive, see composer.json in `/demo` folder)

**How to integrate with your existing TYPO3 CMS project**

* Clone this repository to `.docker` sub folder of your project
* Copy the `.env` file to your project root folder and change variables as needed
* Run the following commands:

```
docker-compose -f .docker/docker-compose.yml -f .docker/docker-compose.project.yml up --build -d
```

**This will:**

* Create production image with web server and database
* Copy your local files into the container
* Install your composer dependencies

**Copy files:**

Use the following command to import more static files to the volume:

```
docker cp ./web/folder webserver:/var/www/html/
```

**Import database:**

Use the following command to import your database:

```
docker-compose run db bash -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h db $MYSQL_DATABASE' < .docker/project/data/db.sql
```


### Database credentials

Default values for the database connection see `MYSQL_*` variables in the `.env` file.


### Change PHP version

Change the `DOCKER_PHP_TAG` variable in the `.env` file.


## Hints

* "Docker Toolbox for Windows"
    * You might need to run `@FOR /f "tokens=*" %i IN ('docker-machine env') DO @%i` on Windows
    * Increase disk size:
        `docker-machine rm default` and
        `docker-machine create -d virtualbox --virtualbox-disk-size "100000" default`
        This creates a 100 GB disk but erases all exiting data!

* "Docker for Windows WSL"
    * Move data file: https://stackoverflow.com/a/63752264/991681

* Clean up on down (unused images and volumes): `docker-compose down --rmi local -v`

* Clean up radical (be VERY careful): `docker image prune -a`

* Possible errors:
    * `ERROR: for xyz Cannot start service xyz: network 12345 not found`
        * Use `docker-compose up --force-recreate`

    * `ERROR: could not find an available, non-overlapping IPv4 address pool among the defaults to assign to the network`
        * List your networks `docker network ls`
        * Remove unused networks `docker network rm SOME_NETWORK_ID`

    * `AH00526: Syntax error on line 170 of /etc/apache2/apache2.conf: Multiple <Directory> arguments not (yet) supported.`
        * Remove `/` from beginning of `APACHE_DOCUMENT_ROOT` env variable value

## ToDo

* Document env file issue and workaround

* Add simple docker.sh file?

* `APACHE_DOCUMENT_ROOT` with leading slash will add local Windows path, so we remove the `/` at the beginning
    * This is the case when using sh files with docker commands in it, e.g. `bash docker.sh up`
    * Using bash will end up in docker auth error, unsure why
    * Using sh instead of bash as command works but produces the above described error

* Document ftp usage

* Sync folder (shared volumes) see `sync` and `remove-symlinks` branch -> obsolete due to bad performance


## Credits

Thanks to @jzaefferer (@sloppyio) for the help getting started with docker!

**Resources**

* https://github.com/sloppyio/quickstarters
* https://github.com/docker-library/wordpress
* https://github.com/t3easy/docker-typo3
* https://writing.pupius.co.uk/apache-and-php-on-docker-44faef716150
