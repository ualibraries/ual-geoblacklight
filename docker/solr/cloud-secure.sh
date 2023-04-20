#!/usr/bin/env bash


export SOLR_DIR="${PROJECT_DIR}/solr"

# if [[ -f "${SOLR_DIR}/bin/solr-8983.pid" ]]; then
#     rm "${SOLR_DIR}/bin/solr-8983.pid"
# fi

# solr.in.sh controls ZK params and basic auth method
# we have to copy this in, since Solr was started by GOB w/o it.
rm "${SOLR_DIR}/bin/solr.in.sh" \
    && cp "${USER_HOME}/docker/solr/solr.in.sh" "${SOLR_DIR}/bin/solr.in.sh"

cd "${SOLR_DIR}"
bin/solr auth enable -type basicAuth -credentials solr:SolrRocks -z zoo1:2181 -verbose
