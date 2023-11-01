#!/bin/bash


# script to tail app logs for development

docker exec -it gob-app bash -c -l 'cd /geoblacklight/app/log && tail -f -n 50 development.log'