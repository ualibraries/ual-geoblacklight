# syntax=docker/dockerfile:experimental

# We are starting with a full-fledged Java container
FROM eclipse-temurin:latest

ENV DISABLE_SPRING=1

ARG RUBY_VER=3.2.1
ARG RAILS_VERSION=6.1.4.6
ARG VIEW_COMPONENT_VERSION=2.6.6

ARG SOLR_HOST="http://0.0.0.0"
ARG SOLR_PORT="8983"
ARG SOLR_JETTY_HOST="http://0.0.0.0"
ARG SOLR_VERSION=9.1.1
ARG SOLR_URL="http://solr:SolrRocks@0.0.0.0:8983/solr/blacklight-core/"

ARG ZK_HOST=zoo1:2181

# user and perm args
# ARGS can be overwritten in docker run or docker-compose
ARG USER=gob
ARG PASS=gobb13
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# project DRY dirs
ENV PROJECT_DIR="/geoblacklight"
ENV APP_DIR="${PROJECT_DIR}/app"
ENV USER_HOME="/home/gob"

# Image install and update packages, and cleaning too!
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q \
    && apt-get upgrade -qy

RUN apt-get install -qy \
    bash \
    build-essential \
    curl \
    git \
    ca-certificates \
    gnupg2 \
    lsof \
    openssl \
    nodejs \
    npm \
    sqlite3 \
    sudo \
    vim \
    tzdata

# install node stuff
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -q
RUN apt-get install -qy \
    yarn

# clean up system deps
RUN apt-get autoremove -y \
    && apt-get --fix-broken install \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# create a newer, shinier sleeve
RUN groupadd --gid ${USER_GID} ${USER} \
    && useradd -p ${PASS} --uid ${USER_UID} --gid ${USER_GID} -m ${USER} \
    && echo ${USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER} \
    && chmod 0440 /etc/sudoers.d/${USER}

RUN mkdir ${PROJECT_DIR} \
    # mkdir ${PROJECT_DIR}/solr \
    && chown -R ${USER}:${USER} /geoblacklight

RUN echo "source ~/.rvm/scripts/rvm" >> "${USER_HOME}/.bashrc"

USER gob
EXPOSE 3000
EXPOSE 8983
WORKDIR ${PROJECT_DIR}

RUN gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable

# install RoR and app code
COPY . "${USER_HOME}/docker"

SHELL [ "/bin/bash", "-c" ]
RUN "${USER_HOME}/docker/app/install_app.sh"
