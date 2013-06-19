"use strict"

# Copyright (c) 2013 the Pathos team. All rights reserved.

define (require, exports, module) ->
  
  Rep = require 'reps'
  assert = require('lib/chai.js').assert
  util = require 'util'
  
  Soul: class Soul
    constructor: (@geometry) ->
    
    parentSoul: null
    
    geometryInParent: () ->
      unless @parentSoul
        return @geometry
      @geometry.geometryByAdding(@parentSoul.geometry)
    
    
  ContainerSoul: class ContainerSoul extends Soul
    constructor: (@geometry) ->
      super(@geometry)
      @_childSouls = []
    
    util.accessor 'childSouls'
    
    addInfo: (i) -> 
      i.parentSoul = this
      this['childSouls'].push(i)
  
  Plant: class Plant extends Soul
    constructor: (@geometry, @recipe) ->
      super(@geometry)
      assert.ok(@recipe, "Plant created with empty recipe")
    
    getColor: ->
      ROT.Color.fromString(@recipe['color'])
    
    for name in ['identifier', 'char']    
      Object.defineProperty this.prototype, name, 
        get: -> @recipe[name]
        set: (x) -> @recipe[name] = x

    repClass: Rep.ItemRep
    
  Item: class extends Soul
    constructor: (@geometry, @color, @_char) ->
      super(@geometry)
  
    util.accessor 'char'
    getColor: -> @color

    repClass: Rep.ItemRep

  FarmPlot: class FarmPlot extends ContainerSoul
    constructor: (@geometry, @color) ->
      super(@geometry)

    repClass: Rep.FarmPlotRep

  Firmament: class Firmament extends Soul
    constructor: (@geometry, @color) ->
      super(@geometry)
  
    repClass: Rep.FirmamentRep
