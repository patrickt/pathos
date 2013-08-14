define (require, exports, module) ->
  require('lib/adt.js')
  require('lib/underscore.js')
  {data, any, only} = adt
  
  RoleMap = { name: only(String) }
  Role = data
    Hero: 
      RoleMap
    Donor: 
      RoleMap
    Helper: 
      RoleMap
    Sought: 
      RoleMap
    Dispatcher: 
      RoleMap
    Rival:
      RoleMap
    Villain: 
      RoleMap
    FalseHero: 
      RoleMap
    
  Role::toString = -> "hi"
  
  characters = 
    [ Role.Hero("Kitsurugu")
    , Role.Dispatcher("Irisveil")
    , Role.Helper("Saber")
    , Role.Villain("Kirei")
    , Role.Rival("Waver")
    , Role.Helper("Iskandar")
    ]
  
  choice = (arr) -> arr[_.random(arr.length - 1)]
    
  adtChoice = (typ) -> typ[choice(typ.__names__)]
  
  Narrative = data
    Narrative:
      Characters: only(Array)
      Introduction: only(Array)
      Exposition: only(Array)
      Conclusion: only(Ending)
  
  PlotPoint = data
    PlotPoint:
      action: any
      from: only(Role)
      to: only(Role)
  
  pointChoice = (action) ->
    from = choice(characters)
    to = choice(_.reject(characters, (chr) -> chr == from))
    PlotPoint.PlotPoint(adtChoice(action), from, to)
  
  arrayOf = (fun, times) ->
    (fun() for ii in [0..times])
  
  PlotPoint.PlotPoint::toString = ->
    "%s %s %s".format(@from.toString(), @action.toString().toLowerCase(), @to.toString())
  
  RisingAction = adt.enum("Interdicts"
                    , "SpiesUpon"
                    , "LearnsAbout"
                    , "Deceives"
                    , "Harms"
                    , "StrugglesWith"
                    , "Wounds"
                    , "Pursues"
                    , "Slanders"
                    , "Exposes")
  

  Ending = adt.enum("Vanquishes"
                  , "Punishes"
                  , "Slays")
  
  sample = ->
    conflicts = arrayOf( (-> pointChoice(RisingAction)), 4)
    ending = arrayOf( (-> pointChoice(Ending)), 2)
    console.log(x.toString()) for x in conflicts
    console.log(y.toString()) for y in ending
  
  return { sample, arrayOf, characters, choice, Role, PlotPoint: PlotPoint.PlotPoint, Narrative: Narrative.Narrative, RisingAction, Ending, pointChoice }