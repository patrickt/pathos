# Copyright (c) 2013 the Pathos team. All rights reserved.

"use strict"

define (require, exports, module) ->
  util = require("util")
  assert = require("../../lib/chai").assert
  require("lib/underscore.js")
  
  # abstract
  class Body
    constructor: (@soul, @manager) ->
      assert.ok(@manager, "Body created without manager")
    
    recursivelyHitTest: (x, y) ->
      if @soul.geometry.containsPoint(x,y) then this else null
      
    renderRecursively: (display, opts) ->
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
      # test all children, converting the children's coordinates into absolute space
      # todo: modify x and y rather than recomputing parent geometry every time
      _.find(@childBodies, (child) -> child.geometryInParent.containsPoint(x, y)) or super
    
    @property 'childBodies', 
      get: -> (@manager.bodyForSoul(ch, createIfNecessary: true) for ch in @soul.childSouls)
      
    convertAbsolutePointToRelative: (point) ->
      [point.x - @geometry.x, point.y - @geometry.y]
    
    renderRecursively: (d, opts = {}) ->
      for body in @childBodies
        body.renderRecursively(d, _.extend(opts, geometry: body.soul.geometryInParent))
  
  class ItemBody extends Body
    
    renderRecursively: (display, opts = {}) ->
      geom = opts.geometry ? @soul.geometry
      display.draw(geom.x, geom.y, @soul.char, ROT.Color.toHex(@soul.color))
  
  class FarmPlotBody extends ContainerBody
    
    renderRecursively: (display, opts) ->
      @soul.geometry.eachSquare (x, y) =>
        display.draw(x, y, '=', ROT.Color.toHex(@soul.color))
      super
  
  class FirmamentBody extends Body
    
    renderRecursively: (display) ->
      @soul.geometry.eachSquare (x, y) =>
        display.draw(x, y, '.', ROT.Color.toHex(@soul.color))
    
  return { ItemBody, FarmPlotBody, FirmamentBody }
