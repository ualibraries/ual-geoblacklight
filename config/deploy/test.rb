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

# Link production sqlite file and master key
append :linked_files, "db/test.sqlite3", "config/master.key"