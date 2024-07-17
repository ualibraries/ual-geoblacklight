# config valid for current version and patch releases of Capistrano
lock "~> 3.18.1"

# Load environment variables from .env file
require 'dotenv'

# Dynamically determine the project's root directory and load the .env file
project_root = File.expand_path('..', __dir__)
Dotenv.load(File.join(project_root, '.env'))

# Fetch SSH key path from environment variables
ssh_key_path = ENV['DEPLOY_SSH_KEY_PATH']

# Raise an error if the SSH key path is not provided
raise "DEPLOY_SSH_KEY_PATH environment variable is not set" unless ssh_key_path

set :application, "ual-goblight"
set :repo_url, "git@github.com:ualibraries/geoblacklight-docker.git"

# Default branch is :master
set :branch, "main"

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

#Default value for keep_releases is 5
set :keep_releases, 10

##----------------------------------------------------------------------------------------------------##
# #TASK : RESTART SERVER
#  namespace :deploy do
#  desc 'Restart application'
#    task :restart do
#     on roles(:all), in: :sequence, wait: 5 do
#        #Touch the restart.txt file to restart Passenger
#       execute :touch, release_path.join('app/tmp/restart.txt')
#       execute :sudo, :service, :apache2, :restart
#     end
#   end
#   #Hook the task to run fter deployy
#   after :publishing, :restart
# end
##----------------------------------------------------------------------------------------------------##


##----------------------------------------------------------------------------------------------------##

# #TASK : UPLOAD CREDENTIALS.YML.ENC
# set :local_credentials_key_path, "config/credentials.yml.enc"
# namespace :deploy do
#   desc 'Upload credentials.yml.enc'
#   task :upload_credentials_file  do
#     on roles(:all) do
#       within release_path do
#         execute :rm, '-f', "#{release_path}/app/config/credentials.yml.enc"
#         upload! fetch(:local_credentials_key_path), "#{release_path}/app/config/credentials.yml.enc"
#       end
#     end
#   end
#   after 'deploy:symlink:release', 'deploy:upload_credentials_file'
# end
##----------------------------------------------------------------------------------------------------##
