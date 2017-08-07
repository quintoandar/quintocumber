# frozen_string_literal: true

Capybara.register_driver :wip do |app|
  test_browser = ENV['TEST_BROWSER'] || 'firefox'
  Capybara::Selenium::Driver.new(app, browser: test_browser.to_sym)
end
