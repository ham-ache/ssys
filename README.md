# SSYS, SceneSystems - a love2d cross-file callbacks library.
### - `ssys.new(sceneName, toOverride, func, [order or 0], funcif?) -> void`

###### sName [any] Scene Identifier
###### toOverride [string] Callback Name
###### func [function] Your function
###### order [number?] Order inside one scene

- creates/overrides a ssys callback
### - `ssys.rem(sceneName, toOverride) -> void`

###### sName [any] Scene Identifier
###### toOverride [string] Callback Name

- removes a ssys callback

### - `ssys.call(toOverride, ...) -> void`

###### toOverride [string] Callback Name
###### args [...]

- calls every scene of your callback
- mainly used for creating custom callbacks


### - `ssys.overrideL2D() -> void`

- use in love2d to replace callback functions with ssys

### - `ssys.scenes`

- scenes table (tree: -> event -> scene)

## multiple examples in one:
```lua
ssys.new('main', 'load', function()
  ssys.call 'initglobals'
end)
ssys.new('main', 'initglobals', function()
  E = true
end)
ssys.new('main', 'initglobals', function()
  print('initialized')
end, 100)
```
