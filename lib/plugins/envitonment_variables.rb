environments_config_filename = File.join(Dir.pwd, './environments.yaml')
if File.file?(environments_config_filename)
  ENVIRONMENT = YAML.load(File.read(environments_config_filename)).dig(ENV['WHERE'] || 'default') || Hash.new
else
  ENVIRONMENT = Hash.new
end