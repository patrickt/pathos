# Copyright (c) 2013 the Pathos team. All rights reserved.

requirejs.config
  baseUrl: 'src/javascript'
  enforceDefine: true
  
define ['level', 'infos', 'player', 'geometry', 'data/plants.js', 'lib/rot.js'], 
  (Level, Info, Player, Geom, Plants) ->  
    @render = =>
      @level.render(@display)
      @player.render(@display)
    
    @listener = (e) =>
      switch e.keyCode
        when ROT.VK_LEFT  then @player.geometry.x -= 1
        when ROT.VK_RIGHT then @player.geometry.x += 1
        when ROT.VK_DOWN  then @player.geometry.y += 1
        when ROT.VK_UP    then @player.geometry.y -= 1
      @level.invalidate()
      @render()
  
    @main = () =>
      ROT.Display.Rect.cache = true
      @display = new ROT.Display(width: 80, height: 25, fontSize:24)
      @canvas = @display.getContainer()
      @level = new Level.Level()
      @firmament = new Info.Firmament(ROT.Color.fromString("goldenrod"))
      
      mkgeo = (x, y) -> new Geom.Geometry(x,y)
      
      @farm = new Info.FarmPlot(mkgeo(50, 10), ROT.Color.fromString("green"))
      @farm.addInfo(new Info.Plant(mkgeo(5,5), Plants.marsh_beans))

      @level.addInfo(@firmament)
      @level.addInfo(@farm)
      @level.addInfo(new Info.Item(mkgeo(2,2), ROT.Color.fromString("yellow"), '∪'))
      
      
      @player = new Player.Player(mkgeo(10, 10))    
      document.body.appendChild(@canvas)
      @canvas.setAttribute('tabindex', 0)
      @canvas.focus()
      @render()
      @canvas.onkeydown = @listener
  
    @main()