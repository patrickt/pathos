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
      @toplevelSouls = [ @player ]
      @soulsToBodies = new Hashtable()
    
    initialize: -> 
      @toplevelSouls = [ @player ]
      @soulsToBodies = new Hashtable()
    
    
    p_generateTopLevelBodies: =>
      for soul in @toplevelSouls
        unless @soulsToBodies.containsKey(soul)
          body = new (soul.bodyClass)(soul, this)
          @soulsToBodies.put(soul, body)
        
    invalidateBodies: ->
      @soulsToBodies = new Hashtable()
      @renderRecursively()
        
    bodyForSoul: (soul, opts = {}) ->
      assert.ok(soul)
      body = @soulsToBodies.get(soul)
      if opts.createIfNecessary and not body
        body = new (soul.bodyClass)(soul, this)
        @soulsToBodies.put(soul, body)
      return body
    
    keyDown: (e) ->
      switch e.keyCode
        when ROT.VK_Q
          @sow()
        when ROT.VK_E 
          @pluck()
        else
          _(@soulsToBodies.values()).map( (v) -> v.handleEvent(e))
    
    pluck: ->
      pos = @player.geometry
      item = @recursivelyHitTest(pos.origin).soul
      if item and not item.isFixed
        alert('YOU HAVE GAINED A %s!'.format(item.get('recipe').displayName))
        @removeSoulRecursively(item)
        item.geometry = Geometry.indeterminate
        @player.inventory.add(item)
        
    sow: ->
      rep = @recursivelyHitTest(player.geometry.origin)
      
      if @player.inventory.isEmpty()
        alert("Nothin' to plant, chief")
        return
      
      if rep.soul instanceof Soul.FarmPlot
        [x, y] = @player.geometry.origin
        toPlant = @player.inventory.pop()
        xc = x - rep.geometry.x
        yc = y - rep.geometry.y
        toPlant.geometry = new Geometry(xc, yc, 1, 1, 1)
        rep.soul.addSoul(toPlant)
        @renderRecursively()
      
    
    removeSoulRecursively: (e) ->
      if e in @toplevelSouls
        @toplevelSouls = _.without(@toplevelSouls, e)
      else
        soul.removeSoulRecursively(e) for soul in @toplevelSouls
    
    renderRecursively: (display) ->
      @p_generateTopLevelBodies()
      @bodyForSoul(soul, createIfNecessary: true).renderRecursively(@display) for soul in _(@toplevelSouls).sortBy( (s) -> s.geometry.z)
          
    recursivelyHitTest: (pt) ->
      souls = _(@toplevelSouls).sortBy('geometry.z').reverse()
      for soul in souls
        body = this.bodyForSoul(soul)
        hitBody = body.recursivelyHitTest(pt)
        if hitBody then return hitBody
      null
  
  return { Manager }