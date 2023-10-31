#!/bin/bash


export USER_GID=$(id -g)
export USER_UID=$(id -u)

APP_RUNNING="$(docker-compose ps --status=running ual_gob_app | grep 'gob-app')"

if [[ $1 == "pause" && "${APP_RUNNING}" ]]; then

    echo -e "Statefully stopping the Docker orchestration...\n"
    docker compose stop

elif [[ $1 == "test" && !"${APP_RUNNING}" ]]; then

    echo -e "Starting the Docker orchestration without app install and server startup...\n"
    docker compose up -d

elif [[ "${APP_RUNNING}" ]]; then

    echo -e "Recreating the Docker containers (network data and volumes will persist)...\n"
    docker compose restart
    docker exec -it gob-app bash -c -l './app_init.sh'

else

    docker compose up -d
    docker exec -it gob-app bash -c -l './app_init.sh'

fi
