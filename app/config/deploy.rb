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

#append :linked_files, 'app/config/master.key'

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

# #TASK : USIMG CAPISTRANO SYMBOLIC LINK

# set :local_master_key_path, "config/master.key"
# namespace :deploy do
#   desc 'Upload master.key'
#   task :upload_master_key do
#     on roles(:all) do
#       # Ensure the shared directory exists
#       execute :mkdir, "-p", "#{shared_path}/config"
#       # Upload the master key from the local machine to the server
#       upload! fetch(:local_master_key_path), "#{shared_path}/config/master.key"
#     end
#   end

#   desc 'Link master.key'
#   task :link_master_key do
#     on roles(:all) do
#       # Link the uploaded master key to the release directory
#       execute :ln, "-s", "#{shared_path}/config/master.key", "#{release_path}/app/config/master.key"
#     end
#   end

#   before 'deploy:check:linked_files', 'deploy:upload_master_key'
#   after 'deploy:symlink:shared', 'deploy:link_master_key'
# end
##----------------------------------------------------------------------------------------------------##

##----------------------------------------------------------------------------------------------------##
# #TASK : AFTER DEPLOYEMENT EACH TIME CAPISTRANO SHOULD CREATE CREDENTIAL AND MASTER KEY FILE
# namespace :deploy do
#   desc 'Generate new master.key and credentials.yml.enc'
#   task :generate_credentials do
#     on roles(:all) do
#       within release_path do
#         execute :rm, '-f', "#{release_path}/app/config/master.key"
#         execute :rm, '-f', "#{release_path}/app/config/credentials.yml.enc"

#         # Ensure the config directory exists
#         #execute :mkdir, "-p", "#{shared_path}/config"

#         # Generate a new master.key
#         #execute :rails, 'secret > config/master.key'
#        # execute :cp, 'config/master.key', "#{shared_path}/config/master.key"

#          #Generate new credentials.yml.enc and master.key#
#          #execute :bundle, :exec, "EDITOR='nano --wait' rails credentials:edit"
#          execute :bash, "-l -c 'source ~/.rvm/scripts/rvm && cd #{release_path}/app && EDITOR=\"nano --wait\" bundle exec rails credentials:edit'"
#       end
#     end
#   end
#   after 'deploy:symlink:release', 'deploy:generate_credentials'
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


##----------------------------------------------------------------------------------------------------##
# #TASK : DEPLOYEMENT SUCCESSFULL TASK

# namespace :greetings do
#   task :deploy_successful do
#     on roles(:all) do |host|
#       within release_path do
#         # Using execute to run commands on the remote server
#         execute :echo, 'Deploy Successful'
#         # Using capture to get the output of a command and print it locally
#         result = capture(:echo, 'Deploy Successful')
#         info result  # This will print the result to your local terminal
#       end
#     end
#   end
#after :deploy, 'greetings:deploy_successful'
#end
##----------------------------------------------------------------------------------------------------##


##----------------------------------------------------------------------------------------------------##
# #TASK : Restart server

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
