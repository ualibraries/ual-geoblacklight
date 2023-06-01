#!/usr/bin/env bash


# this script controls solr startup tasks. 
# this script may changed to add more security, etc.

if [[ ! -n "$(ls -d /var/solr/data/blacklight-core*)" ]]; then
    echo -e "\nCreating GOB Solr core...\n"
    solr-create -c blacklight-core -d /blacklight-core
fi

echo -e "\nSetting up and securing SolrCloud install with basic authentication...\n"
cd /opt/solr
bin/solr zk cp file:/opt/solr/server/solr/security.json zk:/security.json

# Don't add anything else below this comment
echo -e "\nRestarting the Solr server now...\n"
solr-foreground