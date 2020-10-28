# frozen_string_literal: true

require 'shrine/storage/s3'

Rails.application.configure do
  # Image uploads configuration.

  s3_options = {
    access_key_id: Rails.application.credentials.aws[:access_key_id],
    secret_access_key: Rails.application.credentials.aws[:secret_access_key],
    region: Rails.application.credentials.aws[:s3][:region],
    bucket: Rails.application.credentials.aws[:s3][:bucket]
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: 'cache', public: true, **s3_options),
    store: Shrine::Storage::S3.new(prefix: 'store', public: true, **s3_options)
  }

  config.token_store = [:redis, { redis_url: Rails.application.credentials.redis[:db] }]

  # Default shrine image url host
  config.enable_default_host_for_shrine_url = false

  # API documentation accessibility
  config.api_documentation_accessibility = true

  # Hosts
  # config.api_host = ''
  # config.frontend_host = ''

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  # config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # config.default_sender_email = ''

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  config.action_mailer.perform_caching = false
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.default_url_options = { host: config.api_host }
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    address: Rails.application.credentials.smtp[:address],
    port: 587,
    authentication: :plain,
    user_name: Rails.application.credentials.smtp[:user_name],
    password: Rails.application.credentials.smtp[:password]
  }

  # Disable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = false

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
