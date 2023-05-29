#!/bin/bash

source .env

cd docker
docker build --rm=true -t ual-goblight:latest -f app/Dockerfile .
docker build --rm=true -t ual-solr:latest --build-arg BASE_IMAGE_VERSION=${SOLR_VERSION} -f solr/Dockerfile .
