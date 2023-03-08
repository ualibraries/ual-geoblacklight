#!/usr/bin/env bash
set -em

# use this script to install the security file to enable solr & zookeeper security
# solr2 node already has the security.json mounted in the correct location. 
# the end of the script uploads the zookeeper security.json

source ~/.profile

SOLR_DIR="/geoblacklight/solr"
HOME_DIR="/home/geoblacklight"

cp "${HOME_DIR}/docker/app/security.json" "${SOLR_DIR}/server/solr/security.json"

cd $SOLR_DIR
echo -e "Uploading security file to Zookeeper...\n\n"
bin/solr zk cp "${HOME_DIR}/docker/app/security.json" zk:security.json -z zoo1:2181
echo -e "Restarting the Solr cluster...\n\n"
bin/solr restart
