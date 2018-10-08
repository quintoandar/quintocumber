# frozen_string_literal: true

require 'capybara/cucumber'
require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

# Get browserstack configuration from browserstack.yml
# and override credentials if credentials are set in env variables
browserstack_default_config = YAML.safe_load(
  File.read(File.join(File.dirname(__FILE__), './browserstack.yml'))
)

browserstack_project_config_filename = File.join(Dir.pwd, './browserstack.yml')
if File.file?(browserstack_project_config_filename)
  browserstack_project_config = YAML.safe_load(
    File.read(browserstack_project_config_filename)
  ) || {}
else
  browserstack_project_config = {}
end

browserstack_config = browserstack_default_config.merge(
  browserstack_project_config
)

browserstack_config['user'] = ENV['BROWSERSTACK_USERNAME'] ||
                              browserstack_config['user']
browserstack_config['key'] = ENV['BROWSERSTACK_ACCESS_KEY'] ||
                             browserstack_config['key']

# Only user browserstack if credentials are set
if browserstack_config['user'] && browserstack_config['key']
  # Register browserstack remote driver into Capybara context
  Capybara.register_driver :browserstack do |app|
    # check if target browser is properly configured in browsertack.yaml
    # if no target browser is defined, skip verification due to later override
    if ENV['TEST_BROWSER'] &&
       browserstack_config['browser_caps'][ENV['TEST_BROWSER']].nil?
      raise 'Remote browser not configured in browsertack.yaml'
    end

    # merge common capabilities and browser capabilities
    # (if not browser is set, deafults to chrome)
    browserstack_config['common_caps'] = browserstack_config['common_caps'] ||
                                         {}

    # Using local browserstack according to env var
    if ENV['BROWSERSTACK_LOCAL'] && ENV['BROWSERSTACK_LOCAL'].to_s  == 'true'
      browserstack_config['common_caps']['browserstack.local'] = true
    end

    @caps = browserstack_config['common_caps'].merge(
      browserstack_config['browser_caps'][TEST_BROWSER]
    )

    # sets timestamp as build name along with target browser
    @caps['build'] = BUILD

    # sets project name
    @caps['project'] = PROJECT_NAME

    logger.info("Instanciate new remote browser with desired caps: %s" % @caps)
    # all set, instanciate new remote browser
    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: "http://#{browserstack_config['user']}" \
      ":#{browserstack_config['key']}@" \
      "#{browserstack_config['server']}/wd/hub",
      desired_capabilities: @caps
    )
  end

  # set browserstack as default browser
  Capybara.default_driver = :browserstack
end

# Re-register browserstack remote browser before each scenario run to ensure
# browserstack will receive scenario name as test name
Before do |scenario|
  # Only re-register if browserstack is the current driver
  if Capybara.current_driver == :browserstack

    # Get current options to override later
    opts = Capybara.current_session.driver.options

    # Put scenario name on options
    opts[:desired_capabilities] = opts[:desired_capabilities].merge(
      'name' => scenario.name
    )

    # Ensure Capybara will get the most recent driver registered
    # (Kinda MAGIC; don't touch)
    Capybara.current_driver = :browserstack
  end
end
