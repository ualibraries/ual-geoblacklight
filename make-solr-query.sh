#!/bin/bash


# script to READ index data
# this does not create, update, or delete data!
# give the Docker container a few minutes to run all its default startup tasks

source .env

QUERY="${@:-'q=*:*'}"
curl --data ${QUERY} "http://${SOLR_USER}:${SOLR_PASS}@127.0.0.1:${SOLR_PORT}/solr/blacklight-core/select"