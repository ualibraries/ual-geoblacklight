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
#set :branch, "main"
set :branch, "story/15628"

# Default deploy_to directory is /var/www/
set :deploy_to, "/var/www"

# Ensure PATH is set correctly
#set :default_env, { path: "/home/deploy/.rvm/gems/ruby-3.2.2/bin:$PATH" }

# SSH options
set :ssh_options, {
 keys: [ssh_key_path],
  forward_agent: false,
  auth_methods: ["publickey"],
  user: "deploy",
  port: 22
}

# SSH options
#set :ssh_options, {
# keys: ["/home/gob/.ssh/ed25519_ashvini"],
# forward_agent: false,
# auth_methods: ["publickey"],
# user: "deploy",
# port: 22
#}

#Default value for keep_releases is 5
set :keep_releases, 10

# Set the path to Bundler explicitly
#set :bundle_path, '/home/deploy/.rvm/gems/ruby-3.2.2/bin'
#after :deploy, 'greetings:deploy_successful'

#namespace :greetings do
#  task :deploy_successful do
   #on roles(:all) do
     # info "Deploy Successful"
   # end
 # end
#end
namespace :greetings do
  task :deploy_successful do
    on roles(:all) do |host|
      within release_path do
        # Using execute to run commands on the remote server
        execute :echo, 'Deploy Successful'
        # Using capture to get the output of a command and print it locally
        result = capture(:echo, 'Deploy Successful')
        info result  # This will print the result to your local terminal
      end
    end
  end
end

#namespace :deploy do
# desc 'Restart application'
#  task :restart do
 #   on roles(:all), in: :sequence, wait: 5 do
      # Touch the restart.txt file to restart Passenger
  #    execute :touch, release_path.join('tmp/restart.txt')
#    end
 # end

 namespace :deploy do
  
  desc "Print environment variables"
  task :print do
    on roles(:all) do
      execute :printenv
    end
  end

  #desc 'bundle install'
  #task :install do
  #on roles(:all) do
   ##  execute :bundle, 'install --without development test' # Install gems excluding development and
    #end
  #end
#end

  desc 'Restart application'
  task :restart1 do
    on roles(:all) do
      within current_path do
        execute :touch, 'app/restart.txt' 
      end
    end
  end

  after :publishing, :restart1

  desc 'Print current path'
  task :print_current_path do
    on roles(:all) do
      info "Current path is #{current_path}"
    end
  end
end

 # after :publishing, :restart
#end 