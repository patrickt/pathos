# Copyright (c) 2013 the Pathos team. All rights reserved.

requirejs.config
  baseUrl: 'src/javascript'
  
  
define ['level', 'infos', 'player', 'geometry', 'locus', 'manager', 'data/plants.js', 'lib/rot.js'], 
  (Level, Info, Player, Geom, Locus, Manager, Plants) ->  
      
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
    @level = new Level.Level()
    @firmament = new Info.Firmament(null, ROT.Color.fromString("goldenrod"))
    
    mkgeo = (x, y) -> new Geom.Geometry(x,y)
    
    @farm = new Info.FarmPlot(mkgeo(50, 10), ROT.Color.fromString("green"))
    @farm.addInfo(new Info.Plant(mkgeo(2,2), Plants.marsh_beans))

    @level.addInfo(@firmament)
    @level.addInfo(@farm)
    @level.addInfo(new Info.Item(mkgeo(4,4), ROT.Color.fromString("yellow"), '∪'))
    
    @manager = new Manager.Manager
      level:   @level
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