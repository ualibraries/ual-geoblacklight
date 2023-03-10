#!/usr/bin/env bash
set -e

source ~/.profile

cd /geoblacklight/solr/server/scripts/cloud-scripts
source zkcli.sh -zkhost zoo1:2181 -cmd putfile /security.json /home/geoblacklight/docker/app/security.json
