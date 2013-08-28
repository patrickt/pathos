# Copyright (c) 2013 the Pathos team. All rights reserved.

"use strict"

define (require, exports, module) ->
  
  require('lib/zepto.js')
  Body = require('body')
  assert = require('lib/chai.js').assert
  util = require('util')
  
  class Soul
    constructor: (@geometry) ->
      # geometry may be null, as in the case of Firmaments
    
    parentSoul: null
    
    isFixed: true
    
    @property 'geometryInParent',
      get: -> 
        if @parentSoul
          @geometry.byAdding(@parentSoul.geometry)
        else 
          @geometry

    removeSoulRecursively: ->
    
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
      $.extend(this, @recipe)
    
    isFixed: false
    
    @property "color", 
      get: -> ROT.Color.fromString(@recipe['color'])

    bodyClass: Body.ItemBody
    
  class Item extends Soul
    constructor: (@geometry, @color, @char) ->
      super(@geometry)

    bodyClass: Body.ItemBody

  class FarmPlot extends ContainerSoul
    
    constructor: (@geometry, @color) ->
      super(@geometry)

    bodyClass: Body.FarmPlotBody

  class Firmament extends Soul
    
    constructor: (@geometry, @color) ->
      super(@geometry)
  
    bodyClass: Body.FirmamentBody
  
  return { Soul, ContainerSoul, Plant, Item, FarmPlot, Firmament}
