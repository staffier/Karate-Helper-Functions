Feature: Retrieve operating system environment variables

  Scenario: 
    * def envInfo = java.lang.System.getenv()
    * print envInfo
    * match envInfo contains { PATH: "#string" }

# These variables can be incorporated in your runner class, as well.
# For instance, if a host name is configured based on an APP_HOST environment variable, you can dynamically set your host name like this:
#
#  class TestRunner {
#    @Test
#    void testParallel() {
#      var hostname = System.getenv("APP_HOST") == null ? "localhost" : System.getenv("APP_HOST");
#      System.setProperty("karate.env", hostname);
#
#      Results results =
#        Runner.path("classpath:scenarios")
#          .tags("~@ignore")
#          .parallel(5);
#      assertEquals(0, results.getFailCount(), results.getErrorMessages());
#    }
#  }
#
# ...and in your karate-config.js file, reference 'karate.env: 
#
#  function fn() {
#     var env = karate.env; // get java system property 'karate.env'
#     if (!env) {
#       env = 'localhost'; // default environment
#     }
#     var config = {
#       baseUrl: 'https://123.12.0.1:8443',
#     };
#     if (env == 'localhost') {
#       config.baseUrl = 'https://localhost:8443';
#     }
#     karate.log('baseUrl:', config.baseUrl);
#     return config;
#   }
