Feature: 

  Scenario: 
    * def replaceAll = function replaceAll(str, find, replace) { return str.replace(new RegExp(find, 'g'), replace); }
    * def document = karate.readAsString('sample.json')
    * def updatedDocument = replaceAll(document, 'some string', 'some new string')
    * json updatedDocument = updatedDocument
