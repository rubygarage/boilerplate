# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.6.3'

# System
gem 'pg'
gem 'puma'
gem 'rails', '~> 6.0.0.rc2'
gem 'sidekiq'

# Trailblazer bundle
gem 'dry-validation', '0.11.1'
gem 'trailblazer', '~> 2.1.0rc1'
gem 'trailblazer-endpoint', github: 'trailblazer/trailblazer-endpoint'

# Decorator
gem 'draper'

# JSON:API Serializer
gem 'fast_jsonapi'
gem 'oj'

# Pagination
gem 'pagy'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Authentication
gem 'jwt_sessions'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'

  # Code quality
  gem 'brakeman', require: false
  gem 'bundle-audit', require: false
  gem 'fasterer', require: false
  gem 'overcommit', require: false
  gem 'rails_best_practices', require: false
  gem 'reek', '5.3.2', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'dox'
  gem 'json_matchers', require: 'json_matchers/rspec'
  gem 'rails-controller-testing'
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false
  gem 'undercover', require: false
end
