#!/bin/bash
set -e

echo ">>>>>>>>>>>>>> START CUSTOM ENTRYPOINT SCRIPT <<<<<<<<<<<<<<<<< "

# debug env vars.
env

APP_ENV=dev composer --no-ansi --no-interaction install --no-cache --no-progress  --no-autoloader --no-scripts

# Temp define APP_LOG_DIR variable while waiting for console env variables to be working
export APP_LOG_DIR=/var/log/artifakt

#allow www-data user to write in artifakt logs folder
if [[ -n ${APP_LOG_DIR} && -d ${APP_LOG_DIR} ]]; then
  echo "updating ${APP_LOG_DIR} folder permissions"
  chown www-data:www-data -R "${APP_LOG_DIR}"
fi

# wait for database to be ready
export ARTIFAKT_MYSQL_HOST=mysql
/.artifakt/wait-for-it.sh $ARTIFAKT_MYSQL_HOST:3306

# as per symfony good practices
php bin/console cache:clear --env=prod && composer dump-autoload

# install schema on first launch
./bin/console doctrine:schema:update || ./bin/console doctrine:schema:update --force

# force fixtures (temporary force APP_ENV=dev even if it is set to "prod")
# https://miary.dev/2020/12/20/symfony-doctrinefixturesbundle-installe-doctrinefixturesload-non-trouve/
APP_ENV=dev php bin/console doctrine:fixtures:load --no-ansi --no-interaction

echo ">>>>>>>>>>>>>> END CUSTOM ENTRYPOINT SCRIPT <<<<<<<<<<<<<<<<< "
