
local c_air = minetest.get_content_id("air")
local c_airlight = minetest.get_content_id("planet_mars:airlight")

minetest.register_chatcommand("mars_lightup", {
  description = "restores the airlights on mars around the player position",
  func = function(name)
    local player = minetest.get_player_by_name(name)
    local pos = player:get_pos()

		if not planet_mars.is_pos_on_mars(pos) then
			return false, "You are not on mars!"
		end

		local radius = 16
		local range = {x=radius, y=radius, z=radius}

	  local pos1 = vector.subtract(pos, range)
	  local pos2 = vector.add(pos, range)

	  local manip = minetest.get_voxel_manip()
	  local e1, e2 = manip:read_from_map(pos1, pos2)
	  local area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})
	  local data = manip:get_data()
		local count = 0

	  for z=pos1.z, pos2.z do
	  for y=pos1.y, pos2.y do
	  for x=pos1.x, pos2.x do

	    local index = area:index(x, y, z)
			-- check for air and randomize
	    if data[index] == c_air and math.random(5) == 1 then
	      data[index] = c_airlight
				count = count + 1
	    end

	  end
	  end
	  end

	  manip:set_data(data)
	  manip:write_to_map()

		return true, "Replaced " .. count .. " air nodes with airlights " ..
			"in a " .. radius .. " node radius"
  end
})
