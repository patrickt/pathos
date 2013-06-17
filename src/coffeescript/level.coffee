# Copyright (c) 2013 the Pathos team. All rights reserved.

define ['reps', 'lib/underscore.js'], ->
  Level: class extends Object
    constructor: ->
      @infosToDisplay = []

    addInfo: (f) =>
      @infosToDisplay.push(f)
    
    
