Feature: 

  Scenario: 
    * def randomAlphanumeric =
      """
        function(length) {
          var result = '';
          var characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
          var charactersLength = characters.length;
          for ( var i = 0; i < length; i++ ) {
            result += characters.charAt(Math.floor(Math.random() * charactersLength));
          }
          return result;
        }
      """
    * def newKey = 'test-' + randomAlphanumeric(10)
    * def dynamicKey =
      """
      function(key) {
        var temp = {};
        temp[key] = 'test';
        return temp;
      }
      """
    * def key = dynamicKey(newKey)
    * string key = key
    * match key contains newKey
    * def keyValidator = '{"' + newKey + '":"test"}'
    * match key == keyValidator
