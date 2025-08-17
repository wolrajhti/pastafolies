local pastafolies = {}

-- construction

function pastafolies.addPoint(pasta, x, y)
  table.insert(pasta, x)
  table.insert(pasta, y)
end

function pastafolies.addObstacle(obstacles, x, y)
  table.insert(obstacles, x)
  table.insert(obstacles, y)
end

-- édition

function pastafolies.pullPasta(pasta, dx, dy)
  local x, y, l, lp, ratio
  for i = 1, #pasta - 2, 2 do
    l = math.sqrt(math.pow(pasta[i + 2] - pasta[i], 2) + math.pow(pasta[i + 3] - pasta[i + 1], 2)) -- longueur du segment
    x, y = pasta[i] + dx, pasta[i + 1] + dy -- nouveau point de départ
    lp = math.sqrt(math.pow(pasta[i + 2] - x, 2) + math.pow(pasta[i + 3] - y, 2)) -- longueur du nouveau segment
    ratio = l / lp
    dx = x + ratio * (pasta[i + 2] - x) - pasta[i + 2]
    dy = y + ratio * (pasta[i + 3] - y) - pasta[i + 3]
    pasta[i] = x
    pasta[i + 1] = y
  end
  pasta[#pasta - 1] = pasta[#pasta - 1] + dx
  pasta[#pasta] = pasta[#pasta] + dy
end

-- utilitaires

local R, G, B, A
function pastafolies.setColor(r, g, b, a)
  R, G, B, A = love.graphics.getColor()
  love.graphics.setColor(r, g, b, a)
end

function pastafolies.resetColor()
  love.graphics.setColor(R, G, B, A)
end

-- draw

function pastafolies.drawPasta(pasta)
  if #pasta > 2 then
    pastafolies.setColor(.7, 1, .7, .5)
    love.graphics.circle('fill', pasta[1], pasta[2], 5)
    pastafolies.resetColor()
    pastafolies.setColor(1, 1, 1, 1)
    love.graphics.line(pasta)
    pastafolies.resetColor()
  end
end

function pastafolies.drawObstacles(obstacles)
  pastafolies.setColor(1, .7, .7, .5)
  for i = 1, #obstacles, 2 do
    love.graphics.circle('fill', obstacles[i], obstacles[i + 1], 5)
  end
  pastafolies.resetColor()
end

return pastafolies
