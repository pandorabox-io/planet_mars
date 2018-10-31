local has_skybox_mod = minetest.get_modpath("skybox")

if has_skybox_mod then
	skybox.register({
		-- http://www.custommapmakers.org/skyboxes.php
		name = "mars",
		miny = planet_mars.y_start,
		maxy = planet_mars.y_start + planet_mars.y_height,
		gravity = 0.37,
		always_day = true,
		clouds = {
			thickness=16,
			color={r=244, g=189, b=114, a=229},
			ambient={r=0, g=0, b=0, a=255},
			density=0.4,
			height=planet_mars.y_start + planet_mars.y_skybox_height,
			speed={y=-2,x=0}
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
end
