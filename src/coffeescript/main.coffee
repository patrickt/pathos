# Copyright (c) 2013 the Pathos team. All rights reserved.

"use strict"

requirejs.config
  baseUrl: 'src/javascript'
  
  
# Javascript, you fucking garbage fucker 

define(["soul", "player", "manager", "geometry", "narrative", "views", "calendar", "data/plants.js", "lib/rot.js", "lib/underscore.js", "lib/zepto.js"], 
  (Soul, Player, Manager, { Geometry }, Narrative, Views, Calendar, Plants) =>
    
    ROT.Display.Rect.cache = true
    @display = new ROT.Display(width: 80, height: 25, fontSize:24)
    @canvas = @display.getContainer()
    @canvas.id = "main-canvas"
    
    @firmament = new Soul.Firmament({
      geometry: new Geometry(0, 0, 80, 35, -10)
      color:    ROT.Color.fromString("goldenrod")
    })
    
    @farm = new Soul.FarmPlot {
      geometry: new Geometry(50, 10, 4, 4, 1)
      color: ROT.Color.fromString("green")
    }
    
    @testplant = new Soul.Plant {
      geometry: new Geometry(2,0, 1, 1, 2)
      recipe: Plants.marsh_beans
    }
    
    @farm.addSoul(@testplant)
    
    @player = new Player.Player {
      geometry: new Geometry(10, 10, 1, 1, 5)
    }

    @manager = new Manager.Manager {
      canvas:  @canvas
      player:  @player
      display: @display
    }
    
    @otherplant = new Soul.Plant {
      geometry: new Geometry(20, 20, 1, 1, 2),
      recipe: Plants.tridentvine
    }
    
    @view = new Views.InventoryTable {
      model: @player.inventory
      el: $('#inventory')
    }
    
    view.manager = @manager
    
    @player.inventory.add(new Soul.Plant {
      geometry: Geometry.indeterminate
      recipe: Plants.tridentvine
    })
    
    @player.inventory.add(new Soul.Plant {
      geometry: Geometry.indeterminate
      recipe: Plants.joyalflower
    })
    
    @manager.toplevelSouls.push(@firmament)
    @manager.toplevelSouls.push(@farm)
    @manager.toplevelSouls.push(@otherplant)
    
    $("#canvas-placeholder").replaceWith(@canvas)
    
    @canvas.setAttribute('tabindex', 0)
    @canvas.onclick = @clicker
    @canvas.onkeydown = (e) => @manager.keyDown(e)
    @manager.renderRecursively()
    @canvas.focus()
  )