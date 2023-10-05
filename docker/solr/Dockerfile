# syntax=docker/dockerfile:experimental

ARG SOLR_VERSION=latest
FROM solr:${SOLR_VERSION}

ARG SOLR_USER=solr
ARG SOLR_PASS=SolrRocks
ENV SOLR_AUTH=${SOLR_USER}:${SOLR_PASS}
ARG SECRET=${CERT_SECRET}

EXPOSE 8983

USER root

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q \
    && apt-get upgrade -qy

RUN apt-get install -qy \
    bash \
    git

RUN apt-get autoremove -y \
    && apt-get --fix-broken install \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --chown=solr:solr ./solr/solr.in.sh /etc/default/solr.in.sh

RUN git clone https://github.com/geoblacklight/geoblacklight.git /home/solr/geoblacklight
RUN mv /home/solr/geoblacklight/solr/conf /blacklight-core
RUN chown -R solr:solr /blacklight-core \
    && chmod -R a+X /blacklight-core
RUN rm -rf /home/solr/geoblacklight

RUN cd /var/solr && keytool -genkeypair \
    -alias solr-ssl \
    -keyalg RSA \
    -keysize 2048 \
    -keypass zeZeFnRDNEAKXbts22D4M2QBUy82LwnN \
    -storepass zeZeFnRDNEAKXbts22D4M2QBUy82LwnN \
    -validity 9999 \
    -keystore solr-ssl.keystore.p12 \
    -storetype PKCS12 \
    -ext SAN=DNS:localhost,DNS:zookeeper,DNS:ual-gob,DNS:solr1,IP:0.0.0.0,IP:127.0.0.1 \
    -dname "CN=localhost, OU=Organizational Unit, O=Organization, L=Location, ST=State, C=Country"
RUN chown -R solr:solr /var/solr

USER solr
WORKDIR /home/solr