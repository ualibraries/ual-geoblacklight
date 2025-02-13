# syntax = docker/dockerfile:1
FROM ruby:3.2.2

RUN curl https://oss-binaries.phusionpassenger.com/auto-software-signing-gpg-key.txt | gpg --dearmor > /etc/apt/trusted.gpg.d/phusion.gpg
RUN sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bookworm main > /etc/apt/sources.list.d/passenger.list'

# Update the package list again and install
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    nodejs \
    apache2 \
    libapache2-mod-passenger \
    libapache2-mod-shib && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN a2enmod rewrite shib passenger

RUN mkdir -p /var/run/passenger-instreg
RUN chown -R www-data:www-data /var/run/passenger-instreg
RUN chmod 755 /var/run/passenger-instreg

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
