#!/usr/bin/env bash
set -e


# Change the ownership of SSH keys to allow internal deployments
chown -R gob:gob /home/gob/.ssh

# RVM is installed at container build time, but RoR is installed here.
# We don't use the templated install, so we can use the (faster) setup script.

source ~/.rvm/scripts/rvm

cd ${APP_DIR}

rvm install ${RUBY_VERSION}
gem update --system
gem install rails -v ${RAILS_VERSION}

echo -e "\nStarting the GOB application.\n"

bin/setup