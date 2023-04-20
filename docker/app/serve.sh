#!/usr/bin/env bash
set -em


export SOLR_DIR="${PROJECT_DIR}/solr"

source ~/.rvm/scripts/rvm

if [[ ! -f "${PROJECT_DIR}/.docker_init_flag" ]]; then

    touch "${PROJECT_DIR}/.docker_init_flag"

    if [[ ! -d "${APP_DIR}/.bundle" ]]; then
        mkdir "${APP_DIR}/.bundle" && chmod 755 "${APP_DIR}/.bundle"
    fi

    cd "${APP_DIR}"
    bundle config build.nokogiri --use-system-libraries
    bundle check || bundle install

    # final application installation (including local solr) and app/solr startup.
    rake geoblacklight:server['-p 3000 -b 0.0.0.0']

else
    # container restart requires a restart of both app and solr

    cd "${SOLR_DIR}"
    bin/solr start

    cd "${APP_DIR}"
    rm -rf tmp
    rails s -b "0.0.0.0" -p 3000

fi