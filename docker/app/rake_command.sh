#!/usr/bin/env bash
set -e

# this script is used to run rake tasks in the application
# run rake commands with Docker command arguments

source ~/.profile

cd /geoblacklight/ual_geoblacklight
rake "$@"