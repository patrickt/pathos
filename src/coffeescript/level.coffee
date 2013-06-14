# Copyright (c) 2013 the Pathos team. All rights reserved.

define ['reps', 'lib/underscore.js'], ->
  Level: class extends Object
    constructor: ->
      @infosToDisplay = []
      @reps = []
      @valid = false

    addInfo: (f) =>
      @infosToDisplay.push(f)
      @invalidate()
    
    invalidate: =>
      @valid = false
      @p_generateReps()
    
    p_generateReps: =>
      _.each @infosToDisplay, (info) =>
        klass = info.getRepClass()
        rep = new klass(info)
        @reps.push(rep)

    render: (display) =>
      @p_generateReps()
      for rep in @reps
        rep.render(display)
      
    
    
