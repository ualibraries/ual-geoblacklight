#!/usr/bin/env bash
set -e

# this script is used to run solr tasks on the server
# run Solr commands with Docker command arguments

source ~/.profile

cd "/geoblacklight/app/docker/solr"
bin/solr "$@"