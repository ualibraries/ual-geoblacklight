#!/bin/bash


source .env

APP_RUNNING="$(docker compose ps --status=running ual_gob_app | grep 'gob-app')"

if [[ $1 == "pause" && "${APP_RUNNING}" ]]; then

    echo -e "Statefully stopping the Docker orchestration...\n"
    docker compose stop

elif [[ $1 == "test" && !"${APP_RUNNING}" ]]; then

    echo -e "Starting the Docker orchestration without app install and server startup...\n"
    docker network create -d bridge ual-gob
    docker compose up -d

elif [[ $1 == "geoserver" && !"${APP_RUNNING}" ]]; then

    echo -e "Starting the Docker orchestration with geoserver container and postgis startup...\n"
    docker network create -d bridge ual-gob
    docker compose -f ./docker-compose.yml -f ./docker/geoserver/docker-compose.yml -f ./docker/postgis/docker-compose.yml up -d
    docker exec -it gob-app bash -c -l './app_init.sh'

elif [[ "${APP_RUNNING}" ]]; then

    echo -e "Recreating the Docker containers (network data and volumes will persist)...\n"
    docker compose restart
    docker exec -it gob-app bash -c -l './app_init.sh'

else

    "Starting the Docker orchestration with app install and server startup...\n"
    docker network create -d bridge ual-gob
    docker compose up -d
    docker exec -it gob-app bash -c -l './app_init.sh'

fi
