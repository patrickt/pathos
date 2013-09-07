"use strict"

define (require, exports, module) -> 
  
  require('lib/adt.js')
  require('lib/underscore.js')
  {data, any, only} = adt
  
  {Month} = data
    Month:
      days: only(Number)
      name: only(String)
  
  { Calendar } = data
    Calendar:
      months: only(Array)
      dayLength: only(Number)
      
  Calendar::numberOfDays = ->
    _.reduce(@months, ((memo, m) -> memo + m.days), 0)
  
  mayne = ->
    m = Month(30, "Kvestrel")
    d = Calendar([m], 200)
    console.log(d.numberOfDays())
  
  return { Month, mayne }
  
  