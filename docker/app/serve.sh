#!/usr/bin/env bash
set -em


ROOT_DIR="/geoblacklight"

source ~/.rvm/scripts/rvm

if [[ ! -f "${ROOT_DIR}/.docker_init_flag" ]]; then

    touch "${ROOT_DIR}/.docker_init_flag"

    if [[ ! -d "${ROOT_DIR}/app/.bundle" ]]; then
        mkdir app/.bundle && chmod 755 app/.bundle
    fi

    cd "${ROOT_DIR}/app"
    bundle config build.nokogiri --use-system-libraries
    bundle check || bundle install

    rake geoblacklight:server["-p 3000 -b 0.0.0.0"]

else
    # restart both servers since we have apparently done this before
    # GOB server is too dumb to start with the same command as above

    cd "${ROOT_DIR}/docker/solr"
    bin/solr start -h "0.0.0.0" -p 8983 -V

    cd "${ROOT_DIR}/app"
    rm -rf tmp
    rails s -b "0.0.0.0" -p 3000

fi