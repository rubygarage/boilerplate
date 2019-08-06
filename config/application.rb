# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'

Bundler.require(*Rails.groups)

module BoilerplateRailsApi
  class Application < Rails::Application
    config.load_defaults 6.0
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]
    config.eager_load_paths << Rails.root.join('lib')
    config.api_only = true
    config.active_job.queue_adapter = :sidekiq
    config.test_framework = :rspec
  end
end
