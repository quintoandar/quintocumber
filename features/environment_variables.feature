Feature: Environment variables
  In order test software
  As a CLI
  Set different variables to different environments
  
  Scenario: Load variables for specific environment
  Given a file named "features/support/env.rb" with:
  """
    puts "Dummy value: #{ENVIRONMENT['dummy']}"
  """
  Given a file named "environments.yaml" with:
  """
    production:
      dummy: dummy_value
  """
  And I set the environment variables to:
          | variable | value      |
          | WHERE    | production |
  When I run `quintocumber`
  Then the output should contain "Dummy value: dummy_value"
  
  Scenario: Load default variables
  Given a file named "features/support/env.rb" with:
  """
    puts "Dummy value: #{ENVIRONMENT['dummy']}"
  """
  Given a file named "environments.yaml" with:
  """
    production: &default
      dummy: dummy_value
    default: *default
  """
  When I run `quintocumber`
  Then the output should contain "Dummy value: dummy_value"
  
  Scenario: Environment variables file not set
  Given a file named "features/support/env.rb" with:
  """
    puts "Dummy value: #{ENVIRONMENT}"
  """
  When I run `quintocumber`
  Then the output should contain "Dummy value: {}"