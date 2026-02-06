# SSYS, SceneSystems - a love2d cross-file callbacks library.
### - `ssys.new(sceneName, event, callback, order or 0) -> void`

- creates/overrides a scene
###### sceneName [any] Scene Identifier
###### event [any] Event
###### callback [function] Your function
###### order [number or nil] Scene priority (descending)
### - `ssys.rem(sceneName, event) -> void`

- remove scene
###### sceneName [any] Scene Identifier
###### event [any] Event
### - `ssys.call(event, ...) -> void`

- calls every scene binded to an event
- basically, activates the event and passes varargs to scenes' callbacks
###### event [any] Event
###### varargs [any] Arguments passed to event's callbacks
### - `ssys.clear(event) -> void`

- remove event's heap and its scenes
###### event [any] Event
### - `ssys.overrideL2D() -> void`

- use in love2d to replace callback functions with ssys
### - `ssys.scenes()`

- returns a table of scenes
- tree: -> event -> scene
### - `ssys.eventsHeap()`

- returns a table of events' heap
- tree: -> eventHeap -> order{}, sOrder{}, scene{}
## example:
```lua
local ssys = require 'ssys'
ssys.overrideL2D()
ssys.new('main', 'load', function()
  ssys.call 'initglobals'
end)
ssys.new('main', 'initglobals', function()
  E = 1
  io.write('\ninitialized\n')
end, 5)
ssys.new('main1', 'initglobals', function()
  ssys.clear 'initglobals'
  -- this scene is the last to execute in 'initglobals' event:
  -- has priority of 10, the last to execute
  -- removes the event entirely after it was called
end, 15)
ssys.new('main', 'update', function(dt)
  io.write(dt, '\n')
  E = E + 1
  if E > 25 then
    ssys.rem('main', 'update')
  end
end)
```
