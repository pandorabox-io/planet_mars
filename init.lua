planet_mars = {
	-- technic EU storage value
	y_start = tonumber(minetest.settings:get("planet_mars.y_start")) or 11000,
	y_height = tonumber(minetest.settings:get("planet_mars.y_height")) or 500,
	y_skybox_height = tonumber(minetest.settings:get("planet_mars.y_skybox_height")) or 1000,
}

local MP = minetest.get_modpath("planet_mars")
dofile(MP.."/mapgen.lua")
dofile(MP.."/skybox.lua")

print("[OK] Planet: mars (start: " .. planet_mars.y_start .. ", height:" .. planet_mars.y_height .. ")")
