
define ['util', 'lib/underscore.js', 'lib/jshashtable.js'], (util) ->
  Manager: class 
    constructor: (options) ->
      {@level, @canvas, @player, @display} = options
      @_toplevelSouls = []
      @soulsToReps = new Hashtable
      
    util.accessor 'toplevelSouls'
    
    p_generateTopLevelReps: =>
      for soul in @toplevelSouls
        rep = new (soul.repClass)(soul, this)
        @soulsToReps.put(soul, rep)
        
    repForSoul: (soul, opts) ->
      rep = @soulsToReps.get(soul)
      if (not rep) and opts["createIfNecessary"]
        rep = new (soul.repClass)(soul, this)
        @soulsToReps.put(soul, rep)
      return rep
        
      
    renderRecursively: ->
      @p_generateTopLevelReps()
      for soul in @_toplevelSouls
        rep = @repForSoul(soul, { createIfNeeded: true })
        rep.renderRecursively(display)
      @player.render(@display)
    
    hitTest: (x, y) ->
      hitRep = null
      for entity in @soulsToReps.values()
        hitRep = entity.recursivelyHitTest(x, y)
        if hitRep
          break
      hitRep