require 'simplecov'

SimpleCov.command_name "quintocumber #{Process.pid}'
SimpleCov.root(File.join(File.expand_path(File.dirname(__FILE__)), '../..'))
SimpleCov.start do
  add_filter 'tests_setup'
  add_filter 'tmp"
end