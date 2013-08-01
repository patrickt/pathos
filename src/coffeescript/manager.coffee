"use strict"

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
    
    keyDown: (e) ->
      switch e.keyCode
        when ROT.VK_LEFT  then @player.geometry.x -= 1
        when ROT.VK_RIGHT then @player.geometry.x += 1
        when ROT.VK_DOWN  then @player.geometry.y += 1
        when ROT.VK_UP    then @player.geometry.y -= 1
        when ROT.VK_S     then alert('Sowing a seed')
        when ROT.VK_E     then @pluck()
      @renderRecursively()
      
    pluck: ->
      pos = @player.geometry
      plant = @recursivelyHitTest(pos.x, pos.y).soul
      unless plant.isFixed
        alert('YOU HAVE GAINED A %s!'.format(plant.displayName))
        @removeSoulRecursively(plant)
    
    removeSoulRecursively: (e) ->
      if e in @toplevelSouls
        @_toplevelSouls = _.without(@toplevelSouls, e)
      else
        soul.removeSoulRecursively(e) for soul in @_toplevelSouls
    
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