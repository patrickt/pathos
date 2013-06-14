# Copyright (c) 2013 the Pathos team. All rights reserved.

define ['reps', 'lib/chai.js', 'lib/rot.js'], (Rep, assert) ->
  
  Plant: class
    constructor: (@geometry, @recipe) ->
      assert.assert.ok(@recipe, "Plant created with empty recipe")
    
    getColor: ->
      assert.assert.ok(@recipe)
      ROT.Color.fromString(@recipe['color'])
      
    getChar: -> @recipe['char']
    
    getRepClass: ->
      Rep.ItemRep
  
  Item: class
    constructor: (@geometry, @color, @char) ->
      
    getChar: -> @char
    getColor: -> @color
    
    getRepClass: ->
      Rep.ItemRep
  
  FarmPlot: class
    constructor: (@geometry, @color) ->
      @childInfos = []
    
    getRepClass: ->
      Rep.FarmPlotRep
    
    addInfo: (i) ->
      @childInfos.push(i)
  
  Firmament: class
    constructor: (@color) ->
      
    getRepClass: -> 
      Rep.FirmamentRep
