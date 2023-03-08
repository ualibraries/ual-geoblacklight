#!/bin/bash
set -x

env USER_GID=$(id -g) USER_UID=$(id -u) docker-compose up -d
