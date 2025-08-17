local pastafolies = {}

-- utilitaires

local R, G, B, A
function pastafolies.setColor(r, g, b, a)
  R, G, B, A = love.graphics.getColor()
  love.graphics.setColor(r, g, b, a)
end

function pastafolies.resetColor()
  love.graphics.setColor(R, G, B, A)
end

function pastafolies.reverse(pasta)
  local newPasta = {}
  for i = #pasta - 1, 1, -2 do
    table.insert(newPasta, pasta[i])
    table.insert(newPasta, pasta[i + 1])
  end
  return newPasta
end

function pastafolies.len(x, y)
  return math.sqrt(math.pow(x, 2) + math.pow(y, 2))
end

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

function pastafolies.pullPastaSegments(obstacles, pasta, from, dx, dy)
  local x, y, l, lp, ratio
  for i = from, #pasta - 2, 2 do
    l = pastafolies.len(pasta[i + 2] - pasta[i], pasta[i + 3] - pasta[i + 1]) -- longueur du segment
    x, y = pasta[i] + dx, pasta[i + 1] + dy -- nouveau point de départ
    lp = pastafolies.len(pasta[i + 2] - x, pasta[i + 3] - y) -- longueur du nouveau segment
    ratio = l / lp
    dx = x + ratio * (pasta[i + 2] - x) - pasta[i + 2]
    dy = y + ratio * (pasta[i + 3] - y) - pasta[i + 3]
    pasta[i] = x
    pasta[i + 1] = y
  end
  return dx, dy
end

function pastafolies.pullPasta(obstacles, pasta, dx, dy)
  dx, dy = pastafolies.pullPastaSegments(obstacles, pasta, 1, dx, dy)
  local newPasta = pastafolies.reverse(pasta)
  dx, dy = pastafolies.pullPastaSegments(obstacles, newPasta, 3, -dx, -dy)
  newPasta[#newPasta - 1] = newPasta[#newPasta - 1] + dx
  newPasta[#newPasta] = newPasta[#newPasta] + dy
  return pastafolies.reverse(newPasta)
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
