
-- decos for mars caves

if minetest.get_modpath("bamboo") then
	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.005,
			scale = 0.001,
			spread = {x = 240, y = 240, z = 240},
			seed = 2776,
			octaves = 3,
			persist = 0.65
		},
		biomes = {"grassland"},
		y_min = planet_mars.y_start,
		y_max = planet_mars.y_start + planet_mars.y_height,
		schematic = bamboo.bambootree,
		flags = "place_center_x, place_center_z",
	})
end