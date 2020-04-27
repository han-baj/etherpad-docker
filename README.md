# Etherpad Lite image for docker

This is a docker image for [Etherpad Lite](http://etherpad.org/) collaborative text editor. The Dockerfile for this image has been inspired by [johbo's etherpad-lite](https://registry.hub.docker.com/u/johbo/etherpad-lite/).

[This image comes with configuration options for MariaDB (or MySQL) as the database backend. The docker-compose file we added allows users launch the etherpad and the database with a single `docker-compose up`.

## About Etherpad Lite

> *From the official website:*

Etherpad allows you to edit documents collaboratively in real-time, much like a live multi-player editor that runs in your browser. Write articles, press releases, to-do lists, etc. together with your friends, fellow students or colleagues, all working on the same document at the same time.

![alt text](http://i.imgur.com/zYrGkg3.gif "Etherpad in action on PrimaryPad")

All instances provide access to all data through a well-documented API and supports import/export to many major data exchange formats. And if the built-in feature set isn't enough for you, there's tons of plugins that allow you to customize your instance to suit your needs.

You don't need to set up a server and install Etherpad in order to use it. Just pick one of publicly available instances that friendly people from everywhere around the world have set up. Alternatively, you can set up your own instance by following our installation guide

## Quickstart

First you need a running mysql container, for example:

```bash
$ docker network create ep_network
$ docker run -d --network ep_network -e MYSQL_ROOT_PASSWORD=password --name ep_mysql mariadb:10
```

Finally you can start an instance of Etherpad Lite:

```bash
$ docker run -d \
    --network ep_network \
    -e ETHERPAD_DB_HOST=ep_mysql \
    -e ETHERPAD_DB_PASSWORD=password \
    -p 9001:9001 \
    unihalle/etherpad-lite
```

Etherpad will automatically create an `etherpad` database in the specified MySQL server if it does not already exist.
You can now access Etherpad Lite from http://localhost:9001/

## Docker compose

[Git Repo](https://github.com/uni-halle/etherpad-lite-docker) contains a docker-compose file with a pre-configured mariadb container.

Use it:

1. Install docker-compose.
2. Clone the repo and cd into etherpad-lite.
3. Rename `example.env` to `.env` and adjust the passwords.
4. Start up everything with `docker-compose up`.

## Environment variables

This image supports the following environment variables:

* `ETHERPAD_TITLE`: Title of the Etherpad Lite instance. Defaults to "Etherpad".
* `ETHERPAD_DEFAULT_PAD_TEXT`: Default text shown when opening a new pad.
* `ETHERPAD_PORT`: Port of the Etherpad Lite instance. Defaults to 9001.
* `ETHERPAD_ADMIN_PASSWORD`: If set, an admin account is enabled for Etherpad,
and the /admin/ interface is accessible via it.
* `ETHERPAD_ADMIN_USER`: If the admin password is set, this defaults to "admin".
Otherwise the user can set it to another username.

* `ETHERPAD_DB_HOST`: Hostname of the mysql databse to use. Defaults to `mysql`.
* `ETHERPAD_DB_PORT`: Port number of the mysql database to use. Defaults to
`3306`.
* `ETHERPAD_DB_USER`: By default Etherpad Lite will attempt to connect as root
to the mysql container.
* `ETHERPAD_DB_PASSWORD`: MySQL password to use, mandatory. If legacy links
are used and ETHERPAD_DB_USER is root, then `MYSQL_ENV_MYSQL_ROOT_PASSWORD` is
automatically used.
* `ETHERPAD_DB_NAME`: The mysql database to use. Defaults to *etherpad*. If the
database is not available, it will be created when the container is launched.
* `ETHERPAD_API_KEY`: API key to use. Defaults to randomly generated string.
Must be 20 characters or longer.
* `ETHERPAD_SESSION_REQUIRED`: Users must have a session to access pads. This
effectively allows only group pads to be accessed. Defaults to false.

The generated settings.json file will be available as a volume under
*/opt/etherpad-lite/var/*.

