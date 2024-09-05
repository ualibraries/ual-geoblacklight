require 'dotenv/load'

# config valid for current version and patch releases of Capistrano
lock "~> 3.0"

# Fetch SSH key path from environment variables
ssh_key_path = ENV['DEPLOY_SSH_KEY_PATH']

# Raise an error if the SSH key path is not provided
raise "DEPLOY_SSH_KEY_PATH environment variable is not set" unless ssh_key_path

# Fetch Slack webhook from environment variables
slack_webhook = ENV['SLACK_WEB_HOOK']

# Raise an error if the Slack webhook is not provided
raise "SLACK_WEB_HOOK environment variable is not set. This is required for deployment. #{slack_webhook}" unless slack_webhook

set :application, "ual-goblight"
set :repo_url, "https://github.com/ualibraries/ual-geoblacklight.git"

# Sets rvm to ~/.rvm
set :rvm_type, :user

# Default branch is :main
set :branch, ENV['BRANCH'] || "main"

# Default deploy_to directory is /var/www/
set :deploy_to, "/var/www"

# SSH options
set :ssh_options, {
 keys: [ssh_key_path],
  forward_agent: false,
  auth_methods: ["publickey"],
  user: "deploy",
  port: 22
}

append :linked_files, ".env"
append :linked_dirs, "log", ".bundle", 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle'

#Default value for keep_releases is 5
set :keep_releases, 10

set :passenger_restart_with_sudo, true

set :slackistrano, {
  klass: Slackistrano::CustomSlackMessaging,
  channel: '#tess-dev-deployer',
  webhook: slack_webhook
}