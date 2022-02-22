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
