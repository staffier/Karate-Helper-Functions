Feature: Start a server & run a benchmark

  Scenario: 
    * karate.start({ mock: 'my_mock.feature', port: 8080 })
    * karate.exec('wrk -t2 -c400 -d30s -s ./src/test/java/benchmark.lua http://localhost:8080')
