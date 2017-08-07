Feature: Browserstack remote browser
  In order test software
  As a CLI
  I want to run my tests on Browserstack

  Scenario: Browserstack credentials exists but no config file is set
    Given a file named "features/sample.feature" with:
    """
      Feature: dummy
      @browserstack
      Scenario: dummy
      Given I am a dummy step
    """
    And a file named "features/steps.rb" with:
    """
      Given(/^I am a dummy step$/) do
        visit "https://google.com"
      end
    """
    And  I set the environment variables to:
            | variable                   | value |
            | BROWSERSTACK_USERNAME      | dummy |  
            | BROWSERSTACK_ACCESS_KEY    | dummy |
            | DISABLE_REPORTS_SCREENSHOT | true  |
            
    When I run `quintocumber`
    And the exit status should be 0
    
    
  Scenario: Browserstack credentials exists and config file
    Given a file named "features/sample.feature" with:
    """
      Feature: dummy
      @browserstack
      Scenario: dummy
      Given I am a dummy step
    """
    Given a file named "browserstack.yml" with:
    """
    """
    And a file named "features/steps.rb" with:
    """
      Given(/^I am a dummy step$/) do
        visit "https://google.com"
      end
    """
    And  I set the environment variables to:
            | variable                   | value |
            | BROWSERSTACK_USERNAME      | dummy |  
            | BROWSERSTACK_ACCESS_KEY    | dummy |
            | DISABLE_REPORTS_SCREENSHOT | true  |
            
    When I run `quintocumber`
    And the exit status should be 0
    
    
  Scenario: Browserstack remote browser is not properly configured
    Given a file named "features/sample.feature" with:
    """
      Feature: dummy
      @browserstack
      Scenario: dummy
      Given I am a dummy step
    """
    And a file named "features/steps.rb" with:
    """
      Given(/^I am a dummy step$/) do
        visit "https://google.com"
      end
    """
    And  I set the environment variables to:
            | variable                   | value |
            | BROWSERSTACK_USERNAME      | dummy |  
            | BROWSERSTACK_ACCESS_KEY    | dummy |
            | DISABLE_REPORTS_SCREENSHOT | true  |
            | TEST_BROWSER               | dummy |
            
    When I run `quintocumber`
    Then the output should contain "Remote browser not configured in browsertack.yaml"
    And the exit status should be 1
    
  Scenario: Re-register browserstack after step
    Given a file named "features/sample.feature" with:
    """
      Feature: dummy
      @browserstack
      Scenario: dummy
      Given I am a dummy step
  
      @browserstack
      Scenario: dummy 2
      Given I am a dummy step
    """
    And a file named "features/steps.rb" with:
    """
      Given(/^I am a dummy step$/) do
        visit "https://google.com"
      end
    """
    And  I set the environment variables to:
            | variable                   | value |
            | BROWSERSTACK_USERNAME      | dummy |  
            | BROWSERSTACK_ACCESS_KEY    | dummy |
            | DISABLE_REPORTS_SCREENSHOT | true  |
            
    When I run `quintocumber`
    Then the exit status should be 0