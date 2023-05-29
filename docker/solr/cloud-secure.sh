#!/usr/bin/env bash

if [[ ! -n "$(ls -d /var/solr/data/blacklight-core*)" ]]; then
    echo -e "\nCreating GOB Solr core...\n"
    solr-create -c blacklight-core -d /blacklight-core
fi

echo -e "\nSetting up and securing SolrCloud install with basic authentication...\n"
cd /opt/solr
bin/solr zk cp file:/opt/solr/server/solr/security.json zk:/security.json

echo -e "\nRestarting the Solr server now...\n"
solr-foreground