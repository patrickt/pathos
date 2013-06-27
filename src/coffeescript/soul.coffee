"use strict"

# Copyright (c) 2013 the Pathos team. All rights reserved.

define (require, exports, module) ->
  
  Body = require 'bodies'
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
    
    addSoul: (i) -> 
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

    bodyClass: Body.ItemBody
    
  Item: class extends Soul
    constructor: (@geometry, @color, @_char) ->
      super(@geometry)
  
    util.accessor 'char'
    getColor: -> @color

    bodyClass: Body.ItemBody

  FarmPlot: class FarmPlot extends ContainerSoul
    constructor: (@geometry, @color) ->
      super(@geometry)

    bodyClass: Body.FarmPlotBody

  Firmament: class Firmament extends Soul
    constructor: (@geometry, @color) ->
      super(@geometry)
  
    bodyClass: Body.FirmamentBody
