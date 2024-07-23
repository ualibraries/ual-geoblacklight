# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"
require 'dotenv'

# Dynamically determine the project's root directory and load the .env file
project_root = File.expand_path('..', __dir__)
Dotenv.load(File.join(project_root, '.env'))


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

# Includes capistrano-rvm for managing Ruby versions
 require "capistrano/rvm"

# Includes capistrano/bundler for managing Bundler dependencies
 require "capistrano/bundler"
 require "capistrano/passenger"

# require "capistrano/rbenv"
# require "capistrano/chruby"
# require 'capistrano/rails'
# require "capistrano/rails/assets"
# require "capistrano/rails/migrations"


# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
