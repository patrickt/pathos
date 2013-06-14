# Copyright (c) 2013 the Pathos team. All rights reserved.

define
  Player: class
    constructor: (@geometry) ->
  
    render: (display) =>
      display.draw(@geometry.x, @geometry.y, '@')