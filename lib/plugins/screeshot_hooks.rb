# frozen_string_literal: true

# Using temp class to avoid conflict with Capybara.attach_file
class AllureCucumberDSLTemp
  extend AllureCucumber::DSL
end

AfterConfiguration do |config|
  config.on_event :after_test_step do |event|
    if !ENV['DISABLE_REPORTS_SCREENSHOT'] && !event.result.ok?
      filename = "#{event.test_case.name}/#{event.test_step.name}.png"
      Capybara.page.save_screenshot(filename)
      AllureCucumberDSLTemp.attach_file(
        filename,
        File.open(File.join(Dir.pwd, Capybara.save_path, filename.to_s))
      )
    end
  end
end
