Feature: Token Provider

  This file can be launched as a server, e.g.:

      mvn test-compile exec:java -Dexec.mainClass=com.intuit.karate.Main -Dexec.classpathScope=test -Dexec.args="-m src/test/java/token_provider.feature -p 8080"
      
  Background:
    # Fetch global variables & functions
    * call read('globals.feature')

    # Set global configs:
    * configure cors = true
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true

########################################################################################################################
### Server-Side Response Scenarios #####################################################################################
########################################################################################################################

  # Response for login requests:
  Scenario: pathMatches('/login') && methodIs('post')
    # Verify the request conforms to a schema & fail if not:
    * def loginRequest = request
    * call read('errors.feature@authErrors') { loginRequest: '#(loginRequest)' }

    # Determine if errors need to be included on the response:
    * if ((loginRequest.userId == null || loginRequest.userId == '') && (request.secret == null || request.secret == '')) abortWithResponse(422, errorResponse)
    * if (loginRequest.userId == null || loginRequest.userId == '') abortWithResponse(422, errorResponse)
    * if (loginRequest.secret == null || loginRequest.secret == '') abortWithResponse(422, errorResponse)
    * if (loginRequest.userId == '00000000-0000-0000-0000-000000000000' || loginRequest.secret == 'invalid') abortWithResponse(401, errorResponse)
    * if (loginRequest.userId == '99999999-9999-9999-9999-999999999999' || loginRequest.secret == 'unauthorized') abortWithResponse(403, errorResponse)
    * def isValidUserId = karate.match("loginRequest.userId == '#uuid'")
    * if (isValidUserId.pass == false) abortWithResponse(422, errorResponse)

    # Define values for non-error fields:
    * call read('errors.feature@modifyAuth')

    # Respond:
    * def accessToken = JWT.create().withIssuer("FIS").withExpiresAt(new Date(java.lang.System.currentTimeMillis() + 900000)).sign(algorithm)
    * def expirationInMillis = JWT.decode(accessToken).getExpiresAt().getTime()
    * def expiration = new java.math.BigDecimal(expirationInMillis/1000)
    * def responseHeaders = { 'CorrelationId': '#(uuid())' }
    * def responseStatus = 200
    * def response =
      """
      {
        "statusCode": "##(status)",
        "errors": "##(errors)",
        "accessToken": "##(accessToken)",
        "expiration": ##(expiration)
      }
      """

  # Response for get token requests:
  Scenario: pathMatches('/GetToken') && methodIs('post')
    # Verify the Authorization header contains a valid JWT:
    * if (authorizationHeaderValid() != null) abortWithResponse(401, 'There is an issue with your JWT: ' + authorizationHeaderValid().toString())

    # Verify the request conforms to a schema & fail if not:
    * def getByTokenIdSchema =
      """
      {
        "tokenId": "#string? _.length >= 1",
        "includeCryptogram": "#boolean",
        "cryptogramTransactionType": "##string"
      }
      """
    * def isValidGetTokenSchema = function() { return karate.match(request, getTokenSchema).pass }
    * def actualVsExpected = karate.match(request, getTokenSchema).message
    * if (isValidGetTokenSchema() == false) abortWithResponse(400, actualVsExpected)

    # Determine, based on correlationId, if errors need to be included on the response:
    * def correlationId = karate.get("requestHeaders['correlationid'][0]")
    * call read('errors.feature@addErrors') { correlationId: '#(correlationId)' }
    * if (correlationId == 'ERROR_400_CODE_200') abortWithResponse(400, errorResponse)
    * if (correlationId == 'ERROR_401_CODE_200') abortWithResponse(401, errorResponse)
    * if (correlationId == 'ERROR_401_CODE_201') abortWithResponse(401, errorResponse)
    * if (correlationId == 'ERROR_422_CODE_200') abortWithResponse(422, errorResponse)
    * if (correlationId == 'ERROR_400_CODES_208_AND_209') abortWithResponse(400, errorResponse)
    * if (correlationId == 'ERROR_422_CODES_208_AND_209') abortWithResponse(422, errorResponse)

    # Define values for non-error fields (including provisioningError fields):
    * call read('errors.feature@modifyGetToken') { correlationId: '#(correlationId)' }

    # Determine, based on includeCryptogram, if cryptogram information needs to be removed from the response:
    * if (request.includeCryptogram == false) karate.set('cryptogramDetails', null)

    # Respond:
    * if (correlationId == null) karate.set('correlationId', uuid())
    * def responseHeaders = { 'CorrelationId': '#(correlationId)' }
    * def responseStatus = 200
    * def response =
      """
      {
        "statusCode": "#(statusCode)",
        "errors": "##(errors)",
        "tokenDetails": "##(tokenDetails)",
        "paymentAccountDetails": "##(paymentAccountDetails)",
        "provisioningErrors": "##(provisioningErrors)",
        "cryptogramDetails": "##(cryptogramDetails)"
      }
      """

  # Response for create token requests:
  Scenario: pathMatches('/CreateToken') && methodIs('post')
    # Verify the Authorization header contains a valid JWT:
    * if (authorizationHeaderValid() != null) abortWithResponse(401, 'There is an issue with your JWT: ' + authorizationHeaderValid().toString())

    # Define create token schema objects:
    * def accountHolderDetails = { "name": "##string" }
    * def addressDetails =
      """
      {
        "line1": "##string",
        "line2": "##string",
        "line3": "##string",
        "line4": "##string",
        "line5": "##string",
        "city": "##string",
        "countrySubdivision": "##string",
        "country": "##string",
        "postalCode": "##string"
      }
      """
    * def cardDetails =
      """
      {
        "accountNumber": "#? isValidCardNumber(_)",
        "expirationDate": {
          "month": "#? isValidMonth(_)",
          "year": "#? isValidYear(_)"
        },
        "cvv2": "##string? _.length >= 2 && _.length < 4"
      }
      """

    # Verify the request conforms to a schema & fail if not:
    * def createTokenSchema =
      """
      {
        "tokenProviderProfileId": "#string? _.length >= 1",
        "cardDetails": "#(cardDetails)",
        "accountHolderDetails": "##(accountHolderDetails)",
        "addressDetails": "##(addressDetails)",
        "includePar": "#boolean"
      }
      """
    * def isValidCreateTokenSchema = function() { return karate.match(request, createTokenSchema).pass }
    * def actualVsExpected = karate.match(request, createTokenSchema).message
    * if (isValidCreateTokenSchema() == false) abortWithResponse(400, actualVsExpected)

    # Determine, based on correlationId, if errors need to be included on the response:
    * def correlationId = karate.get("requestHeaders['correlationid'][0]")
    * call read('errors.feature@addErrors') { correlationId: '#(correlationId)' }
    * if (correlationId == 'ERROR_400_CODE_200') abortWithResponse(400, errorResponse)
    * if (correlationId == 'ERROR_401_CODE_200') abortWithResponse(401, errorResponse)
    * if (correlationId == 'ERROR_401_CODE_201') abortWithResponse(401, errorResponse)
    * if (correlationId == 'ERROR_422_CODE_200') abortWithResponse(422, errorResponse)
    * if (correlationId == 'ERROR_400_CODES_208_AND_209') abortWithResponse(400, errorResponse)
    * if (correlationId == 'ERROR_422_CODES_208_AND_209') abortWithResponse(422, errorResponse)

    # Define values for non-error fields:
    * def createRequest = request
    * call read('errors.feature@modifyCreateToken') { correlationId: '#(correlationId)', createRequest: '#(createRequest)' }

    # Determine, based on correlationId, if token details need to be removed from the response:
    * def removeFields = karate.match("correlationId contains 'NO_TOKEN'").pass
    * if (removeFields == true) karate.set('tokenDetails', null)

    # Respond:
    * if (correlationId == null) karate.set('correlationId', uuid())
    * def responseHeaders = { 'CorrelationId': '#(correlationId)' }
    * def responseStatus = 200
    * def response =
      """
      {
        "statusCode": "#(statusCode)",
        "errors": "##(errors)",
        "tokenDetails": "##(tokenDetails)",
        "paymentAccountDetails": "##(paymentAccountDetails)",
        "provisionDetails": "##(provisionDetails)"
      }
      """

  # Response for create cryptogram requests:
  Scenario: pathMatches('/CreateCryptogram') && methodIs('post')
    # Verify the Authorization header contains a valid JWT:
    * if (authorizationHeaderValid() != null) abortWithResponse(401, 'There is an issue with your JWT: ' + authorizationHeaderValid().toString())

    # Verify the request conforms to a schema & fail if not:
    * def createCryptogramSchema =
      """
      {
        "tokenProviderProfileId": "#string? _.length >= 1",
        "networkToken": "#regex ^\\d+$",
        "transactionType": "##string"
      }
      """
    * def isValidCreateCryptogramSchema = function() { return karate.match(request, createCryptogramSchema).pass }
    * def actualVsExpected = karate.match(request, createCryptogramSchema).message
    * if (isValidCreateCryptogramSchema() == false) abortWithResponse(400, actualVsExpected)

    # Determine, based on correlationId, if errors need to be included on the response:
    * def correlationId = karate.get("requestHeaders['correlationid'][0]")
    * call read('errors.feature@addErrors') { correlationId: '#(correlationId)' }
    * if (correlationId == 'ERROR_400_CODE_200') abortWithResponse(400, errorResponse)
    * if (correlationId == 'ERROR_401_CODE_200') abortWithResponse(401, errorResponse)
    * if (correlationId == 'ERROR_401_CODE_201') abortWithResponse(401, errorResponse)
    * if (correlationId == 'ERROR_422_CODE_200') abortWithResponse(422, errorResponse)
    * if (correlationId == 'ERROR_400_CODES_208_AND_209') abortWithResponse(400, errorResponse)
    * if (correlationId == 'ERROR_422_CODES_208_AND_209') abortWithResponse(422, errorResponse)

    # Define values for non-error fields:
    * call read('errors.feature@modifyCreateCryptogram') { correlationId: '#(correlationId)' }

    # Respond:
    * if (correlationId == null) karate.set('correlationId', uuid())
    * def responseHeaders = { 'CorrelationId': '#(correlationId)' }
    * def responseStatus = 200
    * def response =
      """
      {
        "statusCode": "##(statusCode)",
        "errors": "##(errors)",
        "cryptogramDetails": "##(cryptogramDetails)"
      }
      """

  # Response for an invalid path:
  Scenario: !pathMatches('/login') && !pathMatches('/GetToken') && !pathMatches('/CreateToken') && !pathMatches('/CreateCryptogram')
    * abortWithResponse(404, 'Invalid path')

  # Response for an invalid method:
  Scenario: pathMatches('/login') && !methodIs('post') || pathMatches('/GetToken') && !methodIs('post') || pathMatches('/CreateToken') && !methodIs('post') || pathMatches('/CreateCryptogram') && !methodIs('post')
    * abortWithResponse(405, 'Invalid method')

  # Catch all scenario:
  Scenario:
#    * if (correlationIdHeaderPresent() == false) abortWithResponse(401, 'CorrelationId header is missing\n')
#    * if (callerIdHeaderPresent() == false) abortWithResponse(401, 'CallerId header is missing\n')
#    * if (timestampHeaderPresent() == false) abortWithResponse(401, 'Timestamp header is missing\n')
    * def response = "Your request is invalid\n"
    * def responseStatus = 500

########################################################################################################################
### Client-Side Test Scenarios #########################################################################################
########################################################################################################################

  Scenario: Auth test
    * karate.start({ mock: 'token_provider.feature', port: 8080 })
    * url 'http://localhost:8080/login'
    * header CorrelationId = 'testing'
    * header CallerId = 'testing'
    * header Timestamp = 'testing'
    # Use all zeros as a userId or 'invalid' as a secret to generate a 401 error.
    # Use all nines as a userId or 'unauthorized' as a secret to generate a 403 error.
    # Use something other than a UUID as a userId, or an empty/null userId/secret to generate a 422 error.
    * request
      """
      {
        "userId": "A0000000-0000-0000-0000-000000000000",
        "secret": "valid"
      }
      """
    * method post

  Scenario: Get token test
    * karate.start({ mock: 'token_provider.feature', port: 8080 })
    * url 'http://localhost:8080/GetToken'
    * header Authorization = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJGSVMiLCJleHAiOjE3MzkyMDgxMTN9.Sa4tIldLBbQCWA6Z0mPMZgPavTedy2T4iyA-XUmDwEQ"
    * header CorrelationId = 'testing'
#    * header CorrelationId = 'ERROR_400_CODE_200'
#    * header CorrelationId = 'PROVISIONING_ERROR_300'
#    * header CorrelationId = 'CRYPTOGRAM_ERROR_300'
    * header CallerId = 'testing'
    * header Timestamp = 'testing'
    * request
      """
      {
        "tokenId": "1",
        "includeCryptogram": true,
        "cryptogramTransactionType": "some type"
      }
      """
    * method post

  Scenario: Create token test
    * karate.start({ mock: 'token_provider.feature', port: 8080 })
    * url 'http://localhost:8080/CreateToken'
    * header Authorization = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJGSVMiLCJleHAiOjE3MzkyMDgxMTN9.Sa4tIldLBbQCWA6Z0mPMZgPavTedy2T4iyA-XUmDwEQ"
    * header CorrelationId = 'testing'
#    * header CorrelationId = 'ERROR_400_CODE_200'
#    * header CorrelationId = 'NO_TOKEN'
#    * header CorrelationId = 'PROVISIONING_ERROR_300'
    * header CallerId = 'testing'
    * header Timestamp = 'testing'
    * request
      """
      {
        "tokenProviderProfileId": "string",
        "cardDetails": {
          "accountNumber": "4444333322221111",
          "cvv2": "123",
          "expirationDate": {
            "month": "12",
            "year": "2033"
          }
        },
        "accountHolderDetails": {
          "name": "string"
        },
        "addressDetails": {
          "line1": "string",
          "line2": "string",
          "line3": "string",
          "line4": "string",
          "line5": "string",
          "city": "string",
          "countrySubdivision": "string",
          "country": "string",
          "postalCode": "string"
        },
        "includePar": true
      }
      """
    * method post

  Scenario: Create cryptogram test
    * karate.start({ mock: 'token_provider.feature', port: 8080 })
    * url 'http://localhost:8080/CreateCryptogram'
    * header Authorization = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJGSVMiLCJleHAiOjE3MzkyMDgxMTN9.Sa4tIldLBbQCWA6Z0mPMZgPavTedy2T4iyA-XUmDwEQ"
    * header CorrelationId = 'testing'
#    * header CorrelationId = 'ERROR_400_CODE_200'
    * header CallerId = 'testing'
    * header Timestamp = 'testing'
    * request
      """
      {
        "tokenProviderProfileId": "1",
        "networkToken": "123",
        "transactionType": "some type"
      }
      """
    * method post

  Scenario: Test with an invalid uri
    * karate.start({ mock: 'token_provider.feature', port: 8080 })
    * url 'http://localhost:8080/CreateNonsense'
    * method post
    * status 404
    * match response == 'Invalid path'

  Scenario: Test with an invalid method
    * karate.start({ mock: 'token_provider.feature', port: 8080 })
    * url 'http://localhost:8080/CreateToken'
    * method get
    * status 405
    * match response == 'Invalid method'

  Scenario: Test an invalid auth header
    * karate.start({ mock: 'token_provider.feature', port: 8080 })
    * header Authorization = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJNeUlEIiwiaWF0IjoxNjQ4NzQwMDI2LCJzdWIiOiJUZXN0aW5nIiwiaXNzIjoiQWNtZSBKV1QgQ28uIiwiZXhwIjoxNjQ4NzQwOTI2fQ.1vWhzstRGbOHeImCMAM4MPwhXdjKggCtpMdcpd2b5X8'
    * url 'http://localhost:8080/CreateToken'
    * method post
    * status 401
    * match response contains 'There is an issue with your JWT: '
