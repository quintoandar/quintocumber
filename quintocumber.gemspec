# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "quintocumber/version"

Gem::Specification.new do |spec|
  spec.name          = "quintocumber"
  spec.version       = Quintocumber::VERSION
  spec.authors       = ["Diego Queiroz"]
  spec.email         = ["dqueiroz@quintoandar.com.br"]

  spec.summary       = %q{Cucumber on steroids}
  spec.description   = %q{Cucumber with some additional support: Capybara, Browsertack, Allure reports, Rspec and SitePrism}
  spec.homepage      = "https://github.com/quintoandar/quintocumber"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = ["quintocumber"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "cucumber", "~> 2.4"
  spec.add_development_dependency "aruba", "~> 0.7"
  
  spec.add_dependency "cucumber", "~> 2.4"
  spec.add_dependency "rspec", "~> 3.6"
  spec.add_dependency "site_prism", "~> 2.9"
  spec.add_dependency "capybara", "~> 2.14"
  spec.add_dependency "selenium-webdriver", "~> 3.4"
  spec.add_dependency "allure-cucumber", "~> 0.5"
  spec.add_dependency "factory_girl", "~> 4.8"
  spec.add_dependency "faker", "~> 1.8"
  spec.add_dependency "httparty", "~> 0.15"
  spec.add_dependency "aws-sdk", "~> 2.10"
end
