# frozen_string_literal: true

require 'capybara/rails'
require 'capybara/rspec'
require 'webdrivers/chromedriver'

Capybara.register_driver(:chrome) do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    # Enables access to logs with `page.driver.manage.get_log(:browser)`
    loggingPrefs: {
      browser: 'ALL',
      client: 'ALL',
      driver: 'ALL',
      server: 'ALL'
    }
  )

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('window-size=1920,1080')

  # Run headless by default unless CHROME_HEADLESS specified
  options.add_argument('headless') unless /^(false|no|0)$/.match?(ENV['CHROME_HEADLESS'])

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities,
    options: options
  )
end

Capybara.configure do |config|
  config.default_driver = :chrome
  config.javascript_driver = :chrome
  config.server = :puma, { Silent: true }
end
