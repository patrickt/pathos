# Copyright (c) 2013 the Pathos team. All rights reserved.
# Geometries encapsulate position and size.

"use strict"

define (require) ->
  
  require('lib/underscore.js')
  require('lib/backbone.js')
  { assert } = require('lib/chai.js')
  require('util')
  
  class Geometry extends Backbone.Model
    
    @indeterminate: { isIndeterminate: true }
    
    @property "x", get: (-> @origin[0]), set: ((x) -> @origin[0] = x )
    @property "y", get: (-> @origin[1]), set: ((y) -> @origin[1] = y )
    @property "z", get: (-> @origin[2]), set: ((z) -> @origin[2] = z )
    @property "w", get: (-> @size[0]  ), set: ((w) -> @size[0] = w   )
    @property "h", get: (-> @size[1]  ), set: ((h) -> @size[1] = h   )
    
    constructor: (@origin, @size = [1, 1]) ->
      @x ?= 1
      @y ?= 1
      @z ?= 1
      
    isIndeterminate: false
    
    toString: ->
      "[%s: x = %s, y = %s, width = %s, height = %s]".format(this.constructor.name, @x, @y, @w, @h)
    
    containsPoint: ([x, y]) -> (@x <= x < (@x + @w)) and (@y <= y < (@y + @h))
      
    byAdding: (g) ->
      assert.ok(g)
      new Geometry([@x + g.x, @y + g.y, @z], @size)
      
    bySubtracting: (g) ->
      assert.ok(g)
      new Geometry([@x - g.x, @y - g.y, @z], @size)
    
    eachSquare: (fn) ->
      for xx in [@x..(@x + @w)]
        for yy in [@y..(@y + @w)]
          fn(xx, yy)
  
  return { Geometry }
