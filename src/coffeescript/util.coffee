"use strict"

Function::property = (prop, desc) ->
  Object.defineProperty(@prototype, prop, desc)

define ['lib/underscore.js'], ->
  
  accessor: (prop, varname, desc) ->
    varname ?= '_' + prop
    desc ?= {}
    defaults = 
      get: -> return this[varname]
      set: (x) -> this[varname] = x

    Object.defineProperty(this.__proto__, prop, _.extend(defaults, desc))