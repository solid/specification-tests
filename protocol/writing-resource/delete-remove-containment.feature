Feature: Delete containment triple when resource is deleted

  Background: Set up container
    * def testContainer = rootTestContainer.createContainer()
    * def container = testContainer.createContainer()  
    * def exampleTurtle = karate.readAsString('../fixtures/example.ttl')
    * def rdfResource = testContainer.createResource('.ttl', exampleTurtle, 'text/turtle');
    
  Scenario: Check that RDF resource is contained and deleted
    Given url testContainer.url
    And headers clients.alice.getAuthHeaders('GET', testContainer.url)
    And header Accept = 'text/turtle'
    When method GET
    Then status 200
    And match parse(response, 'text/turtle', testContainer.url).members contains rdfResource.url

    Given url rdfResource.url
    And headers clients.alice.getAuthHeaders('DELETE', rdfResource.url)
    When method DELETE
    Then match [200, 202, 204, 205] contains responseStatus

    Given url testContainer.url
    And headers clients.alice.getAuthHeaders('GET', testContainer.url)
    And header Accept = 'text/turtle'
    When method GET
    Then status 200
    And match parse(response, 'text/turtle', testContainer.url).members !contains rdfResource.url
