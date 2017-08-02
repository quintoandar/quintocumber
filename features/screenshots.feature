Feature: Screenshots
  In order test software
  As a CLI
  I want to take browser screenshots
    
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
    
  Scenario: Disable screenshots
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
    
    And I set the environment variables to:
      | variable                   | value |
      | DISABLE_REPORTS_SCREENSHOT | true  |
    
    When I run `quintocumber`
    And I run `ls screenshots/dummy`
    Then the output should contain "ls: screenshots/dummy: No such file or directory"
    And the exit status should be 1
    