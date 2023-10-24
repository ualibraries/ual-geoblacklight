#!/usr/bin/env bash


source ~/.rvm/scripts/rvm

if [[ ! -f "${PROJECT_DIR}/.docker_init_flag" ]]; then

    if [[ ! -d "${APP_DIR}/.bundle" ]]; then
        mkdir "${APP_DIR}/.bundle" && chmod 755 "${APP_DIR}/.bundle"
    fi

    cd "${APP_DIR}"
    bundle config build.nokogiri --use-system-libraries
    bundle check || bundle install

    touch "${PROJECT_DIR}/.docker_init_flag"

else

    cd "${APP_DIR}"
    echo -e "\nRe-starting GOB Rails application... \n"
    rm -rf tmp

fi

bundle exec rails s \
    -b "0.0.0.0" \
    -p 3000 \
    -d