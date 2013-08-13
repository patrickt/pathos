# Copyright (c) 2013 the Pathos team. All rights reserved.

"use strict"

define (require, exports, module) ->
  util = require("util")
  assert = require("lib/chai.js").assert
  require("lib/underscore.js")
  
  # abstract
  class Body
    constructor: (@soul, @manager) ->
      assert.ok(@manager, "Body created without manager")
    
    recursivelyHitTest: (x, y) ->
      if @soul.geometry.containsPoint(x,y) then this else null
      
    renderRecursively: (display) ->
      assert.ok(false, "Body.renderRecursively is abstract")
    
    @property 'geometry', 
      get: -> @soul.geometry
    
    @property 'geometryInParent',
      get: -> @soul.geometryInParent
      
    convertAbsolutePointToRelative: (point) -> point
      
    toString: ->
      "[%s : %s]".format(@constructor.name, @soul.toString())
  
  class ContainerBody extends Body
    
    recursivelyHitTest: (x, y) ->
      [cx, cy] = @convertAbsolutePointToRelative([x, y])
      _.find(@childBodies, (child) -> child.geometry.containsPoint(cx, cy)) or super
    
    @property 'childBodies', 
      get: -> (@manager.bodyForSoul(ch, createIfNecessary: true) for ch in @soul.childSouls)
      
    convertAbsolutePointToRelative: ([x, y]) -> [x - @geometry.x, y - @geometry.y]
    
    renderRecursively: (d) -> body.renderRecursively(d) for body in @childBodies
  
  class ItemBody extends Body
    
    renderRecursively: (display) ->
      display.draw(@geometryInParent.x, @geometryInParent.y, @soul.char, ROT.Color.toHex(@soul.color))
  
  class FarmPlotBody extends ContainerBody
    
    renderRecursively: (display) ->
      @soul.geometry.eachSquare (x, y) =>
        display.draw(x, y, '=', ROT.Color.toHex(@soul.color))
      super
  
  class FirmamentBody extends Body
    
    renderRecursively: (display) ->
      @soul.geometry.eachSquare (x, y) =>
        display.draw(x, y, '.', ROT.Color.toHex(@soul.color))
    
  return { ItemBody, FarmPlotBody, FirmamentBody }
