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
  E = E + 1
  if E%10 == 0 then
    ssys.new('e1', 'draw', function()
      love.graphics.setColor(1, 0, 0)
      love.graphics.rectangle('fill', 0, 0, 50, 50)
    end, 50)
    ssys.new('e2', 'draw', function()
      love.graphics.setColor(0, 1, 0)
      love.graphics.rectangle('fill', 20, 20, 50, 50)
    end, E)
    for x, v in pairs(ssys.scenes.draw) do
      io.write(x, '\n')
    end
  end
end)