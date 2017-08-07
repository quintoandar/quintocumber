Feature: Quintocumber config
  In order test software
  As a CLI
  I want to configure my project

  Scenario: Project name is set
    Given a file named "quintocumber.yaml" with:
    """
    project:
      name: Dummy project
    """
    And a file named "features/support/env.rb" with:
    """
      puts PROJECT_NAME
    """
    And a file named "features/sample.feature" with:
    """
      Feature: dummy
      Scenario: dummy
      Given I am a dummy step
    """
    When I run `quintocumber`
    Then the output should contain "Dummy project"
    And the exit status should be 0
    
  Scenario: Config file exists but project name is not set
    Given an empty file named "quintocumber.yaml"
    And a file named "features/support/env.rb" with:
    """
      puts PROJECT_NAME
    """
    And a file named "features/sample.feature" with:
    """
      Feature: dummy
      Scenario: dummy
      Given I am a dummy step
    """
    When I run `quintocumber`
    Then the output should contain "UNNAMED PROJECT"
    And the exit status should be 0
  
  Scenario: Config file doesn't exists

    And a file named "features/support/env.rb" with:
    """
      puts PROJECT_NAME
    """
    And a file named "features/sample.feature" with:
    """
      Feature: dummy
      Scenario: dummy
      Given I am a dummy step
    """
    When I run `quintocumber`
    Then the output should contain "UNNAMED PROJECT"
    And the exit status should be 0