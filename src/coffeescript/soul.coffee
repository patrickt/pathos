# Copyright (c) 2013 the Pathos team. All rights reserved.

define (require, exports, module) ->
  
  Body = require('body')
  assert = require('lib/chai.js').assert
  util = require('util')
  
  Soul: class Soul
    constructor: (@_geometry) ->
      # geometry may be null, as in the case of Firmaments
    
    util.accessor('geometry')
    
    parentSoul: null
    
    geometryInParent: () ->
      if @parentSoul
        @_geometry.geometryByAdding(@parentSoul.geometry)
      else 
        @_geometry
    
  ContainerSoul: class ContainerSoul extends Soul
    constructor: (@_geometry) ->
      super
      @_childSouls = []
    
    util.accessor 'childSouls'
    
    addSoul: (i) -> 
      i.parentSoul = this
      @_childSouls.push(i)
  
  Plant: class Plant extends Soul
    constructor: (@_geometry, @_recipe) ->
      super
      assert.ok(@_recipe, "Plant created with empty recipe")
      
    util.accessor 'recipe'
    
    getColor: ->
      ROT.Color.fromString(@recipe['color'])
    
    for name in ['identifier', 'char']    
      Object.defineProperty this.prototype, name, 
        get: -> @recipe[name]
        set: (x) -> @recipe[name] = x

    bodyClass: Body.ItemBody
    
  Item: class extends Soul
    constructor: (@_geometry, @color, @_char) ->
      super(@_geometry)
  
    util.accessor 'char'
    getColor: -> @color

    bodyClass: Body.ItemBody

  FarmPlot: class FarmPlot extends ContainerSoul
    constructor: (@_geometry, @color) ->
      super(@_geometry)

    bodyClass: Body.FarmPlotBody

  Firmament: class Firmament extends Soul
    constructor: (@geometry, @color) ->
      super(@geometry)
  
    bodyClass: Body.FirmamentBody
