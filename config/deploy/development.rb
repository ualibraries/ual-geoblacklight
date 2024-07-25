# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}
# Set the Rails environment to production
set :rails_env, 'development'

# Set the stage name
set :stage, :development

# Define the server(s) for deployment
server '150.135.174.83', user: 'deploy', roles: %w{web app db}


set :bundle_without, nil

set :bundle_config, {
  deployment: true,
  with: "development"
}