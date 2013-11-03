# Copyright (c) 2013 the Pathos team. All rights reserved.

"use strict"

define (require, exports, module) ->
  
  { Soul } = require('soul')
  { Body } = require('body')
  
  require('util')
  
  class PlayerBody extends Body
    
    renderRecursively: (display) =>
      display.draw(@soul.geometry.x, @soul.geometry.y, '@')
    
    handleEvent: (e) ->
      
      mult = if e.shiftKey then 10 else 1
      
      switch e.keyCode
        when ROT.VK_LEFT  then @geometry.x -= mult
        when ROT.VK_RIGHT then @geometry.x += mult
        when ROT.VK_DOWN  then @geometry.y += mult
        when ROT.VK_UP    then @geometry.y -= mult
        else return false
      
      manager.invalidateBodies()
    
  class Player extends Soul
    
    @observable 'inventory'
    @observable 'health'
    
    initialize: ->
      @inventory = new Backbone.Collection([], { model: Soul })
      @health = 80
    
    bodyClass: PlayerBody
    
  
  return { Player }
  
  