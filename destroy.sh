#!/bin/bash

env USER_GID=$(id -g) USER_UID=$(id -u) docker compose down -v
