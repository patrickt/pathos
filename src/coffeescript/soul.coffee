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
    
    zOrdering: 0
    
    @property 'geometryInParent',
      get: -> 
        if @parentSoul
          @_geometry.geometryByAdding(@parentSoul.geometry)
        else 
          @_geometry


    
    toString: ->
      "[%s : geometry = %s]".format(@constructor.name, @_geometry.toString())
    
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
    
    zOrdering: 2
    
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
    
    zOrdering: 1
  
    util.accessor 'char'
    getColor: -> @color

    bodyClass: Body.ItemBody

  FarmPlot: class FarmPlot extends ContainerSoul
    
    zOrdering: 0
    
    constructor: (@_geometry, @color) ->
      super(@_geometry)

    bodyClass: Body.FarmPlotBody

  Firmament: class Firmament extends Soul
    
    zOrdering: -10
    
    constructor: (@geometry, @color) ->
      super(@geometry)
  
    bodyClass: Body.FirmamentBody
