
define ['util', 'lib/underscore.js', 'lib/jshashtable.js'], (util) ->
  Manager: class 
    constructor: (options) ->
      {@level, @canvas, @player, @display} = options
      @_toplevelSouls = []
      @infosToReps = new Hashtable
      
    util.accessor 'toplevelSouls'
    
    p_generateTopLevelReps: =>
      for soul in @toplevelSouls
        rep = new (soul.repClass)(soul, this)
        @infosToReps.put(soul, rep)
        
    repForSoul: (soul, opts) ->
      rep = @infosToReps.get(soul)
      if (not rep) and opts["createIfNecessary"]
        rep = new (soul.repClass)(soul, this)
        @infosToReps.put(soul, rep)
      return rep
        
      
    renderRecursively: ->
      @p_generateTopLevelReps()
      for info in @_toplevelSouls
        rep = @repForSoul(info, { createIfNeeded: true })
        rep.renderRecursively(display)
      @player.render(@display)
    
    hitTest: (x, y) ->
      for entity in @infosToReps.values()
        entity.recursivelyHitTest(x, y)