# frozen_string_literal: true

source 'https://rubygems.org'

ruby(File.read(File.join(File.dirname(__FILE__), '.ruby-version')).strip)

# System
gem 'pg', '~> 1.2', '>= 1.2.3'
gem 'puma', '~> 4.3'
gem 'rails', '~> 6.0'
gem 'sidekiq', '~> 6.1'

# Trailblazer bundle
gem 'dry-container', '~> 0.7.2'
gem 'dry-validation', '0.11.1'
gem 'trailblazer', '~> 2.1'
gem 'trailblazer-endpoint', github: 'trailblazer/trailblazer-endpoint'

# Decorator
gem 'draper', '~> 4.0', '>= 4.0.1'

# JSON:API Serializer
gem 'jsonapi-serializer', '~> 2.1'
gem 'oj', '~> 3.10'

# Pagination
gem 'pagy', '~> 3.8'

# Uploading
gem 'aws-sdk-s3', '~> 1.14'
gem 'shrine', '~> 3.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Authentication
gem 'bcrypt', '~> 3.1'
gem 'jwt_sessions', '~> 2.5'

group :development, :test do
  gem 'bullet', '~> 6.1'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'ffaker', '~> 2.17'
  gem 'pry-byebug', '~> 3.9'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 4.0'

  # Code quality
  gem 'brakeman', '~> 4.9', require: false
  gem 'bundle-audit', '~> 0.1.0', require: false
  gem 'fasterer', '~> 0.8.3', require: false
  gem 'overcommit', '~> 0.55.0', require: false
  gem 'rails_best_practices', '~> 1.20', require: false
  gem 'reek', '6.0.1', require: false
  gem 'rubocop', '~> 0.90.0', require: false
  gem 'rubocop-performance', '~> 1.6', require: false
  gem 'rubocop-rails', '~> 2.8', require: false
  gem 'rubocop-rspec', '~> 1.41', require: false
end

group :development do
  gem 'letter_opener', '~> 1.7'
  gem 'listen', '~> 3.2', '>= 3.2.1'
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0', '>= 2.0.1'
end

group :test do
  gem 'dox', '~> 1.2'
  gem 'json_matchers', '~> 0.11.1', require: 'json_matchers/rspec'
  gem 'mock_redis', '~> 0.22.0'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'rspec-sidekiq', '~> 3.1'
  gem 'shoulda-matchers', '~> 4.4'
  gem 'simplecov', '~> 0.19.0', require: false
  gem 'simplecov-lcov', '~> 0.8.0', require: false
  gem 'undercover', '~> 0.3.4', require: false
end
