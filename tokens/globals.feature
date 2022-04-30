Feature: Global variables & functions

  Scenario:
    * def abortWithResponse =
      """
        function(responseStatus, response) {
          var uuid = java.util.UUID.randomUUID() + '';
          karate.set('responseHeaders', { 'X-WP-Diagnostics-CorrelationId': uuid });
          karate.set('responseStatus', responseStatus);
          karate.set('response', response);
          karate.abort();
        }
      """
    * def expiryMonth =
      """
        function() {
          var someArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
          var randomMonth = someArray[Math.floor(Math.random() * someArray.length)];
          return(randomMonth);
        }
      """
    * def expiryYear =
      """
        function(addYears) {
          var date = new Date().getFullYear();
          var newDate = parseInt(date) + addYears;
          var output = newDate;
          return(output);
        }
      """
    * def isValidCardNumber =
      """
      function(value) {
        if (!value) return false;
        var nCheck = 0, nDigit = 0, bEven = false;
        value = value.replace(/\D/g, "");
        for (var n = value.length - 1; n >= 0; n--) {
            var cDigit = value.charAt(n),
                nDigit = parseInt(cDigit, 10);
            if (bEven) {
                if ((nDigit *= 2) > 9) nDigit -= 9;
            }
            nCheck += nDigit;
            bEven = !bEven;
        }
        return (nCheck % 10) == 0;
      }
      """
    * def isValidMonth =
      """
      function(MM) {
        return (MM == "01" || MM == "02" || MM == "03" || MM == "04" || MM == "05" || MM == "06" ||
                MM == "07" || MM == "08" || MM == "09" || MM == "10" || MM == "11" || MM == "12");
      }
      """
    * def isValidYear =
      """
        function(YYYY) {
          var date = new Date().getFullYear();
          return(YYYY >= date);
        }
      """
    * def randomNumber =
      """
        function(length) {
          var result = '';
          var characters = '0123456789';
          var charactersLength = characters.length;
          for ( var i = 0; i < length; i++ ) {
            result += characters.charAt(Math.floor(Math.random() * charactersLength));
          }
          return result;
        }
      """
    * def stripFirstSix =
      """
        function(x) {
          var firstSix = x.substring(0, 6);
          return firstSix;
        }
      """
    * def stripLastFour =
      """
        function(x) {
          var lastFour = x.substr(x.length - 4);
          return lastFour;
        }
      """
    * def timeOfRequest = function() { return java.lang.System.currentTimeMillis() + '' }
    * def uuid = function() { return java.util.UUID.randomUUID() + '' }

    # JWT variables (reference: https://github.com/auth0/java-jwt):
    * def Algorithm = Java.type('com.auth0.jwt.algorithms.Algorithm')
    * def algorithm = Algorithm.HMAC256("secret")
    * def JWT = Java.type('com.auth0.jwt.JWT')

    # Header check functions:
#    * def correlationIdHeaderPresent = function() { return karate.match("requestHeaders['x-wp-diagnostics-correlationid'] == '#present'").pass }
#    * def callerIdHeaderPresent = function() { return karate.match("requestHeaders['x-wp-diagnostics-callerid'] == '#present'").pass }
#    * def timestampHeaderPresent = function() { return karate.match("requestHeaders['x-wp-timestamp'] == '#present'").pass }
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
