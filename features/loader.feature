Feature: Ruby loader
  In order test software
  As a CLI
  I want to load .rb files

  Scenario: Load support folder first
    Given a file named "features/dummy/dummy.rb" with:
    """
      puts "dummy.rb loaded"
    """
    And a file named "features/support/env.rb" with:
    """
      puts "env.rb loaded"
    """
    And a file named "features/sample.feature" with:
    """
      Feature: dummy
      Scenario: dummy
      Given I am a dummy step
    """
    When I run `quintocumber`
    Then the output should contain "env.rb loaded\ndummy.rb loaded"
    And the exit status should be 0