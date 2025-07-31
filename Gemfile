source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "7.2.2.1"
# Use sqlite3 as the database for Active Record (dev)
gem "sqlite3", "1.7.3"
# PostgreSQL as the database for Active Record (prd/tst)
gem 'pg', '~> 1.5', '>= 1.5.9'
# Use Puma as the app server
gem "puma", "5.6.8"
## Use SCSS for stylesheets
gem "sass-rails", "6.0.0"

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "5.4.4"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", "2.0.6"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails", "2.0.1"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", "1.3.3"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "2.12.0"

# Dependencies for ed25519
gem "ed25519", "1.3.0"
gem "bcrypt_pbkdf", "1.1.0"
gem "dotenv", "3.1.2"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "1.18.3", require: false
gem 'slackistrano', "4.0.2"
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", "11.1.3", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Capistrano is a deployment automation tool. Version 3.18 is specified here.
  gem "capistrano", "3.19.1"
  gem "capistrano-bundler", "2.1.0"
  gem "capistrano-rvm", "0.1.2"
  gem "capistrano-passenger","0.2.1"
  gem "capistrano-rails", "1.6.3"
  gem 'capistrano-rake', require: false
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", "4.2.1"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "rack-mini-profiler", "2.3.4"
  gem "listen", "3.9.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring", "4.2.1"

end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", "3.40.0"
  gem "selenium-webdriver", "4.10.0"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers", "5.3.1"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "blacklight", "7.41.0"
gem "geoblacklight", "4.5.0"
gem "sprockets", "3.7.3"

group :development do
  gem "solr_wrapper", "4.0.2"
end
gem "rsolr", "2.6.0"
gem "bootstrap", "4.6.2"
gem "twitter-typeahead-rails", "0.11.1.pre.corejavascript"
gem "jquery-rails", "4.6.0"
gem "devise", "4.9.4"
gem "geo_combine", "0.9.1"
gem 'omniauth'
gem 'omniauth-rails_csrf_protection'