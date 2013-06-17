
define ['lib/underscore.js'], ->
  Manager: class 
    constructor: (options) ->
      {@level, @canvas, @player, @reps, @display} = options
    
    p_generateReps: =>
      @reps = []
      for info in @level.infosToDisplay
        klass = info.getRepClass()
        rep = new klass(info)
        @reps.push(rep)
      
    renderAll: ->
      @p_generateReps()
      for rep in @reps
        rep.render(@display)
      @player.render(@display)
    
    hitTest: (x, y) ->
      for entity in @level.reps
        entity.recursivelyHitTest(x, y)