#!/usr/bin/env bash
set -em

# this script is used to run solr tasks on the server
# run Solr commands with Docker command arguments

source ~/.profile

cd "/geoblacklight/solr/"
bin/solr "$@"