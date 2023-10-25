#!/usr/bin/env bash
set -e


source ~/.rvm/scripts/rvm

cd ${APP_DIR}

rvm install ${RUBY_VERSION}
gem update --system
gem install rails -v ${RAILS_VERSION}

echo -e "\nStarting the GOB application.\n"

bin/setup