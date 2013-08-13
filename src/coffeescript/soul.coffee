# Copyright (c) 2013 the Pathos team. All rights reserved.

"use strict"

define (require, exports, module) ->
  
  Body = require('body')
  assert = require('lib/chai.js').assert
  util = require('util')
  
  class Soul
    constructor: (@geometry) ->
      # geometry may be null, as in the case of Firmaments
    
    parentSoul: null
    
    zOrdering: 0
    
    isFixed: true
    
    @property 'geometryInParent',
      get: -> 
        if @parentSoul
          @geometry.geometryByAdding(@parentSoul.geometry)
        else 
          @geometry

    removeSoulRecursively: ->
      
    @property 'displayName',
      get: -> @toString()
    
    toString: ->
      "[%s : geometry = %s]".format(@constructor.name, @geometry.toString())
    
  class ContainerSoul extends Soul
    constructor: (@geometry) ->
      super
      @childSouls = []
    
    addSoul: (i) -> 
      i.parentSoul = this
      @childSouls.push(i)
      
    removeSoulRecursively: (i) ->
      if i in @childSouls
        @childSouls = _.without(@childSouls, i)
      else
        soul.removeSoulRecursively(i) for soul in @childSouls
  
  class Plant extends Soul
    constructor: (@geometry, @recipe) ->
      super
      assert.ok(@recipe, "Plant created with empty recipe")
    
    isFixed: false
    
    zOrdering: 2
    
    @property "color", 
      get: -> ROT.Color.fromString(@recipe['color'])
    
    for name in ['identifier', 'char']    
      @property name, get: -> @recipe[name]
    
    @property 'displayName', get: -> @recipe.display_name

    bodyClass: Body.ItemBody
    
  class Item extends Soul
    constructor: (@geometry, @color, @char) ->
      super(@geometry)
    
    zOrdering: 1

    bodyClass: Body.ItemBody

  class FarmPlot extends ContainerSoul
    
    constructor: (@geometry, @color) ->
      super(@geometry)
    
    zOrdering: 0

    bodyClass: Body.FarmPlotBody

  class Firmament extends Soul
    
    zOrdering: -10
    
    constructor: (@geometry, @color) ->
      super(@geometry)
  
    bodyClass: Body.FirmamentBody
  
  return { ContainerSoul, Plant, Item, FarmPlot, Firmament}
