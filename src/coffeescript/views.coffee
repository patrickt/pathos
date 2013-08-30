# Copyright (c) 2013 the Pathos team. All rights reserved.

"use strict"

define (require, exports, module) ->
  require('lib/backbone.js')
  require('lib/zepto.js')
  
  class InventoryTable extends Backbone.View
    
    tagName: "div"
    id: "inventory"
    
    initialize: ->
      @listenTo(@model, "add", @render);
      @listenTo @model, "remove", (item) ->
        this.$el.children().eq(-1).remove()
    
    render: (item) ->
      this.$el.append($("<p>").html(item.get('recipe').displayName)) if item and item.get('recipe')
      
    stopListening: ->
      super
      @stopListening(@model)
    
  return { InventoryTable }