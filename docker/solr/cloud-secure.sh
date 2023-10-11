#!/usr/bin/env bash


# this script controls solr startup and security tasks. 
# change it to add more security, etc.

if [[ ! -f "/var/solr/solr-ssl.p12" ]]; then
    echo -e "\nGenerating SSL keystore...\n"
    cd /var/solr
    keytool -genkeypair -v \
        -alias solr-ssl \
        -keyalg RSA \
        -keysize 2048 \
        -keypass ${CERT_SECRET} \
        -storepass ${CERT_SECRET} \
        -validity 9999 \
        -keystore solr-ssl.keystore.p12 \
        -storetype PKCS12 \
        -ext SAN=DNS:localhost,DNS:zookeeper,DNS:ual-gob,DNS:solr1,IP:0.0.0.0,IP:127.0.0.1 \
        -dname "CN=localhost, OU=Organizational Unit, O=Organization, L=Location, ST=State, C=Country"
fi

cd /opt/solr
if [[ ! -n "$(ls -d /var/solr/data/blacklight-core*)" ]]; then
    echo -e "\nCreating GOB Solr core...\n"
    bin/solr stop -V -h 0.0.0.0
    bin/solr start -V -noprompt -h 0.0.0.0
    solr-create -c blacklight-core -d /blacklight-core
fi

echo -e "\nSetting up and securing SolrCloud install with basic authentication...\n"
bin/solr auth enable -type basicAuth -credentials ${SOLR_AUTH} -zkHost zoo1:2181 -blockUnknown true

### Don't add anything else below this comment ###
echo -e "\nRestarting the Solr server now...\n"
solr-foreground -V -h 0.0.0.0 -p 8984