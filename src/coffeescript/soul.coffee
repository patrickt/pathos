# Copyright (c) 2013 the Pathos team. All rights reserved.

"use strict"

define (require, exports, module) ->
  
  require('lib/zepto.js')
  require('lib/backbone.js')
  Body = require('body')
  assert = require('lib/chai.js').assert
  util = require('util')
  
  class Soul extends Backbone.Model
    
    @property 'geometry',
      get: -> @get('geometry')
      set: (g) -> @set('geometry', g)
    
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
    initialize:  ->
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
    initialize: ->
      $.extend(this, @get('recipe'))
    
    isFixed: false
    
    @property "color", 
      get: -> ROT.Color.fromString(@get('recipe')['color'])

    bodyClass: Body.ItemBody
    
  class Item extends Soul
    constructor: (@geometry, @color, @char) ->
      super(@geometry)

    bodyClass: Body.ItemBody

  class FarmPlot extends ContainerSoul

    bodyClass: Body.FarmPlotBody
    
    @property "color", 
      get: -> @get('color')

  class Firmament extends Soul
  
    bodyClass: Body.FirmamentBody
    
    @property "color", 
      get: -> @get('color')
  
  return { Soul, ContainerSoul, Plant, Item, FarmPlot, Firmament}
