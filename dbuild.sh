#!/bin/bash

source .env

cd docker

docker build --rm=true -t ual-goblight:latest \
    --build-arg RUBY_VERSION=${RUBY_VERSION} \
    --build-arg RAILS_VERSION=${RAILS_VERSION} \
    --build-arg VIEW_COMPONENT_VERSION=${VIEW_COMPONENT_VERSION} \
    -f app/Dockerfile .

docker build --rm=true -t ual-solr:latest \
    --build-arg SOLR_VERSION=${SOLR_VERSION} \
    -f solr/Dockerfile .
