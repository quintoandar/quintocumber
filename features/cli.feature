Feature: Cli
  In order test software
  As a CLI
  I want to run quintocumber

  Scenario: Run without features files
    When I run `quintocumber`
    Then the output should contain "No such file or directory - features. You can use `cucumber --init` to get started."
    And the exit status should not be 0

  Scenario: Run with tag
    Given a file named "features/sample.feature" with:
    """
      Feature: dummy
      @wip
      Scenario: dummy
      Given I am a dummy step
    """
    
    When I run `quintocumber --tags @wip`
    Then the output should contain "1 scenario (1 undefined)"
    And the exit status should be 0
    
  Scenario: Run excluding tag
    Given a file named "features/sample.feature" with:
    """
      Feature: dummy
      @wip
      Scenario: dummy
      Given I am a dummy step
    """
    
    When I run `quintocumber --tags ~@wip`
    Then the output should contain "0 scenarios\n0 steps\n0m0.000s\n"
    And the exit status should be 0
    
  Scenario: Generate report
    Given a file named "features/sample.feature" with:
    """
      Feature: dummy
      @wip
      Scenario: dummy
      Given I am a dummy step
    """
      
    When I run `quintocumber`
    And I run `ls reports`
    Then the output should contain "testsuite.xml"
    And the exit status should be 0
    
  Scenario: Take screenshot
    Given a file named "features/sample.feature" with:
    """
      Feature: dummy
      @wip
      Scenario: dummy
      Given I am a dummy failed step
    """
        
    And a file named "features/step_definitions/steps.rb" with:
    """
    Given(/^I am a dummy failed step$/) do
      expect(1).to eq 0
    end
    """
    
    When I run `quintocumber`
    And I run `ls screenshots/dummy`
    Then the output should contain "I am a dummy failed step.png"
    And the exit status should be 0
    
  Scenario: Generate allure report and send to s3
  Given a file named "features/sample.feature" with:
  """
    Feature: dummy
    Scenario: dummy
    Given I am a dummy failed step
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
  Given I set the environment variables to:
          | variable              | value |
          | PAGERDUTY_ROUTING_KEY | dummy |
  When I run `quintocumber`
  Then the output should contain "Sending test failed alert to PagerDuty"
  
  Scenario: Not reporting all test passed to pagerduty
  Given a file named "features/sample.feature" with:
  """
    Feature: dummy
    Scenario: dummy
    Given I am a dummy failed step
  """
      
  And a file named "features/step_definitions/steps.rb" with:
  """
    Given(/^I am a dummy failed step$/) do
    end
  """
  Given I set the environment variables to:
          | variable              | value |
          | PAGERDUTY_ROUTING_KEY | dummy |
  When I run `quintocumber`
  Then the output should not contain "Sending test failed alert to PagerDuty"
    