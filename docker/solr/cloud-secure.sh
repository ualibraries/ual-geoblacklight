#!/usr/bin/env bash


export SOLR_DIR="${PROJECT_DIR}/solr"

source ~/.rvm/scripts/rvm

# solr.in.sh controls ZK params and basic auth method
# we have to copy this in, since Solr was started by GOB w/o it.
rm "${SOLR_DIR}/bin/solr.in.sh" \
    && cp "${USER_HOME}/docker/solr/solr.in.sh" "${SOLR_DIR}/bin/solr.in.sh"

cd "${APP_DIR}"
rake solr:restart