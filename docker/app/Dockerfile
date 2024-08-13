# syntax=docker/dockerfile:1
FROM ruby:3.2.2

ENV NODE_MAJOR_VERSION=16

# Add NodeSource signing key
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource-archive-keyring.gpg

# Add the NodeSource repository
RUN echo "deb [signed-by=/usr/share/keyrings/nodesource-archive-keyring.gpg] https://deb.nodesource.com/node_${NODE_MAJOR_VERSION}.x jammy main" | tee /etc/apt/sources.list.d/nodesource.list

# Update the package list again and install
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Verify Node.js installation
RUN node -v

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY ./docker/app/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]