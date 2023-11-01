#!/usr/bin/env bash
set -e


# This script is used to run rake tasks in the application.
# It can access any Gem rake tasts available to the application.
# See the Blacklight and Geoblacklight rake files.

source ~/.rvm/scripts/rvm

cd ${APP_DIR}
rake "$@"