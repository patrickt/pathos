# Copyright (c) 2013 the Pathos team. All rights reserved.
# Geometries encapsulate position and size.

define (require) ->
  
  assert = require('lib/chai.js').assert
  
  class Geometry
    constructor: (@x = 0, @y = 0, @w = 1, @h = 1) ->
      assert.operator(@w, '>', 0)
      assert.operator(@w, '>', 0)
    
    toString: ->
      "[%s: x = %s, y = %s, width = %s, height = %s]".format(this.constructor.name, @x, @y, @w, @h)
      
    containsPoint: (x, y) -> (@x <= x < (@x + @w)) and (@y <= y < (@y + @h))
      
    geometryByAdding: (g) ->
      assert.ok(g)
      new Geometry(@x + g.x, @y + g.y, @w, @h)
    
    eachSquare: (fn) ->
      for xx in [@x..(@x + @w)]
        for yy in [@y..(@y + @w)]
          fn(xx, yy)
  
  return { Geometry }
