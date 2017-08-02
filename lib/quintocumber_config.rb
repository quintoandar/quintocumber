TEST_BROWSER = ENV['TEST_BROWSER'] || 'chrome'

BUILD = "#{Time.now.utc.iso8601} - #{TEST_BROWSER}"

quintocumber_project_config_filename = File.join(Dir.pwd, "./quintocumber.yaml")
if File.file?(quintocumber_project_config_filename)
  quintocumber_config = YAML.load(File.read(quintocumber_project_config_filename)) || Hash.new
else
  quintocumber_config = Hash.new
end

quintocumber_config['project'] = quintocumber_config['project'] || {}

PROJECT_NAME = quintocumber_config['project']['name'] || "UNNAMED PROJECT"