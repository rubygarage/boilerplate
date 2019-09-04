# frozen_string_literal: true

require 'simplecov'
require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

%w[api_doc support].each do |dir|
  Dir[Rails.root.join('spec', dir, '**', '*.rb')].each do |file|
    require file unless file[/\A.+_spec\.rb\z/]
  end
end

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Rails.application.load_tasks
Rake::Task['factory_bot:lint'].invoke

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.infer_base_class_for_anonymous_controllers = false
  config.mock_with :rspec do |mocks|
    mocks.allow_message_expectations_on_nil = true
  end

  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Helpers::RootHelpers
  config.include Helpers::OperationHelpers, type: :operation
  config.include Helpers::RequestHelpers, type: :request
end
