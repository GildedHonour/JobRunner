source "https://rubygems.org"

ruby "2.0.0"

gem "rails", "4.0.2"

# Authentication
gem "devise"

# Model related
gem "enumerize"
gem "kaminari"

# View related
gem "haml-rails"
gem "nested_form"
gem "simple_form", github: "plataformatec/simple_form" #Latest for Bootstrap support

# Assets
gem "sass-rails", "~> 4.0.0"
gem "compass-rails", "~> 1.1.2"
gem "bootstrap-sass", "~> 3.0.3.0"
gem "bourbon"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.0.0"
gem "jquery-rails"

#gem "turbolinks"

# Server
gem "pg"
gem "unicorn"

# File uploads
gem "fog", "~> 1.3.1" # Required by carrierwave
gem "carrierwave"
gem "rmagick"

# Seed data
gem "ffaker"
gem "database_cleaner"

group :development do
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