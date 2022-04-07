Feature: Build, verify & decode JWTs

This feature file requires a com.auth0:java-jwt dependency
Reference: https://github.com/auth0/java-jwt

  Background: 
    * def Algorithm = Java.type('com.auth0.jwt.algorithms.Algorithm')
    * def JWT = Java.type('com.auth0.jwt.JWT')

  Scenario: Client-side scenario to create & decode a JWT
    # Define an algorithm to use for JWT creation: 
    * def algorithm = Algorithm.HMAC256("secret")
    
    # Create a JWT which will expire in 15 minutes: 
    * def accessToken = JWT.create().withIssuer("Some Issuer").withExpiresAt(new Date(java.lang.System.currentTimeMillis() + 900000)).sign(algorithm)

    # Decode the JWT and grab its expiration
    * def expiration = JWT.decode(accessToken).getExpiresAt().getTime()

  Scenario: Server-side scenario to verify the Authorization header on an incoming request is valid
    * def abortWithResponse =
      """
        function(responseStatus, response) {
          karate.set('responseStatus', responseStatus);
          karate.set('response', response);
          karate.abort();
        }
      """
    * def authorizationHeaderValid =
      """
      function() {
        try {
          var jwt = requestHeaders['authorization'][0].split("Bearer ")[1];
          var verifier = JWT.require(algorithm).withIssuer("FIS").acceptExpiresAt(0).build();
          var decodedJwt = verifier.verify(jwt);
        } catch (e) {
          karate.set('error', e);
          return e.toString();
        }
      }
      """
    * if (authorizationHeaderValid() != null) abortWithResponse(401, 'There is an issue with your JWT: ' + authorizationHeaderValid().toString())
