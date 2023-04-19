#!/usr/bin/env bash
set -e

# this script is used to run solr tasks on the server

cd "/geoblacklight/solr"
bin/solr "$@"