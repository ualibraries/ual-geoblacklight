#!/usr/bin/env bash
set -e


source ~/.rvm/scripts/rvm

cd ${PROJECT_DIR}

if [[ ! -d "${APP_DIR}" ]]; then

    rvm install ${RUBY_VER}
    gem update --system
    gem install bundler rails

    rails new app -m https://raw.githubusercontent.com/geoblacklight/geoblacklight/main/template.rb

    # install our current customizations for Docker image
    rm "${APP_DIR}/.solr_wrapper.yml" \
        && rm "${APP_DIR}/config/blacklight.yml" \
        && cp "${USER_HOME}/docker/.solr_wrapper.yml" "${APP_DIR}/.solr_wrapper.yml" \
        && cp "${USER_HOME}/docker/blacklight.yml" "${APP_DIR}/config/blacklight.yml"

else
    
    echo -e "\nPass. App has already been installed at ${APP_DIR}.\n"

fi