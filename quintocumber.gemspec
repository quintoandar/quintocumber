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
  spec.description   = %q{Cucumber with some additional support: Capybara, Browsertack and Allure reports}
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
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  
  spec.add_dependency "cucumber"
  spec.add_dependency "rspec"
  spec.add_dependency "site_prism"
  spec.add_dependency "capybara"
  spec.add_dependency "selenium-webdriver"
  spec.add_dependency "allure-cucumber"
  spec.add_dependency "capybara-screenshot"
  spec.add_dependency "browserstack-local"
end
