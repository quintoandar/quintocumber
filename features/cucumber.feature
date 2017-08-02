Feature: Cucumber
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