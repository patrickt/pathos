# Copyright (c) 2013 the Pathos team. All rights reserved.

define (require, exports, module) ->
  util = require("util")
  assert = require("../../lib/chai").assert
  _ = require("../../lib/underscore")
  
  Body: class Body extends Object
    constructor: (@soul, @_manager) ->
      
    renderRecursively: (display, opts) ->
      
      
    util.accessor 'manager'
    toString: ->
      "<Body : soul = %s>".format(this.__proto__.constructor.name, @soul)
  
  ContainerBody: class ContainerBody extends Body
    
    constructor: (@soul, @_manager) ->
    
    childBodies: -> 
      assert.ok(@_manager)
      (@_manager.bodyForSoul(ch, {createIfNecessary: true}) for ch in @soul.childSouls)
    
    renderRecursively: (d, opts) ->
      opts ?= {}
      super(d, opts)
      for body in @childBodies()
        assert.ok(@soul)
        assert.ok(@soul.geometryInParent())
        g = body.soul.geometryInParent()
        opts["geometry"] = body.soul.geometryInParent()
        body.renderRecursively(d, opts)
  
  ItemBody: class extends Body
    renderRecursively: (display, opts) =>
      geom = opts["geometry"] ? @soul.geometry
      display.draw(geom.x, geom.y, @soul.char, ROT.Color.toHex(@soul.getColor()))
  
  FarmPlotBody: class extends ContainerBody
    renderRecursively: (display, opts) =>
      for x in [0..4]
        for y in [0..4]
          display.draw(@soul.geometryInParent().x + x, @soul.geometry.y + y, '☌', ROT.Color.toHex(@soul.color))
      super(display, opts)
  
  FirmamentBody: class extends Body
    toString: -> "FirmamentBody"
    
    renderRecursively: (display) =>
      width = display._options.width
      height = display._options.height
      for x in [0..width]
        for y in [0..height]
          display.draw(x, y, '.', ROT.Color.toHex(@soul.color))
