Feature: Decode & decrypt an href; convert an href to a Token ID

  Call this feature using something like this:

    * def reference = call read('classpath:path/to/decoder.feature@decrypt') { location: '<URL>' }

  Then, from the feature file that called this one, grab the resulting reference or token_id using something like this:

    * def reference = reference.decrypted
    * def tokenId = tokenId.token_id

  Background:
    * def base64UrlDecoder =
      """
        function(token_location) {
          var base64Url = token_location.split(baseUrl + "/tokens/")[1];
          var Base64 = Java.type('java.util.Base64');
          var decoded = Base64.getDecoder().decode(base64Url);
          var String = Java.type('java.lang.String');
          return new String(decoded);
        }
      """
    * def base64Decoder =
      """
        function(arg) {
          var Base64 = Java.type('java.util.Base64');
          var decoded = Base64.getDecoder().decode(arg);
          return decoded;
        }
      """
    * def baseUrl = baseUrl

  @decrypt
  Scenario: Decode & decrypt a URI
#    * def location = "https://some.url.com/tokens/someencodedandencrypteduri"
    * def URI = base64UrlDecoder(location)
    * json URI = URI
    * def d = URI.d
    * def cipherText = base64Decoder(d)
    * def keyString = "some key string"
    * def key = base64Decoder(keyString)
    * def Decryptor = Java.type('path.to.Decryptor')
    * def decryptor = new Decryptor()
    * def decrypted = decryptor.decrypt(cipherText, key)
#    * print decrypted
    * def decodedUri = base64Decoder(decrypted)
    * string decodedUri = decodedUri
#    * print decodedUri
