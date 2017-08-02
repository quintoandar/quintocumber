Feature: Allure formatter
  In order test software
  As a CLI
  I want to generate allure formated output

  Scenario: Generate allure formated output
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