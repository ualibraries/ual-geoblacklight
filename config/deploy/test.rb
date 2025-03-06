# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}
# Set the Rails environment to test
set :rails_env, 'test'

# Set the stage name
set :stage, :test

# Define the server(s) for deployment
server '10.130.155.21', user: 'deploy', roles: %w{web app db}

# Link database configuration and test environment encryption key
append :linked_files, "config/database.yml", "config/credentials/test.key", "config/credentials/test.yml.enc"
