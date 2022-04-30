Feature: Use a username & password to create an Authorization header (Basic Auth)

  Scenario: Encode
    * def username = 'myUsername'
    * def password = 'myPassword'

    * def basicAuthString = username + ":" + password
    * def base64Encoder =
      """
        function(arg) {
          var Base64 = Java.type('java.util.Base64');
          var encoded = Base64.getEncoder().encodeToString(arg.getBytes());
          return encoded;
        }
      """
    * def encodedBasicAuthString = base64Encoder(basicAuthString)
    * def authorizationHeader = 'Basic ' + encodedBasicAuthString

    * print authorizationHeader

  Scenario: Decode
    * def basicAuthString = 'bXlVc2VybmFtZTpteVBhc3N3b3Jk'

    * def base64Decoder =
      """
        function(arg) {
          var Base64 = Java.type('java.util.Base64');
          var decoded = Base64.getDecoder().decode(arg);
          return decoded;
        }
      """
    * def decodedBasicAuthString = base64Decoder(basicAuthString)
    * string decodedBasicAuthString = decodedBasicAuthString
    * def split = function(x, n) { return x.split(':')[n] }
    * def user = split(decodedBasicAuthString, 0)
    * def pwd = split(decodedBasicAuthString, 1)

    * print 'username: ' + user + ', password: ' + pwd
