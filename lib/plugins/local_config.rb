# frozen_string_literal: true

Capybara.register_driver :wip do |app|
  test_browser = ENV['TEST_BROWSER'] || 'chrome'
  selenium_server = ENV['SELENIUM_SERVER']
  if selenium_server.nil?
    Capybara::Selenium::Driver.new(app, browser: test_browser.to_sym)
  elsif test_browser == 'headless_chrome':
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: %w(headless disable-gpu) }
      )
    Capybara::Selenium::Driver.new app,
      browser: :remote,
      desired_capabilities: capabilities
  else
    Capybara::Selenium::Driver.new(app, browser: :remote, url: selenium_server, desired_capabilities: test_browser.to_sym)
  end
end
