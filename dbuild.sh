#!/bin/bash

cd docker/app
docker build --rm=true -t ual-goblight:latest -f Dockerfile . || exit 1
docker system prune
