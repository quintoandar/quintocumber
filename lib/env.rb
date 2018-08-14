# frozen_string_literal: true

require 'rubygems'
require 'selenium/webdriver'
require 'rspec'
require 'capybara/cucumber'
require 'site_prism'
require 'allure-cucumber'
require 'rspec/expectations'

Capybara.default_max_wait_time = 10
Capybara.save_path = 'screenshots/'

After do |_scenario|
  Capybara.current_session.driver.quit
end

Capybara.default_driver = :wip

Cucumber::Core::Test::Step.module_eval do
  def name
    return text if self.text == 'Before hook'
    return text if self.text == 'After hook'
    "#{source.last.keyword}#{text}"
  end
end
