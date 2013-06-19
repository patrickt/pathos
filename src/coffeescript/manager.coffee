
define ['lib/underscore.js', 'lib/jshashtable.js'], ->
  Manager: class 
    constructor: (options) ->
      {@level, @canvas, @player, @display} = options
      @infosToReps = new Hashtable
    
    p_generateReps: =>
      for info in @level.infosToDisplay
        rep = new (info.repClass)(info)
        @infosToReps.put(info, rep)
      
    renderAll: ->
      @p_generateReps()
      for rep in @infosToReps.values()
        rep.render(display)
      @player.render(@display)
    
    hitTest: (x, y) ->
      for entity in @infosToReps.values()
        entity.recursivelyHitTest(x, y)