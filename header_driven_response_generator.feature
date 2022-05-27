Feature: Server-side file to grab a request header and use it to vary the response sent back

  Scenario: 
    * def correlationId = karate.get("requestHeaders['x-wp-correlationid'][0]")
    * if (karate.match("correlationId contains 'someValue'").pass == true) karate.set('someVar', 'someValue')
    * if (karate.match("correlationId contains 'someOtherValue'").pass == true) karate.set('someVar', 'someOtherValue')

    * def responseHeaders = { 'X-WP-CorrelationId': '#(correlationId)' }
    * def responseStatus = 200
    * def response = { "someVar": "#(someVar)" }
