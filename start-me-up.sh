#!/bin/bash


export USER_GID=$(id -g)
export USER_UID=$(id -u)

APP_RUNNING="$(docker-compose ps --status=running ual_gob_app | grep 'gob-app')"

if [[ $1 == "pause" && "${APP_RUNNING}" ]]; then

    echo -e "Statefully stopping the Docker orchestration...\n"
    docker-compose stop

elif [[ "${APP_RUNNING}" ]]; then

    echo -e "Recreating the Docker containers (network data and volumes will persist)...\n"
    docker-compose restart
    docker exec -it gob-app bash -c -l './serve.sh'

else

    # git clone https://github.com/geobtaa/geoportal-solr-config.git gob_config
    docker-compose up -d
    docker exec -it gob-app bash -c -l './install_app.sh'
    docker exec -it gob-app bash -c -l './serve.sh'

fi
