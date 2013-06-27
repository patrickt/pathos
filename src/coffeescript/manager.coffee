
define ['util', 'lib/underscore.js', 'lib/jshashtable.js'], (util) ->
  Manager: class 
    constructor: (options) ->
      {@level, @canvas, @player, @display} = options
      @_toplevelSouls = []
      @soulsToBodies = new Hashtable
      
    util.accessor 'toplevelSouls'
    
    p_generateTopLevelBodies: =>
      for soul in @toplevelSouls
        body = new (soul.bodyClass)(soul, this)
        @soulsToBodies.put(soul, body)
        
    bodyForSoul: (soul, opts) ->
      body = @soulsToBodies.get(soul)
      if (not body) and opts["createIfNecessary"]
        body = new (soul.bodyClass)(soul, this)
        @soulsToBodies.put(soul, body)
      return body
        
      
    renderRecursively: ->
      @p_generateTopLevelBodies()
      for soul in @_toplevelSouls
        body = @bodyForSoul(soul, { createIfNeeded: true })
        body.renderRecursively(display)
      @player.render(@display)
    
    hitTest: (x, y) ->
      hitBody = null
      for entity in @soulsToBodies.values()
        hitBody = entity.recursivelyHitTest(x, y)
        if hitBody
          break
      hitBody