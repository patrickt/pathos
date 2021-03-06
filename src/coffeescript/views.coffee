# Copyright (c) 2013 the Pathos team. All rights reserved.

"use strict"

define (require, exports, module) ->
  require('lib/backbone.js')
  require('lib/zepto.js')
  require('util')
  
  class InventoryTable extends Backbone.View
    
    @property: 'manager'
    
    tagName: "div"
    id: "inventory"
    
    initialize: ->
      @listenTo(@model, "add", @render)
      @listenTo(@model, "remove", @render)
    
    render: (item, allItems) ->
      this.$el.empty()
      allItems.map( (i) => 
        @manager.bodyForSoul(i, createIfNecessary:true).renderHTML(this.$el))
  
  class HealthDisplay extends Backbone.View
    
    tagName: "div"
    id: "health"
    
    initialize: ->
      @render @model
      @listenTo(@model, "change", @render)
    
    render: (p) ->
      this.$el.text("your health is #{p.health}")
    
  return { InventoryTable, HealthDisplay }