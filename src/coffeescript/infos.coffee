"use strict"

# Copyright (c) 2013 the Pathos team. All rights reserved.

define (require, exports, module) ->
  
  Rep = require 'reps'
  assert = require 'lib/chai.js'
  util = require 'util'
  
  Plant: class Plant
    constructor: (@geometry, @recipe) ->
      assert.assert.ok(@recipe, "Plant created with empty recipe")
    
    getColor: ->
      assert.assert.ok(@recipe)
      ROT.Color.fromString(@recipe['color'])
    
    for name in ['identifier', 'char']    
      Object.defineProperty this.prototype, name, 
        get: -> @recipe[name]
        set: (x) -> @recipe[name] = x

    repClass: Rep.ItemRep
    
  Item: class
    constructor: (@geometry, @color, @_char) ->
  
    util.accessor 'char'
    getColor: -> @color

    repClass: Rep.ItemRep

  FarmPlot: class FarmPlot
    constructor: (@geometry, @color) ->
      @childInfos = []

    repClass: Rep.FarmPlotRep

    addInfo: (i) ->
      @childInfos.push(i)

  Firmament: class Firmament
    constructor: (@color) ->
  
    repClass: Rep.FirmamentRep
