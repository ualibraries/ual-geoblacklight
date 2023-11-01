#!/usr/bin/env bash


# This script controls solr startup tasks and may be changed to add more security, etc.
# Auth credentials come from a couple different locations:
# solr creds: .env (built into container)
# zk creds: docker/solr/solr.in.sh (also built in)
# Index shard number can be increased in the solr-create command below.

if [[ ! -n "$(ls -d /var/solr/data/blacklight-core*)" ]]; then
    echo -e "\nCreating GOB Solr core...\n"
    solr-create -c blacklight-core -d /blacklight-core -shards 2 -V
fi

echo -e "\nSetting up and securing SolrCloud install with basic authentication...\n"
cd /opt/solr
bin/solr auth enable -type basicAuth -credentials ${SOLR_AUTH} -zkHost zoo1:2181 -blockUnknown true

# Don't add anything else below this comment.
echo -e "\nRestarting the Solr server now...\n"
solr-foreground