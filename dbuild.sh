#!/bin/bash

cd docker
docker build --rm=true -t ual-goblight:latest -f Dockerfile . || exit 1
