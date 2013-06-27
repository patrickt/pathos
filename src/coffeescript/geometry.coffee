# Copyright (c) 2013 the Pathos team. All rights reserved.

define (require, exports, module) ->
  Geometry: class Geometry
    constructor: (@x = 0, @y = 0, @w = 1, @h = 1) ->
      
    geometryByAdding: (g) ->
      new Geometry(@x + g.x, @y + g.y, @w, @h)
    