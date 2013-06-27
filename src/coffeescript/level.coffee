# Copyright (c) 2013 the Pathos team. All rights reserved.

define ['bodies', 'lib/underscore.js'], ->
  Level: class extends Object
    constructor: ->
      @soulsToDisplay = []

    addSoul: (f) =>
      @soulsToDisplay.push(f)
    
    
