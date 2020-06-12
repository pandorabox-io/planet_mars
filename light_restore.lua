
local y_start = planet_mars.y_start
local y_height = planet_mars.y_height

-- airlight restoration abm
-- slowly reclaims dark spaces on mars
minetest.register_abm({
  label = "space vacuum",
	nodenames = {"air"},
	neighbors = {"planet_mars:airlight"},
	interval = 20,
	chance = 5000,
	action = function(pos)

		if pos.y < y_start or pos.y > (y_start + y_height) then
			-- not on mars
			return
		end

		minetest.set_node(pos, {name = "planet_mars:airlight"})
	end
})
