# frozen_string_literal: true

Capybara.register_driver :wip do |app|
  test_browser = ENV['TEST_BROWSER'] || 'firefox'
  selenium_server = ENV['SELENIUM_SERVER']
  if selenium_server == "":
    Capybara::Selenium::Driver.new(app, browser: test_browser.to_sym)
  else
    Capybara::Selenium::Driver.new(app, browser: remote, url: selenium_server, desired_capabilities: browser)
  end
end
