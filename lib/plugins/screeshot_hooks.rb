AfterConfiguration do |config|
  config.on_event :after_test_step do |event|
    if !ENV['DISABLE_REPORTS_SCREENSHOT'] && !event.result.ok?
      filename = "#{event.test_case.name}/#{event.test_step.name}.png"
      Capybara.page.save_screenshot(filename)
      class Includer 
        extend AllureCucumber::DSL
      end
      Includer.attach_file(filename, File.open(File.join(Dir.pwd, Capybara.save_path, "#{filename}")))
    end
  end
end