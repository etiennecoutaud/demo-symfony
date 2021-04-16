#!/bin/bash
set -e

echo ">>>>>>>>>>>>>> START CUSTOM ENTRYPOINT SCRIPT <<<<<<<<<<<<<<<<< "

# debug env vars.
env

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

#allow www-data user to write in artifakt logs folder
if [ -d "/var/log/artifakt" ] ; then
  echo "updating artifakt logs folder owner"
  chown www-data:www-data -R /var/log/artifakt
fi

echo ">>>>>>>>>>>>>> END CUSTOM ENTRYPOINT SCRIPT <<<<<<<<<<<<<<<<< "
