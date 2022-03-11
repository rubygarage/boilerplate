# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors
ALLOWED_METHODS = %i[get post put patch delete options head].freeze

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(
      /\Ahttp:\/\/localhost(:\d+)?\z/,
      /\Ahttp:\/\/127\.0\.0\.1(:\d+)?\z/
    )
    resource('*', headers: :any, methods: ALLOWED_METHODS, expose: ['Content-Disposition'])
  end
end
