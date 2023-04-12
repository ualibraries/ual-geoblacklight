#!/usr/bin/env bash
set -e

source ~/.profile

cd /geoblacklight/app/docker/solr/server/scripts/cloud-scripts
source zkcli.sh -zkhost zoo1:2181 -cmd putfile /security.json /home/gob/docker/solr/security.json
