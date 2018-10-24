local has_bedrock_mod = minetest.get_modpath("bedrock")

-- http://dev.minetest.net/PerlinNoiseMap

-- basic planet height noise
local base_params = {
   offset = 0,
   scale = 1,
   spread = {x=1024, y=512, z=1024},
   seed = 3468584,
   octaves = 5,
   persist = 0.6
}

-- ore params
local ore_params = {
   offset = 0,
   scale = 1,
   spread = {x=128, y=64, z=128},
   seed = 935472,
   octaves = 4,
   persist = 0.6
}

local c_base = minetest.get_content_id("default:desert_stone")
local c_air = minetest.get_content_id("air")
local c_ignore = minetest.get_content_id("ignore")
local c_vacuum = minetest.get_content_id("vacuum:vacuum")
local c_clay = minetest.get_content_id("default:clay")
local c_bedrock

if has_bedrock_mod then
	c_bedrock = minetest.get_content_id("bedrock:bedrock")
end

local y_min = 11000
local y_max = 11280
local y_diff = y_max - y_min


minetest.register_on_generated(function(minp, maxp, seed)

	if minp.y < y_min or minp.y > y_max then
		return
	end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()

	local is_solid = minp.y < y_min+100

	local side_length = maxp.x - minp.x + 1 -- 80
	local map_lengths_xyz = {x=side_length, y=side_length, z=side_length}

	local base_perlin_map = minetest.get_perlin_map(base_params, map_lengths_xyz):get3dMap_flat(minp)
	local ore_perlin_map = minetest.get_perlin_map(ore_params, map_lengths_xyz):get3dMap_flat(minp)

	local i = 1

	for z=minp.z,maxp.z do
	for y=minp.y,maxp.y do
	for x=minp.x,maxp.x do

		local index = area:index(x,y,z)

		if y >= y_min and y < y_min+10 and has_bedrock_mod then
			data[index] = c_bedrock

		elseif data[index] == c_air or data[index] == c_vacuum or data[index] == c_ignore then
			-- unpopulated node

			-- higher elevation = lower chance
			local chance = (y-minp.y) / side_length

			local base_n = math.min(0, base_perlin_map[i] + 1)
			local ore_n = ore_perlin_map[i]

			if is_solid or base_n > chance then
				-- basic material
				data[index] = c_base
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
