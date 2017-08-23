# frozen_string_literal: true

environments_config_filename = File.join(Dir.pwd, './environments.yaml')
ENVIRONMENT = if File.file?(environments_config_filename)
                YAML.safe_load(
                  File.read(environments_config_filename), [], [], true
                ).dig(ENV['WHERE'] || 'default').freeze || {}.freeze
              else
                {}.freeze
              end
