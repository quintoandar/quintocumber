require 'capybara/cucumber'

#Get browserstack configuration from browserstack.yml 
#and override credentials if credentials are set in env variables
BROWSERSTACK_DEFAULT_CONFIG = YAML.load(File.read(File.join(File.dirname(__FILE__), "./browserstack.yml")))
BROWSERSTACK_PROJECT_CONFIG = YAML.load(File.read(File.join(Dir.pwd, "./browserstack.yml"))) || Hash.new

BROWSERSTACK_CONFIG = BROWSERSTACK_DEFAULT_CONFIG.merge(BROWSERSTACK_PROJECT_CONFIG)

BROWSERSTACK_CONFIG['user'] = ENV['BROWSERSTACK_USERNAME'] || BROWSERSTACK_CONFIG['user']
BROWSERSTACK_CONFIG['key'] = ENV['BROWSERSTACK_ACCESS_KEY'] || BROWSERSTACK_CONFIG['key']

#Only user browserstack if credentials are set
if BROWSERSTACK_CONFIG['user'] && BROWSERSTACK_CONFIG['key']
  #Register browserstack remote driver into Capybara context
  Capybara.register_driver :browserstack do |app|

    #check if target browser is properly configured in browsertack.yaml
    #if no target browser is defined, skip verification due to later override
    if ENV['TEST_BROWSER'] && BROWSERSTACK_CONFIG['browser_caps'][ENV['TEST_BROWSER']].nil?
      raise 'Remote browser not configured in browsertack.yaml'
    end

    test_browser = ENV['TEST_BROWSER'] || 'chrome'

    #merge common capabilities and browser capabilities (if not browser is set, deafults to chrome)
    @caps = BROWSERSTACK_CONFIG['common_caps'].merge(BROWSERSTACK_CONFIG['browser_caps'][test_browser])

    #sets timestamp as build name along with target browser
    @caps['build'] = "#{Time.now.utc.iso8601} - #{test_browser}"

    #all set, instanciate new remote broser
    Capybara::Selenium::Driver.new(app,
      :browser => :remote,
      :url => "http://#{BROWSERSTACK_CONFIG['user']}:#{BROWSERSTACK_CONFIG['key']}@#{BROWSERSTACK_CONFIG['server']}/wd/hub",
      :desired_capabilities => @caps
    )
  end
  
  #set browserstack as default browser
  Capybara.default_driver = :browserstack
end


#Re-register browserstack remote browser before each scenario run to ensure 
#browserstack will receive scenario name as test name
Before do |scenario|

  #Only re-register if browserstack is the current driver
  if Capybara.current_driver == :browserstack

    #Get current options to override later
    opts = Capybara.current_session.driver.options

    #Put scenario name on options
    opts[:desired_capabilities] = opts[:desired_capabilities].merge({"name" => scenario.name})

    #Re-register browserstack with new options
    Capybara.register_driver :browserstack do |app|
      Capybara::Selenium::Driver.new(app, opts)
    end

    #Ensure Capybara will get the most recent driver registered (Kinda MAGIC; don't touch)
    Capybara.current_driver = :browserstack
  end
end

