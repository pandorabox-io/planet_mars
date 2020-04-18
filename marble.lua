
for _, color in ipairs({"red", "blue", "black"}) do

	minetest.register_craft({
		output = "planet_mars:" .. color .. "marble_polished",
		recipe = {
			{"planet_mars:" .. color .. "marble"},
		}
	})

	minetest.register_craft({
		output = "planet_mars:" .. color .. "marble_bricks 4",
		recipe = {
			{"planet_mars:" .. color .. "marble", "planet_mars:" .. color .. "marble"},
			{"planet_mars:" .. color .. "marble", "planet_mars:" .. color .. "marble"},
		}
	})

	minetest.register_node("planet_mars:" .. color .. "marble_polished", {
		description = "polished " .. color .. " marble",
		tiles = {"planet_mars_" .. color .. "marble_polished.png"},
		is_ground_content = true,
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_node("planet_mars:" .. color .. "marble_bricks", {
		description = color .. " marble bricks",
		tiles = {"planet_mars_" .. color .. "marble_bricks.png"},
		is_ground_content = true,
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_node("planet_mars:" .. color .. "marble", {
		description = color .. " marble",
		tiles = {"planet_mars_" .. color .. "marble.png"},
		is_ground_content = true,
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "planet_mars:" .. color .. "marble",
		wherein        = "default:desert_stone",
		clust_scarcity = 7*7*7,
		clust_num_ores = 5,
		clust_size     = 5,
		y_max          = planet_mars.y_start + planet_mars.y_height,
		y_min          = planet_mars.y_start,
	})

	stairsplus:register_all("planet_mars", color .. "marble",  "planet_mars:" .. color .. "marble", {
	  description = color .. " marble",
	  tiles = {"planet_mars_" .. color .. "marble.png"},
	  groups = {cracky=3}
	})

	stairsplus:register_all("planet_mars", color .. "marble_bricks",  "planet_mars:" .. color .. "marble_bricks", {
	  description = color .. " marble bricks",
	  tiles = {"planet_mars_" .. color .. "marble_bricks.png"},
	  groups = {cracky=3}
	})

	stairsplus:register_all("planet_mars", color .. "marble_polished",  "planet_mars:" .. color .. "marble_polished", {
	  description = color .. " marble polished",
	  tiles = {"planet_mars_" .. color .. "marble_polished.png"},
	  groups = {cracky=3}
	})

end
