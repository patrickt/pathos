# Copyright (c) 2013 the Pathos team. All rights reserved.

"use strict"

define (require, exports, module) ->
  
  require('lib/zepto.js')
  require('lib/backbone.js')
  require('lib/rot.js')
  
  Body   = require('body')
  assert = require('lib/chai.js').assert
  util   = require('util')
  
  class Soul extends Backbone.Model
    
    @observable 'geometry'
    
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
      super
      assert.ok(this.geometry)
      assert.ok(this.recipe)
       
    
    @observable 'geometry'
    @observable 'recipe'
    @observable 'growth'
    
    growthStages: 4
    
    isFixed: false

    bodyClass: Body.ItemBody

  class FarmPlot extends ContainerSoul

    bodyClass: Body.FarmPlotBody
    
    @observable 'color'

  class Firmament extends Soul
    
    constructor: ->
      super
      @map = new ROT.Map.Cellular(80, 25)
      @map.randomize(0.1)
    
    bodyClass: Body.FirmamentBody
    
    @observable 'color'
  
  return { Soul, ContainerSoul, Plant, FarmPlot, Firmament}
