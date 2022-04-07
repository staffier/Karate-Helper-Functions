Feature: 

  Scenario: Add a specified number of days to the current date
    * def addDays =
	    """
        function(days) {
          var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
          var sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
          var date = new java.util.Date();
          date.setDate(date.getDate() + days);
          return sdf.format(date);
        }
      """
    * def datestampPlus5days = addDays(5)
    
  Scenario: Timestamp format validator
    * def timeValidator =
      """
        function(s) {
          var SimpleDateFormat = Java.type("java.text.SimpleDateFormat");
          var sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mS'Z'");
          try {
            sdf.parse(s).time;
            return true;
          }
          catch(e) {
            karate.log('*** invalid date string:', s);
            return false;
          }
        }
      """

  Scenario: Generate a random expiry month/year (e.g. for a credit card)
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
      
  Scenario: Validate month & year values are valid
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
