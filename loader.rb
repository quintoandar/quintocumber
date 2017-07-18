require_relative "env"

Dir[File.join(File.dirname(__FILE__), "config/**/*.rb")].each do |file|
  require file 
end

Dir[File.join(Dir.pwd, "features/**/*.rb")].each do |file|
  require file 
end
