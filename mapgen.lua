local has_bedrock_mod = minetest.get_modpath("bedrock")

-- http://dev.minetest.net/PerlinNoiseMap
-- https://github.com/pyrollo/cratermg/blob/master/init.lua (thx Pyrollo:)


-- basic planet height noise
local height_params = {
	offset = 0,
	scale = 5,
	spread = {x=256, y=256, z=256},
	seed = 5477835,
	octaves = 2,
	persist = 0.5
}

-- mountain noise
local mountain_params = {
	offset = 0,
	scale = 5,
	spread = {x=256, y=256, z=256},
	seed = 34252,
	octaves = 3,
	persist = 0.5
}

-- clay noise
local clay_params = {
	offset = 0,
	scale = 1,
	spread = {x=32, y=64, z=64},
	seed = 981364,
	octaves = 2,
	persist = 0.5
}

-- TODO: caves with air


--XXX local c_base = minetest.get_content_id("default:desert_stone")
local c_base = minetest.get_content_id("default:glass")
local c_stone = minetest.get_content_id("default:desert_stone")
local c_sand = minetest.get_content_id("default:desert_sand")
local c_air = minetest.get_content_id("air")
local c_ignore = minetest.get_content_id("ignore")
local c_clay = minetest.get_content_id("default:clay")
local c_bedrock = c_base

if has_bedrock_mod then
	c_bedrock = minetest.get_content_id("bedrock:bedrock")
end

local y_start = planet_mars.y_start
local y_height = planet_mars.y_height

-- perlin noise
local height_perlin
local mountain_perlin
local clay_perlin

-- reuse maps
local height_perlin_map = {}
local mountain_perlin_map = {}
local clay_perlin_map = {}

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

	height_perlin = height_perlin or minetest.get_perlin_map(height_params, map_lengths_xyz)
	mountain_perlin = mountain_perlin or minetest.get_perlin_map(mountain_params, map_lengths_xyz)
	clay_perlin = clay_perlin or minetest.get_perlin_map(clay_params, map_lengths_xyz)

	height_perlin:get2dMap_flat({x=minp.x, y=minp.z}, height_perlin_map)
	mountain_perlin:get2dMap_flat({x=minp.x, y=minp.z}, mountain_perlin_map)
	clay_perlin:get3dMap_flat(minp, clay_perlin_map)

	local perlin_index = 1
	local height_fill_factor = 0.8
	local height_hill_factor = 1 - height_fill_factor

	for z=minp.z,maxp.z do
	for x=minp.x,maxp.x do

		-- normalized factor from 0...1
		local height_perlin_factor = math.min(1, math.abs( height_perlin_map[perlin_index] * 0.1 ) )
		local mountain_perlin_factor = math.min(1, math.abs( mountain_perlin_map[perlin_index] * 0.18 ) )

		-- weighted hill top and solid bottom
		local abs_height = y_start + (y_height * 0.99) + (y_height * height_perlin_factor * 0.01)
		local abs_mountain_height = y_start + (y_height * 0.9) + (y_height * mountain_perlin_factor * 0.1)
		
		for y=minp.y,maxp.y do
			local index = area:index(x,y,z)

			if y <  y_start + 10 then
				-- bedrock (if available)
				data[index] = c_bedrock

			elseif y < abs_height then
				-- solid
				data[index] = c_base

			elseif y < abs_mountain_height then
				-- mountain
				data[index] = c_stone

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
 
	perlin_index = 1

	-- generate ores
	for z=minp.z,maxp.z do
	for y=minp.y,maxp.y do
	for x=minp.x,maxp.x do
		local index = area:index(x,y,z)

		if math.abs(clay_perlin_map[perlin_index]) > 0.5 and data[index] == c_base then
			-- clay
			data[index] = c_clay
		end

		perlin_index = perlin_index + 1
	end --x
	end --y
	end --z
 
 
	vm:set_data(data)
	vm:write_to_map()

end)


