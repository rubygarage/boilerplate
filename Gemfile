# frozen_string_literal: true

source 'https://rubygems.org'

ruby(File.read(File.join(File.dirname(__FILE__), '.ruby-version')).strip)

# System
gem 'pg', '~> 1.1', '>= 1.1.4'
gem 'puma', '~> 4.3', '>= 4.3.1'
gem 'rails', '~> 6.0', '>= 6.0.1'
gem 'sidekiq', '~> 6.0', '>= 6.0.1'

# Trailblazer bundle
gem 'dry-validation', '0.11.1'
gem 'trailblazer', '~> 2.1'
gem 'trailblazer-endpoint', github: 'trailblazer/trailblazer-endpoint'

# Decorator
gem 'draper', '~> 3.1'

# JSON:API Serializer
gem 'fast_jsonapi', '~> 1.5'
gem 'oj', '~> 3.10'

# Pagination
gem 'pagy', '~> 3.7', '>= 3.7.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Authentication
gem 'bcrypt', '~> 3.1', '>= 3.1.13'
gem 'jwt_sessions', '~> 2.4', '>= 2.4.3'

group :development, :test do
  gem 'bullet', '~> 6.0', '>= 6.0.2'
  gem 'factory_bot_rails', '~> 5.1', '>= 5.1.1'
  gem 'ffaker', '~> 2.13'
  gem 'pry-byebug', '~> 3.7'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 3.9'

  # Code quality
  gem 'brakeman', '~> 4.7', '>= 4.7.2', require: false
  gem 'bundle-audit', '~> 0.1.0', require: false
  gem 'fasterer', '~> 0.8.1', require: false
  gem 'overcommit', '~> 0.51.0', require: false
  gem 'rails_best_practices', '~> 1.19', '>= 1.19.4', require: false
  gem 'reek', '5.3.2', require: false
  gem 'rubocop', '~> 0.77.0', require: false
  gem 'rubocop-performance', '~> 1.5', '>= 1.5.1', require: false
  gem 'rubocop-rails', '~> 2.4', require: false
  gem 'rubocop-rspec', '~> 1.37', require: false
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
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.4'
  gem 'rspec-sidekiq', '~> 3.0', '>= 3.0.3'
  gem 'shoulda-matchers', '~> 4.1', '>= 4.1.2'
  gem 'simplecov', '~> 0.17.1', require: false
  gem 'simplecov-lcov', '~> 0.7.0', require: false
  gem 'undercover', '~> 0.3.2', require: false
end
