"use strict"



define ['lib/underscore.js'], ->
  Function::property = (prop, desc) ->
    Object.defineProperty(@prototype, prop, desc)