local has_skybox_mod = minetest.get_modpath("skybox")

if has_skybox_mod then
	skybox.register({
		-- http://www.custommapmakers.org/skyboxes.php
		name = "mars",
		miny = 11000,
		maxy = 11999,
		gravity = 0.37,
		always_day = true,
		clouds = {
			thickness=16,
			color={r=244, g=189, b=114, a=229},
			ambient={r=0, g=0, b=0, a=255},
			density=0.4,
			height=11300,
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
