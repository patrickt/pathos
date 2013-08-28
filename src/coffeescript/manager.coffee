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
      body = @soulsToBodies.get(soul)
      if opts.createIfNecessary and not body
        body = new (soul.bodyClass)(soul, this)
        @soulsToBodies.put(soul, body)
      return body
    
    keyDown: (e) ->
      switch e.keyCode
        when ROT.VK_
          @sow()
        when ROT.VK_E 
          @pluck()
        else
          _(@soulsToBodies.values()).map( (v) -> v.handleEvent(e))
      
    invalidateInventory: ->
      # $("#inventory").empty()
      # for key in _.keys(plants)
      #   ident = plants[key].identifier
      #   $("#inventory").append($("<input type='radio' name='selected' id='#{ident}'>"))
      #   $("#inventory").append($("<label for='#{ident}'>#{plants[key].displayName}</label>"))
      #   $("#inventory").append($("<br>"))
      # $("#inventory").children(':first-child').prop('defaultChecked', true)
      
    pluck: ->
      pos = @player.geometry
      item = @recursivelyHitTest(pos.x, pos.y).soul
      if item and not item.isFixed
        alert('YOU HAVE GAINED A %s!'.format(plant.displayName))
        @removeSoulRecursively(plant)
        
    sow: ->
      [x, y] = [@player.geometry.x, @player.geometry.y]
      rep = @recursivelyHitTest(x, y)
      toPlant = plants["marsh_beans"]
      
      if rep.soul instanceof Soul.FarmPlot
        xc = x - rep.geometry.x
        yc = y - rep.geometry.y
        plant = new Soul.Plant(new Geometry(xc, yc, 1, 1, 1), plants[toPlant])
        rep.soul.addSoul(plant)
        @renderRecursively()
      
    
    removeSoulRecursively: (e) ->
      if e in @toplevelSouls
        @toplevelSouls = _.without(@toplevelSouls, e)
      else
        soul.removeSoulRecursively(e) for soul in @toplevelSouls
    
    renderRecursively: (display) ->
      @p_generateTopLevelBodies()
      @bodyForSoul(soul, createIfNecessary: true).renderRecursively(@display) for soul in _(@toplevelSouls).sortBy( (s) -> s.geometry.z)
          
    recursivelyHitTest: (x, y) ->
      souls = _(@toplevelSouls).sortBy('geometry.z').reverse()
      for soul in souls
        body = this.bodyForSoul(soul)
        hitBody = body.recursivelyHitTest(x, y)
        if hitBody then return hitBody
      null
  
  return { Manager }