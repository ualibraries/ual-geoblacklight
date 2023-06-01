# syntax=docker/dockerfile:experimental

ARG SOLR_VERSION=latest
FROM solr:${SOLR_VERSION}

ARG SOLR_USER=solr
ARG SOLR_PASS=SolrRocks
ENV SOLR_AUTH=${SOLR_USER}:${SOLR_PASS}

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

RUN chown -R solr:solr /var/solr

USER solr
WORKDIR /home/solr