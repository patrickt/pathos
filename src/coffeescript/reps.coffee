# Copyright (c) 2013 the Pathos team. All rights reserved.

define (require, exports, module) ->
  util = require("util")
  assert = require("../../lib/chai").assert
  _ = require("../../lib/underscore")
  
  Rep: class Rep extends Object
    constructor: (@info, @_manager) ->
      
    renderRecursively: (display, opts) ->
      
      
    util.accessor 'manager'
    toString: ->
      "<Rep : info = %s>".format(this.__proto__.constructor.name, @info)
  
  ContainerRep: class ContainerRep extends Rep
    
    constructor: (@info, @_manager) ->
    
    childReps: -> 
      assert.ok(@_manager)
      (@_manager.repForSoul(ch, {createIfNecessary: true}) for ch in @info.childSouls)
    
    renderRecursively: (d, opts) ->
      opts ?= {}
      super(d, opts)
      for rep in @childReps()
        assert.ok(@info)
        assert.ok(@info.geometryInParent())
        g = rep.info.geometryInParent()
        opts["geometry"] = rep.info.geometryInParent()
        rep.renderRecursively(d, opts)
  
  ItemRep: class extends Rep
    renderRecursively: (display, opts) =>
      geom = opts["geometry"] ? @info.geometry
      display.draw(geom.x, geom.y, @info.char, ROT.Color.toHex(@info.getColor()))
  
  FarmPlotRep: class extends ContainerRep
    renderRecursively: (display, opts) =>
      for x in [0..4]
        for y in [0..4]
          display.draw(@info.geometryInParent().x + x, @info.geometry.y + y, '☌', ROT.Color.toHex(@info.color))
      super(display, opts)
  
  FirmamentRep: class extends Rep
    toString: -> "FirmamentRep"
    
    renderRecursively: (display) =>
      width = display._options.width
      height = display._options.height
      for x in [0..width]
        for y in [0..height]
          display.draw(x, y, '.', ROT.Color.toHex(@info.color))
