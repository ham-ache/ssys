# SSYS, SceneSystems - a love2d cross-file callbacks library.
### - `ssys.new(sceneName, toOverride, func, [order or 0], funcif?) -> void`

###### sName [any] Scene Identifier
###### toOverride [string] Callback Name
###### func [function] Your function
###### order [number?] Order inside one scene
###### condition [function?] Condition on which scene will execute

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


### - `ssys.data(sceneName, toOverride) -> void`

###### sName [any] Scene Identifier
###### toOverride [string] Callback Name

- returns {func, order}

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
end, 100, function() return E == true end)
```
