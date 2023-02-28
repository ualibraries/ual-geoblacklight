#!/usr/bin/env bash
set -e

# primarily using this script to begin install of the Ruby app, 
# because the Docker container needs a new shell.

source ~/.profile

rvm install ${RUBY_VER}
gem install bundler rails

DISABLE_SPRING=1

cd /geoblacklight
rails new ual_geoblacklight -m https://raw.githubusercontent.com/geoblacklight/geoblacklight/main/template.rb
cd ual_geoblacklight
rake geoblacklight:server["-p 3000 -b 0.0.0.0"]
