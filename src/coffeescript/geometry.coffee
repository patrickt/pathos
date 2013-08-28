# Copyright (c) 2013 the Pathos team. All rights reserved.
# Geometries encapsulate position and size.

"use strict"

define (require) ->
  
  require('lib/underscore.js')
  assert = require('lib/chai.js').assert
  util = require('util')
  
  class Geometry
    @fromPoint: (x, y) -> new Geometry(x, y)
    
    @property "origin", 
      get: -> [@x, @y]
      set: (pt) -> [@x, @y] = pt
    
    constructor: (@x = 0, @y = 0, @w = 1, @h = 1, @z = 0) ->
      assert.operator(@w, '>', 0)
      assert.operator(@h, '>', 0)
      
    
    toString: ->
      "[%s: x = %s, y = %s, width = %s, height = %s]".format(this.constructor.name, @x, @y, @w, @h)
    
    containsPoint: (x, y) -> (@x <= x < (@x + @w)) and (@y <= y < (@y + @h))
      
    byAdding: (g) ->
      assert.ok(g)
      new Geometry(@x + g.x, @y + g.y, @w, @h, @z)
      
    bySubtracting: (g) ->
      assert.ok(g)
      new Geometry(@x - g.x, @y - g.y, @w, @h, @z)
    
    eachSquare: (fn) ->
      for xx in [@x..(@x + @w)]
        for yy in [@y..(@y + @w)]
          fn(xx, yy)
  
  return { Geometry }
