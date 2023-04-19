#!/bin/bash
set -x


export USER_GID=$(id -g)
export USER_UID=$(id -u)

APP_RUNNING="$(docker-compose ps --status=running ual_gob_app | grep 'gob-test')"

if [[ $1 == "pause" && "${APP_RUNNING}" ]]; then

    docker-compose stop

elif [[ $1 == "secure" && "${APP_RUNNING}" ]]; then

    docker exec -it gob-test bash -c -l 'cd solr && ./cloud-secure.sh'
    docker-compose restart
    docker exec -it gob-test bash -c -l 'cd app && ./serve.sh'

elif [[ "${APP_RUNNING}" ]]; then

    docker-compose restart
    docker exec -it gob-test bash -c -l 'cd app && ./serve.sh'

else

    docker-compose up -d

fi

# if we haven/t already installed the app, let's go ahead with that.
if [[ ! -d ./ual_gob/app ]]; then

    docker exec -it gob-test bash -c -l 'cd app && ./install_app.sh'
    docker exec -it gob-test bash -c -l 'cd app && ./serve.sh'

fi
