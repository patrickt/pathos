
define (require, exports, module ) ->
  
  require("../../lib/jshashtable")
  util = require("util")
  assert = require("../../lib/chai").assert
  require('lib/underscore.js')
  
  Manager: class 
    constructor: (options) ->
      {@canvas, @player, @display} = options
      assert.ok(@canvas, "needs canvas")
      assert.ok(@player, "needs player")
      assert.ok(@display, "needs display")
      @_toplevelSouls = []
      @soulsToBodies = new Hashtable
      
    util.accessor('toplevelSouls')
    
    p_generateTopLevelBodies: =>
      for soul in @toplevelSouls
        body = new (soul.bodyClass)(soul, this)
        @soulsToBodies.put(soul, body)
        
    bodyForSoul: (soul, opts = {}) ->
      body = @soulsToBodies.get(soul)
      if (not body) and opts.createIfNecessary
        body = new (soul.bodyClass)(soul, this)
        @soulsToBodies.put(soul, body)
      return body
        
      
    renderRecursively: ->
      @p_generateTopLevelBodies()
      for soul in @_toplevelSouls
        body = @bodyForSoul(soul, { createIfNecessary: true })
        body.renderRecursively(@display)
      @player.render(@display)
    
    recursivelyHitTest: (x, y) ->
      hitBody = null
      souls = _.sortBy(@_toplevelSouls, 'zOrdering')
      souls.reverse()
      for soul in souls
        body = this.bodyForSoul(soul)
        hitBody = body.recursivelyHitTest(x, y)
        if hitBody
          break
      hitBody