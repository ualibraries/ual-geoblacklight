# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Include StringIO
require 'stringio'

# Load the SCM plugin appropriate to your project:
#
# require "capistrano/scm/hg"
# install_plugin Capistrano::SCM::Hg
# or
# require "capistrano/scm/svn"
# install_plugin Capistrano::SCM::Svn
# or
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger


# Include capistrano plugins related to Rails
require "capistrano/rvm"
require "capistrano/bundler"
require "capistrano/passenger"
require 'capistrano/rails'
require 'capistrano/rake'

# Ensure Slackistrano is loaded before custom Slack messaging
require 'slackistrano/capistrano'

# Now load your custom Slack messaging class
require_relative 'lib/slackistrano/custom_slack_messaging'

# require "capistrano/rbenv"
# require "capistrano/chruby"

# Not needed if 'capistrano/rails' is required
# require "capistrano/rails/assets"
# require "capistrano/rails/migrations"




# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
