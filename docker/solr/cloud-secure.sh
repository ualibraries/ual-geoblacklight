#!/usr/bin/env bash


export SOLR_DIR="${PROJECT_DIR}/solr"

cd "${SOLR_DIR}/server/scripts/cloud-scripts"
source zkcli.sh -zkhost zoo1:2181 -cmd putfile /security.json "${USER_HOME}/docker/solr/security.json"

cd ${SOLR_DIR}
bin/solr restart
