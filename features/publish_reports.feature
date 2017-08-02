Feature: Publish reports
  In order test software
  As a CLI
  I want to publish reports after test
    
  Scenario: Generate allure report and send to s3
  Given a file named "features/sample.feature" with:
  """
    Feature: dummy
    Scenario: dummy
    Given I am a dummy step
  """
  Given I set the environment variables to:
          | variable         | value |
          | REPORT_BUCKET    | dummy |
  When I run `quintocumber`
  Then the output should contain "Generating allure report and uploading to s3"
  
  Scenario: Reporting test failed to pagerduty
  Given a file named "features/sample.feature" with:
  """
    Feature: dummy
    Scenario: dummy
    Given I am a dummy failed step
  """
      
  And a file named "features/step_definitions/steps.rb" with:
  """
    Given(/^I am a dummy failed step$/) do
      expect(1).to eq 0
    end
  """
  
  And  I set the environment variables to:
          | variable                   | value |
          | PAGERDUTY_ROUTING_KEY      | dummy |  
          | DISABLE_REPORTS_SCREENSHOT | true  |
          
  When I run `quintocumber`
  Then the output should contain "Sending test failed alert to PagerDuty"
  
  Scenario: Not reporting all test passed to pagerduty
  Given a file named "features/sample.feature" with:
  """
    Feature: dummy
    Scenario: dummy
    Given I am a dummy step
  """
      
  And a file named "features/step_definitions/steps.rb" with:
  """
    Given(/^I am a dummy step$/) do
    end
  """
  Given I set the environment variables to:
          | variable              | value |
          | PAGERDUTY_ROUTING_KEY | dummy |
  When I run `quintocumber`
  Then the output should not contain "Sending test failed alert to PagerDuty"
    