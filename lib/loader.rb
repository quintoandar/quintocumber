# frozen_string_literal: true

require_relative 'env'

require_relative 'quintocumber_config'

Dir[File.join(File.dirname(__FILE__), 'plugins/**/*.rb')].each do |file|
  require file
end

Dir[File.join(Dir.pwd, 'features/support/**/*.rb')].each do |file|
  require file
end

Dir[File.join(Dir.pwd, 'features/**/*.rb')].each do |file|
  require file
end
