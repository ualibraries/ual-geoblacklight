# syntax=docker/dockerfile:experimental

# We are starting with a full-fledged Java container
FROM eclipse-temurin:latest

ENV DISABLE_SPRING=1

# user and perm args
# ARGS can be overwritten in docker run or docker-compose
ARG USER=geoblacklight
ARG PASS=gobb13
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Image install and update packages, and cleaning too!
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q \
    && apt-get upgrade -qy

RUN apt-get install -qy \
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
    sudo
    
RUN apt-get autoremove -y \
    && apt-get --fix-broken install \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# create a newer, shinier sleeve
RUN groupadd --gid ${USER_GID} ${USER} \
    && useradd -p ${PASS} --uid ${USER_UID} --gid ${USER_GID} -m ${USER} \
    && echo ${USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER} \
    && chmod 0440 /etc/sudoers.d/${USER}

RUN mkdir /geoblacklight \
    && chown ${USER}:${USER} /geoblacklight

USER geoblacklight
WORKDIR /home/${USER}

# install RoR stuff
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s

EXPOSE 3000
EXPOSE 8983
