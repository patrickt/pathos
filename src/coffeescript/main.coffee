# Copyright (c) 2013 the Pathos team. All rights reserved.

"use strict"

requirejs.config
  baseUrl: 'src/javascript'
  
  
# Javascript, you fucking garbage fucker 

define(["soul", "player", "manager", "geometry", "narrative", "data/plants.js", "lib/rot.js", "lib/underscore.js", "lib/zepto.js"], 
  (Soul, Player, Manager, { Geometry }, Narrative, Plants) =>
  
    @clicker = (e) =>
      # [x, y] = @display.eventToPosition(e)
      # alert('x = ' + x + ', y =' + y)
      # fudge = @manager.recursivelyHitTest(x,y)
      # if fudge
      #   alert(fudge.toString())

    ROT.Display.Rect.cache = true
    @display = new ROT.Display(width: 80, height: 25, fontSize:24)
    @canvas = @display.getContainer()
    @canvas.id = "main-canvas"
    
    @firmament = new Soul.Firmament(new Geometry(0, 0, 80, 25), ROT.Color.fromString("goldenrod"))
    @farm = new Soul.FarmPlot(new Geometry(50, 10, 4, 4), ROT.Color.fromString("green"))
    @farm.addSoul(new Soul.Plant(new Geometry(2,0), Plants.marsh_beans))

    @manager = new Manager.Manager
      canvas:  @canvas
      player:  new Player.Player(new Geometry(10, 10))
      display: @display
    
    
    @manager.toplevelSouls.push(@firmament)
    @manager.toplevelSouls.push(@farm)
    @manager.toplevelSouls.push(new Soul.Plant(new Geometry(20, 20), Plants.tridentvine))
    
    $("#canvas-placeholder").replaceWith(@canvas)
    @manager.invalidateInventory()
    
    @canvas.setAttribute('tabindex', 0)
    @canvas.onclick = @clicker
    @canvas.onkeydown = (e) => @manager.keyDown(e)
    @manager.renderRecursively()
    @canvas.focus()
  )