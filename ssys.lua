-- 'Scene Systems' Cross-file callbacks library by hamache | Github: @ham-ache
local ipairs, type, mathFloor , assert, setmetatable, rawset = 
      ipairs, type, math.floor, assert, setmetatable, rawset
local _ENV = nil
local l2d_override = {
  'draw',
  'load',
  'lowmemory',
  'quit',
  'threaderror',
  'update',
  'directorydropped',
  'displayrotated',
  'filedropped',
  'focus',
  'mousefocus',
  'resize',
  'visible',
  'keypressed',
  'keyreleased',
  'textedited',
  'textinput',
  'mousemoved',
  'mousepressed',
  'mousereleased',
  'wheelmoved',
  'gamepadaxis',
  'gamepadpressed',
  'gamepadreleased',
  'joystickadded',
  'joystickaxis',
  'joystickhat',
  'joystickpressed',
  'joystickreleased',
  'joystickremoved',
  'touchmoved',
  'touchpressed',
  'touchreleased',
}

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
-- took neccessary parts of Tieske's binary heap (https://github.com/Tieske) --
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

-- i have rewritten this part 3 times.
-- somehow, THIS is the reason behind double-triple speed.
local lt = function(a, b) return a < b end
 
local function swap(self, a, b)
  self.order[a], self.order[b] = self.order[b], self.order[a]
  local pla, plb = self.scene[a], self.scene[b]
  self.reverse[pla], self.reverse[plb] = b, a
  self.scene[a], self.scene[b] = plb, pla
end

local function erase(self, pos)
  self.reverse[self.scene[pos]] = nil
  self.scene[pos] = nil
  self.order[pos] = nil
end

local function float(self, pos)
  local orders = self.order
  while pos > 1 do
    local parent = mathFloor(pos/2)
    if not lt(orders[pos], orders[parent]) then
        break
    end
    self:swap(parent, pos)
    pos = parent
  end
end

local function sink(self, pos)
  local orders = self.order
  local last = #orders
  while true do
    local min = pos
    local child = 2 * pos
    for c = child, child + 1 do
      if c <= last and lt(orders[c], orders[min]) then min = c end
    end
    if min == pos then break end
    self:swap(pos, min)
    pos = min
  end
end

local function update(self, pos, order)
  assert(pos >= 1 and pos <= #self.order, 'ssys: binheap => illegal position')
  self.order[pos] = order
  if pos > 1 then self:float(pos) end
  if pos < #self.order then self:sink(pos) end
end

local function push(self, order, sceneName)
  do
    local here = self.reverse[sceneName]
    if here ~= nil then
      if order ~= self.order[here] then
        update(self, here, order)
      end
      return
    end 
  end
  local pos = #self.order + 1
  self.reverse[sceneName] = pos
  self.scene[pos] = sceneName
  self.order[pos] = order
  self:float(pos)
end

local function remove(self, sceneName)
  local pos = self.reverse[sceneName]
  local last = #self.order
  if pos < last then
    local v = self.order[pos]
    self:swap(pos, last)
    self:erase(last)
    self:float(pos)
    self:sink(pos)
  elseif pos == last then
    local v = self.order[pos]
    self:erase(last)
  end
end

local function heapSpawn()
  return {
    order = {},
    scene = {},
    reverse = {},
    swap = swap,
    erase = erase,
    float = float,
    sink = sink,
    push = push,
    remove = remove
  }
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--

local heapStack = setmetatable({}, {
  __index = function(t, key)
    local new = heapSpawn()
    rawset(t, key, new)
    return new
  end,
})
local scenes = setmetatable({}, {
  __index = function(t, key)
    local new = {}
    rawset(t, key, new)
    return new
  end,
})

local function new(sceneName, event, callback, order)
  assert(event ~= nil, 'ssys.new: 2nd argument => unexpected nil')
  assert(type(callback) == 'function', 'ssys.new: 3rd argument => function expected')
  scenes[event][sceneName] = callback
  heapStack[event]:push(order or 0, sceneName)
end 

local function rem(sceneName, event)
  scenes[event][sceneName] = nil
  heapStack[event]:remove(sceneName)
end

local function call(event, ...)
  local heap = heapStack[event]
  for x = 1, #heap.order do
    local sc = heap.scene[x]
    if not sc then break end
    if scenes[event][sc] then
      scenes[event][sc](...)
    end
  end
end

local function clear(event)
  heapStack[event] = nil
  scenes[event] = nil
end

local function overrideL2D()
  for x = 1, #l2d_override do
    local name = l2d_override[x]
    love[name] = function(...)
      call(name, ...)
    end
  end
end

local function fetchScenes()
  return scenes
end

local function fetchEventsHeap()
  return heapStack
end

return {
  new = new,
  rem = rem,
  call = call,
  clear = clear,
  overrideL2D = overrideL2D,
  scenes = fetchScenes,
  eventsHeap = fetchEventsHeap
}