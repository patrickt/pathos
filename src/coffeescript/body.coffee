# Copyright (c) 2013 the Pathos team. All rights reserved.

define (require, exports, module) ->
  util = require("util")
  assert = require("../../lib/chai").assert
  require("lib/underscore.js")
  
  class Body
    constructor: (@soul, @manager) ->
      assert.ok(@manager, "Body created without manager")
    
    recursivelyHitTest: (x, y) ->
      if @soul.geometry.containsPoint(x,y) then this else null
      
    renderRecursively: (display, opts) ->
      assert.ok(false, "Body.renderRecursively is abstract")
      
    toString: ->
      "[%s : %s]".format(@constructor.name, @soul.toString())
  
  class ContainerBody extends Body
    
    recursivelyHitTest: (x, y) ->
      result = null
      for child in @childBodies()
        g = child.soul.geometryInParent()
        if g.containsPoint(x,y)
          result = child
      result or super
          
    
    childBodies: -> 
      assert.ok(@manager, "manager must exist")
      (@manager.bodyForSoul(ch, {createIfNecessary: true}) for ch in @soul.childSouls)
    
    renderRecursively: (d, opts = {}) ->
      for body in @childBodies()
        assert.ok(@soul, "soul must exist")
        assert.ok(@soul.geometryInParent(), "needs geometry in parent")
        g = body.soul.geometryInParent()
        opts["geometry"] = body.soul.geometryInParent()
        body.renderRecursively(d, opts)
  
  class ItemBody extends Body
    
    renderRecursively: (display, opts) ->
      geom = opts["geometry"] ? @soul.geometry
      display.draw(geom.x, geom.y, @soul.char, ROT.Color.toHex(@soul.getColor()))
  
  class FarmPlotBody extends ContainerBody
    
    renderRecursively: (display, opts) =>
      @soul.geometry.eachSquare (x, y) =>
        display.draw(x, y, '☌', ROT.Color.toHex(@soul.color))
      super(display, opts)
  
  class FirmamentBody extends Body
    
    renderRecursively: (display) ->
      @soul.geometry.eachSquare (x, y) =>
        display.draw(x, y, '.', ROT.Color.toHex(@soul.color))
    
  return { ItemBody, FarmPlotBody, FirmamentBody}
