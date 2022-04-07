Feature: 

  Scenario: 
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
    * def cardMasker =
      """
        function(x) {
          var first4 = x.substring(0, 4);
          var last4 = x.substring(12, 16);
          return first4 + '********' + last4;
        }
      """
    * def bin =
      """
        function(x) {
          var first6 = x.substring(0, 6);
          return first6;
        }
      """
  
