require 'rubygems'
require 'selenium/webdriver'
require 'rspec'
require 'capybara/cucumber'
require 'site_prism'
require 'allure-cucumber'
require 'rspec/expectations'
require 'factory_girl'

Capybara.default_max_wait_time = 10
Capybara.save_path = 'screenshots/'

After do |scenario|
  Capybara.current_session.driver.quit()
end

Capybara.default_driver = :wip
