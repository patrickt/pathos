"use strict"

define (require, exports, module ) ->
  
  require("lib/jshashtable.js")
  require('lib/underscore.js')
  require('lib/zepto.js')
  
  assert       = require('lib/chai.js').assert
  util         = require("util")
  Soul         = require ("soul")
  { Geometry } = require("geometry")
  
  plants = require("data/plants.js")
  
  
  class Manager
    constructor: (options) ->
      {@canvas, @player, @display} = options
      assert.ok(@canvas, "needs canvas")
      assert.ok(@player, "needs player")
      assert.ok(@display, "needs display")
      @toplevelSouls = []
      @soulsToBodies = new Hashtable
    
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
        when ROT.VK_S     then @sow()
        when ROT.VK_E     then @pluck()
      @renderRecursively()
      
    invalidateInventory: ->
      for key in _.keys(plants)
        el = document.createTextNode(plants[key].displayName)
        console.log(el)
        $("#inventory").append(el)
      
    pluck: ->
      pos = @player.geometry
      plant = @recursivelyHitTest(pos.x, pos.y).soul
      unless plant.isFixed
        alert('YOU HAVE GAINED A %s!'.format(plant.displayName))
        @removeSoulRecursively(plant)
        
    sow: ->
      [x, y] = [@player.geometry.x, @player.geometry.y]
      rep = @recursivelyHitTest(x, y)
      if rep.soul instanceof Soul.FarmPlot
        xc = x - rep.geometry.x
        yc = y - rep.geometry.y
        plant = new Soul.Plant(new Geometry(xc, yc, 1, 1), plants.marsh_beans)
        rep.soul.addSoul(plant)
        @renderRecursively()
      else if rep.soul instanceof Soul.Firmament
        plant = new Soul.Plant(new Geometry(x, y, 1, 1), plants.tridentvine)
        @toplevelSouls.push(plant)
        @renderRecursively()
      
    
    removeSoulRecursively: (e) ->
      if e in @toplevelSouls
        @toplevelSouls = _.without(@toplevelSouls, e)
      else
        soul.removeSoulRecursively(e) for soul in @toplevelSouls
    
    renderRecursively: ->
      @p_generateTopLevelBodies()
      for soul in @toplevelSouls
        body = @bodyForSoul(soul, { createIfNecessary: true })
        body.renderRecursively(@display)
      @player.render(@display)
    
    recursivelyHitTest: (x, y) ->
      hitBody = null
      souls = _.sortBy(@toplevelSouls, 'zOrdering')
      souls.reverse()
      for soul in souls
        body = this.bodyForSoul(soul)
        hitBody = body.recursivelyHitTest(x, y)
        if hitBody
          break
      hitBody
  
  return { Manager }