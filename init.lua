local has_technic_mod = minetest.get_modpath("technic")
local has_vacuum_mod = minetest.get_modpath("vacuum")
local has_bedrock_mod = minetest.get_modpath("bedrock")

-- http://dev.minetest.net/PerlinNoiseMap

-- basic planet material noise
local base_params = {
   offset = 0,
   scale = 1,
   spread = {x=1024, y=512, z=1024},
   seed = 5468562,
   octaves = 5,
   persist = 0.6
}

-- ore params
local ore_params = {
   offset = 0,
   scale = 1,
   spread = {x=128, y=64, z=128},
   seed = 5455472,
   octaves = 4,
   persist = 0.6
}

local c_base = minetest.get_content_id("default:desert_stone")
local c_air = minetest.get_content_id("air")
local c_ignore = minetest.get_content_id("ignore")
local c_vacuum
local c_bedrock

local ores = {}
local min_chance = 1 -- everything below is stone

local register_ore = function(def)
	table.insert(ores, def)
	min_chance = math.min(def.chance, min_chance)
end

if has_bedrock_mod then
	c_bedrock = minetest.get_content_id("bedrock:bedrock")
end

if has_vacuum_mod then

	c_vacuum = minetest.get_content_id("vacuum:vacuum")
	register_ore({
		id = c_vacuum,
		chance = 1
	})

else
	register_ore({
		id = minetest.get_content_id("air"),
		chance = 1
	})
end

-- TODO: chernobylite in the center
-- TODO: ores around it (dessertstone-ores)
-- https://github.com/minetest/minetest_game/blob/e10e0f94d6339cef1f38e27acd98cf85d8e5fef5/mods/default/nodes.lua#L1134

register_ore({
	id = minetest.get_content_id("default:stone_with_diamond"),
	chance = 0.998
})

register_ore({
	id = minetest.get_content_id("default:stone_with_iron"),
	chance = 0.9
})

register_ore({
	id = minetest.get_content_id("default:ice"),
	chance = 0.45
})

if has_technic_mod then

	register_ore({
		id = minetest.get_content_id("technic:mineral_lead"),
		chance = 0.7
	})

	register_ore({
		id = minetest.get_content_id("technic:mineral_sulfur"),
		chance = 0.6
	})

end

-- sort ores
table.sort(ores, function(a,b)
	return b.chance < a.chance
end)

minetest.register_on_generated(function(minp, maxp, seed)

	if minp.y < 11000 or minp.y > 11280 then
		return
	end

	-- solid layer
	local is_solid = minp.y < 11200

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()

	local side_length = maxp.x - minp.x + 1 -- 80
	local map_lengths_xyz = {x=side_length, y=side_length, z=side_length}

	local base_perlin_map = minetest.get_perlin_map(base_params, map_lengths_xyz):get3dMap_flat(minp)
	local ore_perlin_map = minetest.get_perlin_map(ore_params, map_lengths_xyz):get3dMap_flat(minp)

	local i = 1
	local ore_count = 0
	for z=minp.z,maxp.z do
	for y=minp.y,maxp.y do
	for x=minp.x,maxp.x do

		local index = area:index(x,y,z)

		if y >= 11000 and y < 11010 and has_bedrock_mod then
			data[index] = c_bedrock

		elseif data[index] == c_air or data[index] == c_vacuum or data[index] == c_ignore then
			-- unpopulated node

			-- higher elevation = lower chance
			local chance = (y-minp.y) / side_length

			local base_n = base_perlin_map[i]
			local ore_n = ore_perlin_map[i]

			if is_solid or base_n > chance then

				if ore_n < min_chance then
					-- basic material
					data[index] = c_base
					ore_count = ore_count + 1

				else
					-- ore material
					data[index] = c_base
					for _,ore in pairs(ores) do
						if ore_n > ore.chance then
							data[index] = ore.id
							ore_count = ore_count + 1
							break
						end
					end
				end
			end
		end

		i = i + 1

	end --x
	end --y
	end --z
 
	vm:set_data(data)
	vm:write_to_map()

end)


print("[OK] Planet: mars")
