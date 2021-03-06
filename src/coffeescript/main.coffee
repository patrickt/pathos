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
      geometry: new Geometry([0, 0, -10], [80, 35])
      color:    ROT.Color.fromString("rgb(10, 180, 10)")
    })
    
    console.log(@firmament.z)
    
    @farm = new Soul.FarmPlot {
      geometry: new Geometry([50, 10, 1], [4, 4])
      color: ROT.Color.fromString("saddlebrown")
    }
    
    @testplant = new Soul.Plant {
      geometry: new Geometry([2,0,2])
      recipe: Plants.christ_berries
    }
    
    @farm.addSoul(@testplant)
    
    @player = new Player.Player {
      geometry: new Geometry([10, 10, 5])
    }
    
    @player.save

    @manager = new Manager.Manager {
      canvas:  @canvas
      player:  @player
      display: @display
    }
    
    @otherplant = new Soul.Plant {
      geometry: new Geometry([20, 20, 2], [1, 1]),
      recipe: Plants.amaranthine
    }
    
    @view = new Views.InventoryTable {
      model: @player.inventory
      el: $('#inventory')
    }
    
    @health = new Views.HealthDisplay { 
      model: @player
      el: $('#health')
    }
    
    view.manager = @manager
    
    @player.inventory.add(new Soul.Plant {
      geometry: Geometry.indeterminate
      recipe: Plants.amaranthine
    })
    
    @player.inventory.add(new Soul.Plant {
      geometry: Geometry.indeterminate
      recipe: Plants.devil_grass
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