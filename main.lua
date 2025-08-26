local pastafolies = require 'pastafolies'
local pasta, types = {}, {}
local obstacles = {}
local W, H
local LEN
local OX, OY, OR, OT
local DX, DY, DR, DT

function setOrigin()
  OT = math.pi * (love.math.random() * 2 - 1)
  OX, OY = pastafolies.p2c(LEN, OT)
  OX, OY = OX + W / 2, OY + H / 2
end

function setDestination()
  local mx, my = love.mouse.getPosition()
  DR, DT = pastafolies.c2p(mx - W / 2, my - H / 2)
  DX, DY = pastafolies.p2c(LEN, DT)
  DX, DY = DX + W / 2, DY + H / 2
end

function love.load()
  pastafolies.addPoint(pasta, types, 300, 400)
  pastafolies.addPoint(pasta, types, 250, 400, true)
  pastafolies.addPoint(pasta, types, 150, 400, true)
  pastafolies.addPoint(pasta, types, 100, 400)
  pastafolies.addPoint(pasta, types, 100, 300)
  pastafolies.addPoint(pasta, types, 150, 300, true)
  pastafolies.addPoint(pasta, types, 250, 300, true)
  pastafolies.addPoint(pasta, types, 300, 300)
  pastafolies.addPoint(pasta, types, 300, 200)
  pastafolies.addPoint(pasta, types, 250, 200, true)
  pastafolies.addPoint(pasta, types, 150, 200, true)
  pastafolies.addPoint(pasta, types, 100, 200)
  pastafolies.addPoint(pasta, types, 100, 100)
  pastafolies.addPoint(pasta, types, 150, 100, true)
  pastafolies.addPoint(pasta, types, 250, 100, true)
  pastafolies.addPoint(pasta, types, 300, 100)
  pastafolies.addObstacle(obstacles, 200, 150)
  pastafolies.addObstacle(obstacles, 200, 250)
  pastafolies.addObstacle(obstacles, 200, 350)
  -- W, H = love.graphics.getDimensions()
  -- LEN = math.min(W, H) / 2 - 20
  -- setOrigin()
  -- setDestination()
  -- for i = 1, 50 do
  --   pastafolies.addObstacle(obstacles, W * love.math.random(), H * love.math.random())
  -- end
end

-- local index
function love.update(dt)
  -- setDestination()
  -- index = pastafolies.firstInSweep(obstacles, W / 2, H / 2, OX, OY, DX - OX, DY - OY)
end

-- local function shortestArc(x, y, r, a1, a2)
--   -- différence directe
--   local diff = pastafolies.normalizeAngle(a2 - a1)

--   if diff <= math.pi then
--     -- a1 -> a2 sens anti-horaire
--     love.graphics.arc('fill', x, y, r, a1, a1 + diff)
--   else
--     -- a2 -> a1 sens anti-horaire (plus court)
--     love.graphics.arc('fill', x, y, r, a2, a2 + pastafolies.normalizeAngle(a1 - a2))
--   end
-- end

function love.draw()
  -- local from, to = OT, DT
  -- love.graphics.print(OT .. ' ' .. DT, 25, 25)
  -- pastafolies.setColor(.7, .7, .7, .5)
  -- shortestArc(W / 2, H / 2, LEN, OT, DT)
  -- pastafolies.resetColor()
  pastafolies.drawObstacles(obstacles)
  -- -- center
  -- pastafolies.setColor(1, 0, 0, 1)
  -- love.graphics.circle('fill', W / 2, H / 2, 5)
  -- pastafolies.resetColor()
  -- -- origin
  -- pastafolies.setColor(0, 1, 0, 1)
  -- love.graphics.circle('fill', OX, OY, 5)
  -- pastafolies.resetColor()
  -- -- destination
  -- pastafolies.setColor(0, 0, 1, 1)
  -- love.graphics.circle('fill', DX, DY, 5)
  -- pastafolies.resetColor()
  pastafolies.drawPasta(pasta, types)
  -- if index ~= nil then
  --   pastafolies.setColor(1, 1, 1, 1)
  --   love.graphics.circle('fill', obstacles[index], obstacles[index + 1], 6)
  --   pastafolies.resetColor()
  -- end
end

function love.mousemoved(x, y, dx, dy)
  if love.keyboard.isDown('lgui') then
    pasta, types = pastafolies.pullPasta(obstacles, pasta, types, dx, dy)
  end
end

function love.mousepressed(x, y)
  -- if love.keyboard.isDown('space') then
  --   pastafolies.addObstacle(obstacles, x, y)
  -- else
  --   pastafolies.addPoint(pasta, types, x, y)
  -- end
end

local DL = 10

function love.keypressed(key)
  if key == 'space' then
    setOrigin()
  elseif key == 'escape' then
    love.event.quit()
  elseif key == 'left' then
    pasta, types = pastafolies.pullPasta(obstacles, pasta, types, -DL, 0)
  elseif key == 'up' then
    pasta, types = pastafolies.pullPasta(obstacles, pasta, types, 0, -DL)
  elseif key == 'right' then
    pasta, types = pastafolies.pullPasta(obstacles, pasta, types, DL, 0)
  elseif key == 'down' then
    pasta, types = pastafolies.pullPasta(obstacles, pasta, types, 0, DL)
  end
end
