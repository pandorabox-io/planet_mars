
minetest.register_chatcommand("mars_lightup", {
	description = "restores the airlights on mars around the player position",
	func = function(name)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()

		if not planet_mars.is_pos_on_mars(pos) then
			-- TODO: only light up in mars _caves_
			return false, "You are not on mars!"
		end

		local start = minetest.get_us_time()
		local radius = 16
		-- column shape to let light propagate
		local range = {x=radius, y=radius*5, z=radius}

		local pos1 = vector.subtract(pos, range)
		local pos2 = vector.add(pos, range)

		local manip = minetest.get_voxel_manip()
		local e1, e2 = manip:read_from_map(pos1, pos2)
		local area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})
		local data = manip:get_light_data()

		for z=pos1.z, pos2.z do
		for y=pos1.y, pos2.y do
		for x=pos1.x, pos2.x do
			local index = area:index(x, y, z)
			data[index] = 14 -- MAX_LIGHT
		end
		end
		end

		manip:set_light_data(data)
		manip:write_to_map()

		local diff = minetest.get_us_time() - start
		local millis = math.floor(diff / 1000)

		return true, "light-up completed in " .. millis .. " milliseconds"
	end
})
