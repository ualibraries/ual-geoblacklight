#!/usr/bin/env bash
set -em

# primarily using this script to begin install of the Ruby app, 
# because the Docker container needs a new shell.

source ~/.profile

rvm install ${RUBY_VER}
gem install bundler rails

DISABLE_SPRING=1
APP_DIR="/geoblacklight/ual_geoblacklight"
SOLR_DIR="/tmp/solr-${SOLR_VER}"

if [[ ! -d "${APP_DIR}" ]]; then
    # create a new instance of Rails app and Solr server
    if [[ -d "${SOLR_DIR}" ]]; then
        rm -rf $SOLR_DIR
    fi
    if [[ -d "${SOLR_DIR}" ]]; then
        rm -rf $SOLR_DIR
    fi
    cd /geoblacklight
    rails new ual_geoblacklight -m https://raw.githubusercontent.com/geoblacklight/geoblacklight/main/template.rb
    cd $APP_DIR
    rm .solr_wrapper.yml && cp /home/geoblacklight/docker/app/.solr_wrapper.yml ./.solr_wrapper.yml
    rake geoblacklight:server["-p 3000 -b 0.0.0.0"] && ln -s "${SOLR_DIR}/server/solr/blacklight-core/data" "/geoblacklight/solr-data"
else
    # restart both servers since we have apparently done this before
    # GOB server is too dumb to start with the same command as above
    cd $SOLR_DIR
    bin/solr start -h "0.0.0.0" -p 8983 -V
    cd $APP_DIR
    rails s -b "0.0.0.0" -p 3000
fi