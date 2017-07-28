TEST_BROWSER = ENV['TEST_BROWSER'] || 'chrome'

BUILD = "#{Time.now.utc.iso8601} - #{TEST_BROWSER}"

quintocumber_project_config_filename = File.join(Dir.pwd, "./quintocumber.yaml")
if File.file?(quintocumber_project_config_filename)
  QUINTOCUMBER_CONFIG = YAML.load(File.read(quintocumber_project_config_filename)) || Hash.new
else
  QUINTOCUMBER_CONFIG = Hash.new
end

QUINTOCUMBER_CONFIG['project'] = QUINTOCUMBER_CONFIG['project'] || {}

PROJECT_NAME = QUINTOCUMBER_CONFIG['project']['name'] || "UNNAMED PROJECT"