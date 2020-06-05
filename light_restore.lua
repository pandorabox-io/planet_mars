-- proof of concept light restore
-- XXX: unstable, unfinished, things may explode

local c_air = minetest.get_content_id("air")
local c_airlight = minetest.get_content_id("planet_mars:airlight")

local timer = 0

minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 2 then
    return
  end
  timer = 0

	print("light recalc")
	for _, player in ipairs(minetest.get_connected_players()) do
    -- TODO: check if player is in mars and in a cave (perlin noise)
    local pos = player:get_pos()
    local distance = 8

		local pos1 = vector.subtract(pos, distance)
		local pos2 = vector.add(pos, distance)

		local manip = minetest.get_voxel_manip()
	  local minp, maxp = manip:read_from_map(pos1, pos2)
	  local area = VoxelArea:new({MinEdge=minp, MaxEdge=maxp})

    local data = manip:get_data()

		for z=minp.z,maxp.z do
		for y=minp.y,maxp.y do
		for x=minp.x,maxp.x do
			local index = area:index(x,y,z)
      if data[index] == c_air then
        data[index] = c_airlight
      end
		end --x
		end --y
		end --z

    manip:set_data(data)
		manip:write_to_map()

	end
end)
