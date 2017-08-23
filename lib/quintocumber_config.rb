# frozen_string_literal: true

TEST_BROWSER = ENV['TEST_BROWSER'] || 'chrome'

BUILD = "#{Time.now.utc.iso8601} - #{TEST_BROWSER}"

quintocumber_project_config_filename = File.join(Dir.pwd, './quintocumber.yaml')
quintocumber_config = if File.file?(quintocumber_project_config_filename)
                        YAML.safe_load(
                          File.read(quintocumber_project_config_filename)
                        ) || {}
                      else
                        {}
                      end

quintocumber_config['project'] = quintocumber_config['project'] || {}

PROJECT_NAME = quintocumber_config['project']['name'] || 'UNNAMED PROJECT'
