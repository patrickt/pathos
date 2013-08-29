"use strict"

define ['lib/underscore.js'], ->
  Function::property = (prop, desc) ->
    Object.defineProperty(@prototype, prop, desc)
  
  Function::observable = (prop) ->
    Object.defineProperty(@prototype, prop,
      get: -> @get(prop)
      set: (arg) -> @set(prop, arg))