Feature: Create error objects (can be optionally added to responses based on the correlationId value on the request):

  @authErrors
  Scenario:
    # Errors applicable to the /login endpoint:
    * def error201 = { errorCode: '201', source: 'source', context: 'context', message: 'message' }
    * def error204 = { errorCode: '204', source: 'source', context: 'context', message: 'message' }
    * def error206_secret = { errorCode: '206', source: 'source', context: 'context', message: 'message' }
    * def error206_userId = { errorCode: '206', source: 'source', context: 'context', message: 'message' }
    * def error208_userId = { errorCode: '208', source: 'source', context: 'context', message: 'message' }

    # Generate an error response body (order matters here, as karate.set() will overwrite 'errors'):
    * def isValidUserId = karate.match("request.userId == '#uuid'")
    * if (isValidUserId.pass == false) karate.set('errors', [error208_userId])
    * if (request.userId == null || request.userId == '') karate.set('errors', [error206_userId])
    * if (request.secret == null || request.secret == '') karate.set('errors', [error206_secret])
    * if ((request.userId == null || request.userId == '') && (request.secret == null || request.secret == '')) karate.set('errors', [error206_userId, error206_secret])
    * if (request.userId == '00000000-0000-0000-0000-000000000000' || request.secret == 'invalid') karate.set('errors', [error201])
    * if (request.userId == '99999999-9999-9999-9999-999999999999' || request.secret == 'unauthorized') karate.set('errors', [error204])

    * def errorResponse =
      """
      {
        "statusCode": "-100",
        "errors": "#(errors)"
      }
      """

  @addErrors
  Scenario:
    # Errors applicable to 400/422 response statuses:
    * def error200 = { errorCode: '200', source: 'source', context: 'context', message: 'message' }
    * def error202 = { errorCode: '202', source: 'source', context: 'context', message: 'message' }
    * def error203 = { errorCode: '203', source: 'source', context: 'context', message: 'message' }
    * def error205 = { errorCode: '205', source: 'source', context: 'context', message: 'message' }
    * def error206 = { errorCode: '206', source: 'source', context: 'context', message: 'message' }
    * def error207 = { errorCode: '207', source: 'source', context: 'context', message: 'message' }
    * def error208 = { errorCode: '208', source: 'source', context: 'context', message: 'message' }
    * def error209 = { errorCode: '209', source: 'source', context: 'context', message: 'message' }
    * def error220 = { errorCode: '220', source: 'source', context: 'context', message: 'message' }
    * def error221 = { errorCode: '221', source: 'source', context: 'context', message: 'message' }
    * def error222 = { errorCode: '222', source: 'source', context: 'context', message: 'message' }
    * def error223 = { errorCode: '223', source: 'source', context: 'context', message: 'message' }

    # Errors applicable to 401/403 response statuses:
    * def error201 = { errorCode: '201', source: 'source', context: 'context', message: 'message' }
    * def error204 = { errorCode: '204', source: 'source', context: 'context', message: 'message' }

    # Set a single error based on correlationId:
    * if (correlationId == 'ERROR_400_CODE_200') karate.set('errors', [error200])
    * if (correlationId == 'ERROR_400_CODE_202') karate.set('errors', [error202])
    * if (correlationId == 'ERROR_400_CODE_203') karate.set('errors', [error203])
    * if (correlationId == 'ERROR_400_CODE_205') karate.set('errors', [error205])
    * if (correlationId == 'ERROR_400_CODE_206') karate.set('errors', [error206])
    * if (correlationId == 'ERROR_400_CODE_207') karate.set('errors', [error207])
    * if (correlationId == 'ERROR_400_CODE_208') karate.set('errors', [error208])
    * if (correlationId == 'ERROR_400_CODE_209') karate.set('errors', [error209])
    * if (correlationId == 'ERROR_400_CODE_220') karate.set('errors', [error220])
    * if (correlationId == 'ERROR_400_CODE_221') karate.set('errors', [error221])
    * if (correlationId == 'ERROR_400_CODE_222') karate.set('errors', [error222])
    * if (correlationId == 'ERROR_400_CODE_223') karate.set('errors', [error223])
    * if (correlationId == 'ERROR_401_CODE_201') karate.set('errors', [error201])
    * if (correlationId == 'ERROR_401_CODE_204') karate.set('errors', [error204])
    * if (correlationId == 'ERROR_403_CODE_201') karate.set('errors', [error201])
    * if (correlationId == 'ERROR_403_CODE_204') karate.set('errors', [error204])
    * if (correlationId == 'ERROR_422_CODE_200') karate.set('errors', [error200])
    * if (correlationId == 'ERROR_422_CODE_202') karate.set('errors', [error202])
    * if (correlationId == 'ERROR_422_CODE_203') karate.set('errors', [error203])
    * if (correlationId == 'ERROR_422_CODE_205') karate.set('errors', [error205])
    * if (correlationId == 'ERROR_422_CODE_206') karate.set('errors', [error206])
    * if (correlationId == 'ERROR_422_CODE_207') karate.set('errors', [error207])
    * if (correlationId == 'ERROR_422_CODE_208') karate.set('errors', [error208])
    * if (correlationId == 'ERROR_422_CODE_209') karate.set('errors', [error209])
    * if (correlationId == 'ERROR_422_CODE_220') karate.set('errors', [error220])
    * if (correlationId == 'ERROR_422_CODE_221') karate.set('errors', [error221])
    * if (correlationId == 'ERROR_422_CODE_222') karate.set('errors', [error222])
    * if (correlationId == 'ERROR_422_CODE_223') karate.set('errors', [error223])

    # Set multiple errors based on correlationId:
    * if (correlationId == 'ERROR_400_CODES_208_AND_209') karate.set('errors', [error208, error209])
    * if (correlationId == 'ERROR_422_CODES_208_AND_209') karate.set('errors', [error208, error209])

    # Generate an error response body:
    * def errorResponse =
      """
      {
        "statusCode": "-100",
        "errors": "#(errors)"
      }
      """

  @modifyAuth
  Scenario:
    * def status = "100"
    * def errors = null

  @modifyGetToken
  Scenario:
    * def statusCode = "100"
    * def errors = null
    * def tokenDetails =
      """
      {
        "token": "#(randomNumber(19))",
        "status": "string",
        "expirationDate": {
          "month": "#(expiryMonth())",
          "year": "#(expiryYear(2))"
        }
      }
      """
    * def paymentAccountDetails =
      """
      {
        "pan": {
          "firstSix": "411111",
          "lastFour": "1111"
        },
        "expirationDate": {
          "month": "12",
          "year": "2025"
        },
        "par": "string"
      }
      """
    * def provisioningErrors = null
    * def cryptogramDetails =
      """
      {
        "cryptogram": "string",
        "eci": "string"
      }
      """

    # Errors applicable to provisioning error responses:
    * def error300 = { errorCode: '300', providerErrorCode: '400', source: 'source', context: 'context', message: 'message' }
    * def error301 = { errorCode: '301', providerErrorCode: '400', source: 'source', context: 'context', message: 'message' }

    # Set provisioning errors based on correlationId:
    * if (correlationId == 'PROVISIONING_ERROR_300') karate.set('tokenDetails', { "status": "Provisioning Error" })
    * if (correlationId == 'PROVISIONING_ERROR_300') karate.set('provisioningErrors', [error300])
    * if (correlationId == 'PROVISIONING_ERROR_300') karate.set('cryptogramDetails', null)
    * if (correlationId == 'PROVISIONING_ERROR_301') karate.set('tokenDetails', { "status": "Provisioning Error" })
    * if (correlationId == 'PROVISIONING_ERROR_301') karate.set('provisioningErrors', [error301])
    * if (correlationId == 'PROVISIONING_ERROR_301') karate.set('cryptogramDetails', null)

    # Errors applicable to cryptogram failures:
    * def error300 = { errorCode: '300', providerErrorCode: '400', source: 'source', context: 'context', message: 'message' }
    * def error301 = { errorCode: '301', providerErrorCode: '400', source: 'source', context: 'context', message: 'message' }

    # Set cryptogram-related errors based on correlationId:
    * if (correlationId == 'CRYPTOGRAM_ERROR_300') karate.set('statusCode', '100.101')
    * if (correlationId == 'CRYPTOGRAM_ERROR_300') karate.set('errors', error300)
    * if (correlationId == 'CRYPTOGRAM_ERROR_300') karate.set('cryptogramDetails', null)
    * if (correlationId == 'CRYPTOGRAM_ERROR_301') karate.set('statusCode', '100.101')
    * if (correlationId == 'CRYPTOGRAM_ERROR_301') karate.set('errors', error301)
    * if (correlationId == 'CRYPTOGRAM_ERROR_301') karate.set('cryptogramDetails', null)

  @modifyCreateToken
  Scenario:
    * def firstSix = stripFirstSix(request.cardDetails.accountNumber)
    * def lastFour = stripLastFour(request.cardDetails.accountNumber)
    * def expirationDate = request.cardDetails.expirationDate

    * def statusCode = "100"
    * def errors = null
    * def tokenDetails =
      """
      {
        "token": "#(randomNumber(19))",
        "status": "100",
        "expirationDate": {
          "month": "#(expiryMonth())",
          "year": "#(expiryYear(2))"
        }
      }
      """
    * def paymentAccountDetails =
      """
      {
        "pan": {
          "firstSix": "#(firstSix)",
          "lastFour": "#(lastFour)"
        },
        "expirationDate": "#(expirationDate)",
        "par": "string"
      }
      """
    * def provisionDetails = { "tokenId": "#(uuid())" }

    # Errors applicable to provisioning error responses:
    * def error300 = { errorCode: '300', providerErrorCode: '400', source: 'source', context: 'context', message: 'message' }
    * def error301 = { errorCode: '301', providerErrorCode: '400', source: 'source', context: 'context', message: 'message' }

    # Set provisioning errors based on correlationId:
    * if (correlationId == 'PROVISIONING_ERROR_300') karate.set('statusCode', '-100')
    * if (correlationId == 'PROVISIONING_ERROR_300') karate.set('errors', [error300])
    * if (correlationId == 'PROVISIONING_ERROR_300') karate.set('tokenDetails', null)
    * if (correlationId == 'PROVISIONING_ERROR_300') karate.set('paymentAccountDetails', null)
    * if (correlationId == 'PROVISIONING_ERROR_300') karate.set('provisionDetails', null)
    * if (correlationId == 'PROVISIONING_ERROR_301') karate.set('statusCode', '-100')
    * if (correlationId == 'PROVISIONING_ERROR_301') karate.set('errors', [error301])
    * if (correlationId == 'PROVISIONING_ERROR_301') karate.set('tokenDetails', null)
    * if (correlationId == 'PROVISIONING_ERROR_301') karate.set('paymentAccountDetails', null)
    * if (correlationId == 'PROVISIONING_ERROR_301') karate.set('provisionDetails', null)

  @modifyCreateCryptogram
  Scenario:
    * def statusCode = "100"
    * def errors = null
    * def cryptogramDetails =
      """
      {
        "cryptogram": "string",
        "eci": "string"
      }
      """
