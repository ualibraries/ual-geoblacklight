#!/usr/bin/env bash


# This script controls solr startup tasks and may be changed to add more security, etc.

if [[ ! -n "$(ls -d /var/solr/data/blacklight-core*)" ]]; then
    echo -e "\nCreating GOB Solr core...\n"
    solr-create -c blacklight-core -d /blacklight-core
fi

# Don't add anything else below this comment.
echo -e "\nRestarting the Solr server now...\n"
solr-foreground