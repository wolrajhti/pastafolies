local pastafolies = require 'pastafolies'
local pasta = {}
local obstacles = {}

function love.load()
  pastafolies.addPoint(pasta, 100, 300)
  pastafolies.addPoint(pasta, 300, 300)
  pastafolies.addPoint(pasta, 300, 100)
  pastafolies.addPoint(pasta, 100, 100)
  pastafolies.addObstacle(obstacles, 200, 150)
  pastafolies.addObstacle(obstacles, 200, 250)
  pastafolies.addObstacle(obstacles, 200, 350)
end

function love.update(dt)
end

function love.draw()
  pastafolies.drawObstacles(obstacles)
  pastafolies.drawPasta(pasta)
end

function love.mousemoved(x, y, dx, dy)
  if love.keyboard.isDown('lgui') then
    pastafolies.pullPasta(pasta, dx, dy)
  end
end

function love.mousepressed(x, y)
  -- if love.keyboard.isDown('space') then
  --   pastafolies.addObstacle(obstacles, x, y)
  -- else
  --   pastafolies.addPoint(pasta, x, y)
  -- end
end
