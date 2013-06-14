# Copyright (c) 2013 the Pathos team. All rights reserved.

GeneralRep = GeneralRep ? {}

define
  GeneralRep: class GeneralRep extends Object
    toString: ->
      "<Rep : info = %s>".format(this.__proto__.constructor.name, @info)
  
  ItemRep: class extends GeneralRep
    constructor: (@info) ->
    
    render: (display) =>
      display.draw(@info.geometry.x, @info.geometry.y, @info.getChar(), ROT.Color.toHex(@info.getColor()))
  
  FarmPlotRep: class extends GeneralRep
    constructor: (@info) ->
    
    render: (display) =>
      for x in [0..4]
        for y in [0..4]
          display.draw(@info.geometry.x + x, @info.geometry.y + y, '☌', ROT.Color.toHex(@info.color))
      for info in @info.childInfos
        klass = info.getRepClass()
        rep = new klass(info)
        rep.render(display)
  
  FirmamentRep: class extends GeneralRep
    constructor: (@info) ->
    
    toString: -> "FirmamentRep"
    
    render: (display) =>
      width = display._options.width
      height = display._options.height
      for x in [0..width]
        for y in [0..height]
          display.draw(x, y, '.', ROT.Color.toHex(@info.color))
