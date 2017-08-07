# frozen_string_literal: true

environments_config_filename = File.join(Dir.pwd, './environments.yaml')
if File.file?(environments_config_filename)
  ENVIRONMENT = YAML.safe_load(File.read(environments_config_filename)).dig(ENV['WHERE'] || 'default') || {}
else
  ENVIRONMENT = {}.freeze
end
