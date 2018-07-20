# frozen_string_literal: true

def get_remote_capabilities(test_browser, window_size)
  if test_browser.eql? 'chrome_headless'
    return Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %W(headless disable-gpu window-size=#{window_size})}
    )
  end
  test_browser.to_sym
end

Capybara.register_driver :wip do |app|
  test_browser = ENV['TEST_BROWSER'] || 'chrome'
  window_size = ENV['TEST_WINDOW_SIZE'] || '1400x900'
  selenium_server = ENV['SELENIUM_SERVER']

  if selenium_server.nil?
    Capybara::Selenium::Driver.new(app, browser: test_browser.to_sym)
  else
    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: selenium_server,
      desired_capabilities: get_remote_capabilities(test_browser, window_size)
    )
  end
end
