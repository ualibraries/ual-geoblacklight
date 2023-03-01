#!/usr/bin/env bash
set -e

# primarily using this script to begin install of the Ruby app, 
# because the Docker container needs a new shell.

source ~/.profile

rvm install ${RUBY_VER}
gem install bundler rails

DISABLE_SPRING=1
APP_DIR="/geoblacklight/ual_geoblacklight"

if [[ ! -d "${APP_DIR}" ]]; then
    # create a new instance
    cd /geoblacklight
    rails new ual_geoblacklight -m https://raw.githubusercontent.com/geoblacklight/geoblacklight/main/template.rb
    cd ual_geoblacklight
    echo 'gem "devise"' >> Gemfile
    rake geoblacklight:server["-p 3000 -b 0.0.0.0"]
else
    # restart both servers since we have apparently done this before
    cd "/tmp/solr-${SOLR_VER}"
    bin/solr start
    cd $APP_DIR
    rails s -b 0.0.0.0
fi