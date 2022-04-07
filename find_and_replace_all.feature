Feature: 

  Scenario: 
    * def replaceAll = function replaceAll(str, find, replace) { return str.replace(new RegExp(find, 'g'), replace); }
    * def document = karate.readAsString('sample.json')
    * match document == { "someKey": "some string", "someOtherKey": "another string" }
    * def updatedDocument = replaceAll(document, 'some string', 'some new string')
    * json updatedDocument = updatedDocument
    * match updatedDocument == { "someKey": "some new string", "someOtherKey": "another string" }
    
