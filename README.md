Symfony Demo Application
========================

The "Symfony Demo Application" is a reference application created to show how
to develop applications following the [Symfony Best Practices][1].

This version is adapted to the new Artifakt Console.
It also has a docker-compose.yaml format to enable local development.

Features
------------

This flavor of Symfony Demo adds a few features:
- MySQL as a database, instead of SQLite
- Specific `build.sh` custom tooling (yarn)
- Specific `entrypoint.sh` for Schema initialization
- Forced order of containers, the app will wait for db to be ready
- Custom `.artifakt` folder for Artifakt console

Requirements
------------

  * Docker 17.05 or higher
  * Docker Compose 1.x

Configuration
------------

To run a local Symfony Demo app, define a new config file `.env.local`.
It should have the following values:

```bash
MYSQL_ROOT_PASSWORD=S3cr3t!
ARTIFAKT_MYSQL_DATABASE_NAME=symfonydemo
ARTIFAKT_MYSQL_USER=symfonydemo
ARTIFAKT_MYSQL_PASSWORD=symfonydemo
ARTIFAKT_MYSQL_HOST=db
```

Alternatively, to enable Artifakt integration, define the same variables from the console.

Usage
-----

There's no need to configure anything to run the application. If you have
docker-compose, run this command:

```bash
$ cd artifakt-symfony-demo/
$ docker-compose build
$ docker-compose up --env-file .env.local -d
```

To run it from the Artifakt Console, just point the environment to this repository.

Then access the application in your browser at the given URL (<https://localhost:8000> by default).

[1]: https://symfony.com/doc/current/best_practices.html
