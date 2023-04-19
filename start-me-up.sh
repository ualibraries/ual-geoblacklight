#!/bin/bash
set -x


export USER_GID=$(id -g)
export USER_UID=$(id -u)

APP_RUNNING="$(docker-compose ps --status=running ual_gob_app | grep 'gob-test')"

if [[ $1 == "pause" && "${APP_RUNNING}" ]]; then
    docker-compose stop
elif [[ "${APP_RUNNING}" ]]; then
    docker-compose restart
else
    docker-compose up -d
fi

if [[ ! -d ./ual_gob/app ]]; then
    docker exec -it gob-test bash -c -l 'cd app && ./install_app.sh'
fi
