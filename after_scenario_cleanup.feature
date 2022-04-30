Feature: Clean up after each scenario

  In this example, we're plugging in a URL ("location") that can be used to delete a token that has been created

  Background: 
    * def authorizationHeader = 'Bearer blahblahblah'
    
  Scenario: Call a cleanup file
    * configure afterScenario = function() { karate.call('classpath:path/to/after_scenario_cleanup.feature@cleanUp', { "location": location }); }
    
  @cleanUp
  Scenario: The clean up commands    
    # Delete the token:
    Given url location
    And header Authorization = authorizationHeader
    And request {}
    When method DELETE
    Then status 204
