require 'cucumber/cli/main'

loader_file = File.join(File.dirname(__FILE__), 'loader.rb')

args = "--verbose --require #{loader_file}".split(/\s+/)

Cucumber::Cli::Main.new(args).execute!