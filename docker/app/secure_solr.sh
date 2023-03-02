#!/usr/bin/env bash
set -em

# use this script to install the security file to enable solr admin security

source ~/.profile

SOLR_DIR="/geoblacklight/solr"

cp /home/geoblacklight/docker/app/security.json "${SOLR_DIR}/server/solr/security.json"
cd $SOLR_DIR && bin/solr restart