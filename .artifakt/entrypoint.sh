#!/bin/bash
set -e

echo ">>>>>>>>>>>>>> START CUSTOM ENTRYPOINT SCRIPT <<<<<<<<<<<<<<<<< "

# debug env vars.
env

# enable catchall folder, don't forget to set APP_LOG_DIR to /var/log/artifakt
mkdir -p /var/log/artifakt && chown -R www-data:www-data /var/log/artifakt

# set correct permissions on /data folder and create symlinks
mkdir -p /data/uploads && chown -R www-data:www-data /data
ln -s /data/uploads /var/www/html/public/uploads

APP_ENV=dev composer --no-ansi --no-interaction install --no-cache --no-progress  --no-autoloader --no-scripts

# wait for database to be ready
/.artifakt/wait-for-it.sh $ARTIFAKT_MYSQL_HOST:3306

# as per symfony good practices
php bin/console cache:clear --env=prod && composer dump-autoload

# install schema on first launch
./bin/console doctrine:schema:update || ./bin/console doctrine:schema:update --force

# force fixtures (temporary force APP_ENV=dev even if it is set to "prod")
# https://miary.dev/2020/12/20/symfony-doctrinefixturesbundle-installe-doctrinefixturesload-non-trouve/
APP_ENV=dev php bin/console doctrine:fixtures:load --no-ansi --no-interaction

echo ">>>>>>>>>>>>>> END CUSTOM ENTRYPOINT SCRIPT <<<<<<<<<<<<<<<<< "
