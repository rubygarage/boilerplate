# frozen_string_literal: true

source 'https://rubygems.org'

ruby(File.read(File.join(File.dirname(__FILE__), '.ruby-version')).strip)

# System
gem 'pg', '~> 1.2', '>= 1.2.3'
gem 'puma', '~> 5.2'
gem 'rails', '~> 6.1'
gem 'sidekiq', '~> 6.1'

# Admin panel
gem 'activeadmin', '~> 2.9'

gem 'webpacker', '~> 5.0'

# Admin's authentication
gem 'devise', '~> 4.7'
gem 'rack-cors', '~> 1.1'

# Trailblazer bundle
gem 'dry-container', '~> 0.7.2'
gem 'dry-validation', '0.11.1'
gem 'simple_endpoint', '~> 1.0.0'
gem 'trailblazer', '~> 2.1'

# Decorator
gem 'draper', '~> 4.0', '>= 4.0.1'

# JSON:API Serializer
gem 'jsonapi-serializer', '~> 2.1'
gem 'oj', '~> 3.11'

# Pagination
gem 'pagy', '~> 3.11'

# Uploading
gem 'aws-sdk-s3', '~> 1.89'
gem 'shrine', '~> 3.3'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Authentication
gem 'bcrypt', '~> 3.1'
gem 'jwt_sessions', '~> 2.5'

# Error tracking
gem 'sentry-raven', '~> 3.1'

group :development, :test do
  gem 'factory_bot_rails', '~> 6.1'
  gem 'ffaker', '~> 2.18'
  gem 'pry-byebug', '~> 3.9'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 4.0'

  # Code quality
  gem 'brakeman', '~> 5.0', require: false
  gem 'bundle-audit', '~> 0.1.0', require: false
  gem 'fasterer', '~> 0.9.0', require: false
  gem 'i18n-tasks', '~> 0.9.34', require: false
  gem 'lefthook', '~> 0.7.2', require: false
  gem 'rails_best_practices', '~> 1.20', require: false
  gem 'reek', '6.0.3', require: false
  gem 'rswag', '~> 2.4.0'
  gem 'rubocop', '~> 0.93.1', require: false
  gem 'rubocop-performance', '~> 1.10', require: false
  gem 'rubocop-rails', '~> 2.9', require: false
  gem 'rubocop-rspec', '~> 1.43', require: false
end

group :development do
  gem 'dip', '~> 6.1'
  gem 'letter_opener', '~> 1.7'
  gem 'listen', '~> 3.4'
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0', '>= 2.0.1'
end

group :test do
  gem 'capybara', '~> 3.35'
  gem 'json_matchers', '~> 0.11.1', require: 'json_matchers/rspec'
  gem 'mock_redis', '~> 0.27.3'
  gem 'n_plus_one_control', '~> 0.6.0'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'rspec-sidekiq', '~> 3.1'
  gem 'shoulda-matchers', '~> 4.5'
  gem 'simplecov', '~> 0.21.2', require: false
  gem 'simplecov-lcov', '~> 0.8.0', require: false
  gem 'undercover', '~> 0.4.0', require: false
  gem 'webdrivers', '~> 4.6', require: false
end
