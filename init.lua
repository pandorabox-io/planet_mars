planet_mars = {
	-- technic EU storage value
	y_start = tonumber(minetest.settings:get("planet_mars.y_start")) or 11000,
	y_height = tonumber(minetest.settings:get("planet_mars.y_height")) or 500,
}

dofile(MP.."/mapgen.lua")
dofile(MP.."/skybox.lua")

print("[OK] Planet: mars")
