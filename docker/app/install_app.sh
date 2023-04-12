#!/usr/bin/env bash
set -em


source ~/.rvm/scripts/rvm
rvm install ${RUBY_VER}
gem update --system
gem install bundler rails

cd ${PROJECT_DIR}
rails new app -m https://raw.githubusercontent.com/geoblacklight/geoblacklight/main/template.rb

# install our current customizations for Docker image
rm "${APP_DIR}/.solr_wrapper.yml" \
    && rm "${APP_DIR}/config/blacklight.yml" \
    && cp "${USER_HOME}/docker/app/.solr_wrapper.yml" "${APP_DIR}/.solr_wrapper.yml" \
    && cp "${USER_HOME}/docker/app/blacklight.yml" "${APP_DIR}/config/blacklight.yml"

# install the command scripts to the project root
cp "${USER_HOME}/docker/app/rake_command.sh" "${PROJECT_DIR}/rake_command.sh" \
    && cp "${USER_HOME}/docker/solr/solr_command.sh" "${PROJECT_DIR}/solr_command.sh"

# startup scripts
cp "${USER_HOME}/docker/app/serve.sh" "${PROJECT_DIR}/serve.sh" \
    && cp "${USER_HOME}/docker/solr/secure_zk.sh" "${PROJECT_DIR}/secure_zk.sh"