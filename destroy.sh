#!/bin/bash

env USER_GID=$(id -g) USER_UID=$(id -u) docker compose down -v
rm -rf ./ual_gob/* ./ual_gob/.docker_init_flag
