# Copyright (c) 2013 the Pathos team. All rights reserved.

"use strict"

define (require, exports, module) ->
  util = require("util")
  assert = require("lib/chai.js").assert
  require("lib/underscore.js")
  
  # abstract
  class Body
    constructor: (@soul, @manager) ->
      _(arguments).map(assert.ok)
    
    recursivelyHitTest: (pt) ->
      if @soul.geometry.containsPoint(pt) then this else null
      
    renderRecursively: (display) ->
      assert.ok(false, "Body.renderRecursively is abstract")
    
    @property 'geometry', 
      get: -> @soul.geometry
    
    @property 'geometryInParent',
      get: -> @soul.geometryInParent
      
    renderHTML: ->
      
    convertAbsolutePointToRelative: (point) -> point
    
    handleEvent: (e) -> false
      
    toString: ->
      "[%s : %s]".format(@constructor.name, @soul.toString())
  
  class ContainerBody extends Body
    
    recursivelyHitTest: ([x, y]) ->
      arr = @convertAbsolutePointToRelative([x, y])
      _.find(@childBodies, (child) -> child.geometry.containsPoint(arr)) or super
    
    @property 'childBodies', 
      get: -> (@manager.bodyForSoul(ch, createIfNecessary: true) for ch in @soul.childSouls)
      
    convertAbsolutePointToRelative: ([x, y]) -> [x - @geometry.x, y - @geometry.y]
    
    renderRecursively: (d) -> body.renderRecursively(d) for body in @childBodies
  
  class ItemBody extends Body
    
    renderHTML: ($el) ->
      $el.append($("<p>").html(@soul.recipe.displayName))
    
    renderRecursively: (display) ->
      display.draw(@geometryInParent.x, @geometryInParent.y, @soul.recipe.char, ROT.Color.toHex(ROT.Color.fromString(@soul.get('recipe').color)))
  
  class FarmPlotBody extends ContainerBody
    
    renderRecursively: (display) ->
      @soul.geometry.eachSquare (x, y) =>
        display.draw(x, y, '~', ROT.Color.toHex(@soul.color))
      super
  
  class FirmamentBody extends Body
    
    renderRecursively: (display) ->
      map = @soul.map._map
      soulColor = @soul.color
      @soul.geometry.eachSquare (x, y) =>
        [char, color] = [undefined, undefined]
        if map[x]?[y] 
          char = ','
          color = ROT.Color.toHex(ROT.Color.fromString("yellow"))
        else
          char = '.'
          color = ROT.Color.toHex(soulColor)
        display.draw(x, y, char, color)
      
    
  return { Body, ItemBody, FarmPlotBody, FirmamentBody }
