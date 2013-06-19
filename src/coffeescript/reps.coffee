# Copyright (c) 2013 the Pathos team. All rights reserved.

define (require, exports, module) ->
  util = require("util")
  assert = require("../../lib/chai").assert
  _ = require("../../lib/underscore")
  
  Rep: class Rep extends Object
    constructor: (@soul, @_manager) ->
      
    renderRecursively: (display, opts) ->
      
      
    util.accessor 'manager'
    toString: ->
      "<Rep : soul = %s>".format(this.__proto__.constructor.name, @soul)
  
  ContainerRep: class ContainerRep extends Rep
    
    constructor: (@soul, @_manager) ->
    
    childReps: -> 
      assert.ok(@_manager)
      (@_manager.repForSoul(ch, {createIfNecessary: true}) for ch in @soul.childSouls)
    
    renderRecursively: (d, opts) ->
      opts ?= {}
      super(d, opts)
      for rep in @childReps()
        assert.ok(@soul)
        assert.ok(@soul.geometryInParent())
        g = rep.soul.geometryInParent()
        opts["geometry"] = rep.soul.geometryInParent()
        rep.renderRecursively(d, opts)
  
  ItemRep: class extends Rep
    renderRecursively: (display, opts) =>
      geom = opts["geometry"] ? @soul.geometry
      display.draw(geom.x, geom.y, @soul.char, ROT.Color.toHex(@soul.getColor()))
  
  FarmPlotRep: class extends ContainerRep
    renderRecursively: (display, opts) =>
      for x in [0..4]
        for y in [0..4]
          display.draw(@soul.geometryInParent().x + x, @soul.geometry.y + y, '☌', ROT.Color.toHex(@soul.color))
      super(display, opts)
  
  FirmamentRep: class extends Rep
    toString: -> "FirmamentRep"
    
    renderRecursively: (display) =>
      width = display._options.width
      height = display._options.height
      for x in [0..width]
        for y in [0..height]
          display.draw(x, y, '.', ROT.Color.toHex(@soul.color))
