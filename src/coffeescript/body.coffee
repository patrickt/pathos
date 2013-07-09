# Copyright (c) 2013 the Pathos team. All rights reserved.

define (require, exports, module) ->
  util = require("util")
  assert = require("../../lib/chai").assert
  _ = require("../../lib/underscore")
  
  Body: class Body extends Object
    constructor: (@soul, @_manager) ->
      assert.ok(@_manager, "Body created without manager")
    
    util.accessor 'manager'
    
    recursivelyHitTest: (x, y) ->
      if @soul.geometry.containsPoint(x,y)
        this
      else
        null
      
    renderRecursively: (display, opts) ->
      assert.ok(false, "Body.renderRecursively is abstract")
      
    toString: ->
      "<Body : soul = %s>".format(this.__proto__.constructor.name, @soul)
  
  ContainerBody: class ContainerBody extends Body
    
    constructor: (@soul, @_manager) ->
      
    recursivelyHitTest: (x, y) ->
      result = null
      for child in @childBodies()
        g = child.soul.geometryInParent()
        if g.containsPoint(x,y)
          result = child
      result or super
          
    
    childBodies: -> 
      assert.ok(@_manager, "manager must exist")
      (@_manager.bodyForSoul(ch, {createIfNecessary: true}) for ch in @soul.childSouls)
    
    renderRecursively: (d, opts = {}) ->
      for body in @childBodies()
        assert.ok(@soul, "soul must exist")
        assert.ok(@soul.geometryInParent(), "needs geometry in parent")
        g = body.soul.geometryInParent()
        opts["geometry"] = body.soul.geometryInParent()
        body.renderRecursively(d, opts)
  
  ItemBody: class extends Body
    
    toString: -> "ItemBody"
    
    renderRecursively: (display, opts) ->
      geom = opts["geometry"] ? @soul.geometry
      display.draw(geom.x, geom.y, @soul.char, ROT.Color.toHex(@soul.getColor()))
  
  FarmPlotBody: class extends ContainerBody
    
    toString: -> "FarmPlotBody"
    
    renderRecursively: (display, opts) =>
      for x in [0..4]
        for y in [0..4]
          display.draw(@soul.geometryInParent().x + x, @soul.geometry.y + y, '☌', ROT.Color.toHex(@soul.color))
      super(display, opts)
  
  FirmamentBody: class extends Body
    toString: -> "FirmamentBody"
    
    renderRecursively: (display) ->
      width = display._options.width
      height = display._options.height
      for x in [0..width]
        for y in [0..height]
          display.draw(x, y, '.', ROT.Color.toHex(@soul.color))
