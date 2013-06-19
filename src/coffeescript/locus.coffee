'use strict'

define ['util'], (util) ->
  
  Locus: class
    constructor: (@_geometry) -> 
    
    util.accessor 'geometry'
    