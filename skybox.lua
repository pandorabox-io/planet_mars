local has_skybox_mod = minetest.get_modpath("skybox")

local min_y = planet_mars.y_start
local cave_end_y = planet_mars.y_start + (planet_mars.y_height * 0.97)
local max_y = planet_mars.y_start + planet_mars.y_skybox_height

if has_skybox_mod then
	skybox.register({
		-- http://www.custommapmakers.org/skyboxes.php
		name = "mars",
		miny = cave_end_y,
		maxy = max_y,
		gravity = 0.37,
		always_day = true,
		clouds = {
			thickness=64,
			color={r=244, g=189, b=114, a=229},
			ambient={r=0, g=0, b=0, a=255},
			density=0.4,
			height=planet_mars.y_start + planet_mars.y_skybox_height - 200,
			speed={y=-2,x=-2}
		},
		textures = {
			"mars_up.jpg^[transformR270",
			"mars_dn.jpg^[transformR90",
			"mars_ft.jpg",
			"mars_bk.jpg",
			"mars_lf.jpg",
			"mars_rt.jpg"
		}
	})

	skybox.register({
		name = "mars_cave",
		miny = min_y,
		maxy = cave_end_y,
		gravity = 0.37,
		always_day = true,
		sky_type = "regular",
		sky_color = {r=244, g=189, b=114}
	})
end
