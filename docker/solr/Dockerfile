# syntax=docker/dockerfile:experimental

ARG SOLR_VERSION=latest
FROM solr:${SOLR_VERSION}

ARG ZK_HOST=zoo1:2181
ARG SOLR_PORT=8983
ARG SOLR_JETTY_HOST=0.0.0.0

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

COPY --chown=solr:solr ./solr/security.json /opt/solr/server/solr/security.json
COPY --chown=solr:solr ./solr/solr.in.sh /etc/default/solr.in.sh

RUN git clone https://github.com/geoblacklight/geoblacklight.git /home/solr/geoblacklight
RUN mv /home/solr/geoblacklight/solr/conf /blacklight-core
RUN chown -R solr:solr /blacklight-core \
    && chmod -R a+X /blacklight-core
RUN rm -rf /home/solr/geoblacklight

RUN chown -R solr:solr /var/solr

USER solr
WORKDIR /home/solr