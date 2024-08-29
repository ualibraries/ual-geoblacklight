# lib/tasks/yarn.rake

# Ensures that `yarn install` runs before `assets:precompile`
Rake::Task["assets:precompile"].enhance ["yarn:install"]