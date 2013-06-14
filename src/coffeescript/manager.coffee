
define ['lib/underscore.js'], ->
  Manager: class 
    constructor: (options) ->
      {@level, @canvas} = options
    
    @hitTest: (x, y) ->
      for entity in @level.reps
        entity.recursivelyHitTest(x, y)