local has_vacuum_mod = minetest.get_modpath("vacuum")

local y_start = planet_mars.y_start
local y_height = planet_mars.y_height


if has_vacuum_mod then

	local old_is_pos_in_space = vacuum.is_pos_in_space
	vacuum.is_pos_in_space = function(pos)

		if pos.y < y_start or pos.y > (y_start + y_height) then
			-- not on mars
			return old_is_pos_in_space(pos)
		end

		local leafpos = minetest.find_node_near(pos, 3, {"group:leafdecay"})
		if leafpos then
			-- param2: 1=manually placed
			-- https://github.com/minetest/minetest_game/blob/master/mods/default/functions.lua#L404
			local leafnode = minetest.get_node(leafpos)
			if leafnode.param2 == 0 then
				-- found a grown leaf, should be attached to a tree
				return false
			end
		end

		local dirtpos = minetest.find_node_near(pos, 2, {"default:dirt_with_grass", "default:dirt"})
		if dirtpos then
			return false
		end

		return old_is_pos_in_space(pos)
	end


end
