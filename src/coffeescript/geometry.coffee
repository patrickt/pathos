# Copyright (c) 2013 the Pathos team. All rights reserved.

define (require, exports, module) ->
  
  assert = require('lib/chai.js').assert
  
  Geometry: class Geometry
    constructor: (@x = 0, @y = 0, @w = 1, @h = 1) ->
      
    containsPoint: (x, y) ->
      return (@x <= x < (@x + @w)) && (@y <= y < (@y + @h))
      
    geometryByAdding: (g) ->
      assert.ok(g, "geometryByAdding given falsy parameter")
      new Geometry(@x + g.x, @y + g.y, @w, @h)
    