'use strict'

Function::accessor = (prop, desc) ->
    Object.defineProperty this.prototype, prop, desc

define
  Locus: class
    constructor: -> (@_geometry)
      