local has_bedrock_mod = minetest.get_modpath("bedrock")

-- http://dev.minetest.net/PerlinNoiseMap
-- https://github.com/pyrollo/cratermg/blob/master/init.lua (thx Pyrollo:)


-- basic planet height noise
local height_params = {
	offset = 0,
	scale = 5,
	spread = {x=256, y=256, z=256},
	seed = 1337,
	octaves = 2,
	persist = 0.5
}

local c_base = minetest.get_content_id("default:desert_stone")
local c_sand = minetest.get_content_id("default:desert_sand")
local c_air = minetest.get_content_id("air")
local c_ignore = minetest.get_content_id("ignore")
local c_clay = minetest.get_content_id("default:clay")
local c_bedrock

if has_bedrock_mod then
	c_bedrock = minetest.get_content_id("bedrock:bedrock")
end

local y_start = planet_mars.y_start
local y_height = planet_mars.y_height


minetest.register_on_generated(function(minp, maxp, seed)

	if minp.y < y_start or minp.y > (y_start + y_height) then
		-- not in range
		return
	end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()

	local side_length = maxp.x - minp.x + 1 -- 80
	local map_lengths_xyz = {x=side_length, y=side_length, z=side_length}

	local height_perlin_map = minetest.get_perlin_map(height_params, map_lengths_xyz):get2dMap_flat({x=minp.x, y=minp.z})


	local perlin_index = 1
	local height_fill_factor = 0.8
	local height_hill_factor = 1 - height_fill_factor

	for z=minp.z,maxp.z do
	for x=minp.x,maxp.x do

		-- normalized factor from 0...1
		local perlin_factor = math.min(1, math.abs( height_perlin_map[perlin_index] * 0.2 ) )

		-- weighted hill top and solid bottom
		local abs_height = y_start + (y_height * 0.9) + (y_height * perlin_factor * 0.1)
		
		for y=minp.y,maxp.y do
			local index = area:index(x,y,z)

			if y < abs_height then
				-- solid
				data[index] = c_base

			elseif y < abs_height + 2 then
				-- top layer
				data[index] = c_sand

			else
				-- non-solid
				data[index] = c_air
			end

		end --y

		perlin_index = perlin_index + 1
	end --x
	end --z
 
 
	vm:set_data(data)
	vm:write_to_map()

end)


