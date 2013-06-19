# Copyright (c) 2013 the Pathos team. All rights reserved.

requirejs.config
  baseUrl: 'src/javascript'
  
  
define ['soul', 'player', 'geometry', 'locus', 'manager', 'data/plants.js', 'lib/rot.js'], 
  (Soul, Player, Geom, Locus, Manager, Plants) ->  
      
    @clicker = (e) =>
      [x, y] = @display.eventToPosition(e)
      alert('x = ' + x + ', y =' + y)
    
    @listener = (e) =>
      switch e.keyCode
        when ROT.VK_LEFT  then @manager.player.geometry.x -= 1
        when ROT.VK_RIGHT then @manager.player.geometry.x += 1
        when ROT.VK_DOWN  then @manager.player.geometry.y += 1
        when ROT.VK_UP    then @manager.player.geometry.y -= 1
        when ROT.VK_S     then alert('Sowing a seed')
      @manager.renderRecursively()
  
    ROT.Display.Rect.cache = true
    @display = new ROT.Display(width: 80, height: 25, fontSize:24)
    @canvas = @display.getContainer()
    @firmament = new Soul.Firmament(null, ROT.Color.fromString("goldenrod"))
    
    mkgeo = (x, y) -> new Geom.Geometry(x,y)
    
    @farm = new Soul.FarmPlot(mkgeo(50, 10), ROT.Color.fromString("green"))
    @farm.addSoul(new Soul.Plant(mkgeo(2,0), Plants.marsh_beans))

    @manager = new Manager.Manager
      canvas:  @canvas
      player:  new Player.Player(mkgeo(10, 10))
      display: @display
    
    @manager.toplevelSouls.push(@firmament)
    @manager.toplevelSouls.push(@farm)
    
    document.body.appendChild(@canvas)
    @canvas.setAttribute('tabindex', 0)
    @canvas.focus()
    @canvas.onclick = @clicker
    @canvas.onkeydown = @listener
    @manager.renderRecursively()