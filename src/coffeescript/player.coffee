# Copyright (c) 2013 the Pathos team. All rights reserved.

"use strict"

define (require, exports, module) ->
  
  { Soul } = require('soul')
  { Body } = require('body')
  
  class PlayerBody extends Body
    
    renderRecursively: (display) =>
      display.draw(@soul.geometry.x, @soul.geometry.y, '@')
    
    handleEvent: (e) ->
      switch e.keyCode
        when ROT.VK_LEFT  then @geometry.x -= 1
        when ROT.VK_RIGHT then @geometry.x += 1
        when ROT.VK_DOWN  then @geometry.y += 1
        when ROT.VK_UP    then @geometry.y -= 1
        else return false
      
      manager.invalidateBodies()
    
  class Player extends Soul
    bodyClass: PlayerBody
    
  
  return { Player }
  
  