#!/usr/bin/env bash
set -e

# this script is used to run rake tasks in the application

source ~/.rvm/scripts/rvm

cd /geoblacklight/app
rake "$@"