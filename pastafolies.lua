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

function pastafolies.reverse(pasta, types)
  local newPasta, newTypes = {}, {}
  for i = #pasta - 1, 1, -2 do
    table.insert(newPasta, pasta[i])
    table.insert(newPasta, pasta[i + 1])
  end
  for i = #types, 1, -1 do
    table.insert(newTypes, types[i])
  end
  return newPasta, newTypes
end

function pastafolies.len(x, y)
  return math.sqrt(math.pow(x, 2) + math.pow(y, 2))
end

function pastafolies.p2c(r, t)
  return r * math.cos(t), r * math.sin(t)
end

function pastafolies.c2p(x, y)
  return pastafolies.len(x, y), math.atan2(y, x)
end

function pastafolies.normalizeAngle(a)
  return a % (2 * math.pi)
end

function pastafolies.diffAngle(a, b)
  local d = pastafolies.normalizeAngle(b - a)
  if d > math.pi then
    return d - 2 * math.pi
  end
  return d
end

function pastafolies.firstInSweep(obstacles, cx, cy, sx, sy, dx, dy)
  local sr, st = pastafolies.c2p(sx - cx, sy - cy)
  local _, et = pastafolies.c2p(sx - cx + dx, sy - cy + dy)
  local d = pastafolies.diffAngle(st, et)
  local r, t, best_i, best_delta = nil, nil, nil, nil

  for i = 1, #obstacles - 1, 2 do
    r, t = pastafolies.c2p(obstacles[i] - cx, obstacles[i + 1] - cy)
    local delta = pastafolies.diffAngle(st, t)
    if r < sr and
      (
        (d >= 0 and delta >= 0 and delta <= math.abs(d)) or
        (d < 0  and delta <= 0 and delta >= -math.abs(d))
      ) and
      (
        not best_delta or
        math.abs(delta) < math.abs(best_delta)
      )
    then
      best_i, best_delta = i, delta
    end
  end

  return best_i
end

-- construction

function pastafolies.addPoint(pasta, types, x, y, t)
  table.insert(pasta, x)
  table.insert(pasta, y)
  types[#pasta / 2] = t or false
end

function pastafolies.addObstacle(obstacles, x, y)
  table.insert(obstacles, x)
  table.insert(obstacles, y)
end

-- édition

function pastafolies.pullPastaSegments(obstacles, pasta, types, from, dx, dy)
  local x, y, l, lp, ratio --, index
  local i = from
  while i < #pasta - 2 do
    -- index = pastafolies.firstInSweep(obstacles, pasta[i + 2], pasta[i + 3], pasta[i], pasta[i + 1], dx, dy)
    -- if index then
    --   print('collision', index)
    -- end
    l = pastafolies.len(pasta[i + 2] - pasta[i], pasta[i + 3] - pasta[i + 1]) -- longueur du segment
    x, y = pasta[i] + dx, pasta[i + 1] + dy -- nouveau point de départ
    lp = pastafolies.len(pasta[i + 2] - x, pasta[i + 3] - y) -- longueur du nouveau segment
    ratio = l / lp
    dx = x + ratio * (pasta[i + 2] - x) - pasta[i + 2]
    dy = y + ratio * (pasta[i + 3] - y) - pasta[i + 3]
    pasta[i] = x
    pasta[i + 1] = y
    i = i + 2
  end
  return dx, dy
end

function pastafolies.pullPasta(obstacles, pasta, types, dx, dy)
  dx, dy = pastafolies.pullPastaSegments(obstacles, pasta, types, 1, dx, dy)
  local newPasta, newTypes = pastafolies.reverse(pasta, types)
  dx, dy = pastafolies.pullPastaSegments(obstacles, newPasta, newTypes, 3, -dx, -dy)
  newPasta[#newPasta - 1] = newPasta[#newPasta - 1] + dx
  newPasta[#newPasta] = newPasta[#newPasta] + dy
  return pastafolies.reverse(newPasta, newTypes)
end

-- draw

function pastafolies.drawPasta(pasta, types)
  if #pasta > 2 then
    pastafolies.setColor(.7, .7, .7, .5)
    for i, t in ipairs(types) do
      if t then
        love.graphics.rectangle('fill', pasta[i * 2 - 1] - 6, pasta[i * 2] - 6, 12, 12)
      else
        love.graphics.circle('fill', pasta[i * 2 - 1], pasta[i * 2], 4)
      end
    end
    pastafolies.resetColor()
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
