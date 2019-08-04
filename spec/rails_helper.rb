# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::LcovFormatter
  ]
)

SimpleCov.minimum_coverage(100)

if ARGV.grep(/spec.\w+/).empty?
  SimpleCov.start 'rails' do
    add_filter(%r{^\/spec\/})
  end
end

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

%w[api_doc support].each do |dir|
  Dir[Rails.root.join('spec', dir, '**', '*.rb')].each { |file| require file }
end

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

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

  config.after(:each, :dox) do |example|
    # allow dox to handle 'multipart/form-data' requests
    example.metadata[:request] =
      if request.headers['CONTENT_TYPE']&.start_with?('multipart/form-data; boundary=')
        patched_request = request.dup
        def patched_request.body
          OpenStruct.new(read: request_parameters.to_json)
        end
        patched_request
      else
        request
      end

    example.metadata[:response] = response
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

Dox.configure do |config|
  config.header_file_path = Rails.root.join('spec', 'api_doc', 'v1', 'descriptions', 'header.md')
  config.desc_folder_path = Rails.root.join('spec', 'api_doc', 'v1', 'descriptions')
  config.headers_whitelist = %w[Accept Authorization X-Refresh-Token]
end

JsonMatchers.schema_root = 'spec/support/schemas'

RSpec::Matchers.define_negated_matcher :not_change, :change
