local y_start = planet_mars.y_start
local y_height = planet_mars.y_height

-- returns true if the pos is on the mars layer
function planet_mars.is_pos_on_mars(pos)
  return pos.y > y_start and pos.y < (y_start + y_height)
end
