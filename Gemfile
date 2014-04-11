source "https://rubygems.org"

ruby "2.1.1"

gem "rails", "4.0.4"

# Authentication
gem "devise"
gem "devise_invitable"

# Model related
gem "enumerize"
gem "kaminari"
gem "paper_trail"

# View related
gem "haml-rails"
gem "nested_form"
gem 'simple_form', '~> 3.0.0', github: 'plataformatec/simple_form', branch: 'master'
gem "vpim"
gem "webshims-rails"

# Assets
gem "sass-rails", "~> 4.0.0"
gem "compass-rails", "~> 1.1.2"
gem 'bootstrap-sass', '~> 3.1.1.0'
gem "neat" #grid
gem "bourbon"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.0"
gem "jquery-rails"
gem "turbolinks"

# Server
gem "pg"
gem "unicorn"

# File uploads
gem "fog", ">= 1.3.1" # Required by carrierwave
gem "carrierwave"
gem "rmagick"

# Seed data
gem "ffaker"
gem "database_cleaner"
gem 'awesome_print'

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'letter_opener'
  gem 'quiet_assets'
  gem 'pry-rails'
end

group :production do
  gem "rails_12factor"
end

group :test do
  gem "rspec-rails"
  gem "factory_girl"
  gem "shoulda-matchers"
end
