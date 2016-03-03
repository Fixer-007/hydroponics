local pipeworks_mod = minetest.get_modpath("pipeworks")

local wet_dry_speed = 10
local wet_dry_chance = 2

function hydroponics.pipes(pos)
	if pipeworks_mod then
		pipeworks.scan_for_pipe_objects(pos)
	else
		return
	end
end

function hydroponics.check_water(pos, node)
	local nx1 = minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z})
	local nx2 = minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z})
	local nz1 = minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1})
	local nz2 = minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1})
	local ny1 = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
	if pipeworks_mod then
		if string.find(nx1.name, "pipeworks:") and
				string.find(nx1.name, "_loaded") or
				string.find(nx2.name, "pipeworks:") and
				string.find(nx2.name, "_loaded") or
				string.find(nz1.name, "pipeworks:") and
				string.find(nz1.name, "_loaded") or
				string.find(nz2.name, "pipeworks:") and
				string.find(nz2.name, "_loaded") or
				string.find(ny1.name, "pipeworks:") and
				string.find(ny1.name, "_loaded") then
			if node.name ~= "hydroponics:bucket_dry" then
				return
			else
				minetest.set_node(pos, {name = "hydroponics:bucket_wet"})
			end
		else
			minetest.set_node(pos, {name = "hydroponics:bucket_dry"})
		end
	else
		if minetest.get_item_group(nx1.name, "water") ~= 0 or
				minetest.get_item_group(nx2.name, "water") ~= 0 or
				minetest.get_item_group(nz1.name, "water") ~= 0 or
				minetest.get_item_group(nz2.name, "water") ~= 0 or
				minetest.get_item_group(ny1.name, "water") ~= 0 then
			if node.name ~= "hydroponics:bucket_dry" then
				return
			else
				minetest.set_node(pos, {name = "hydroponics:bucket_wet"})
			end
		else
			minetest.set_node(pos, {name = "hydroponics:bucket_dry"})
		end
	end
end

minetest.register_node("hydroponics:bucket_dry", {
	description = "Hydroponic Bucket",
	tiles = {
		"default_gravel.png^hydroponics_bucket_top.png",
		"hydroponics_bucket_sides.png"
	},
	sunlight_propagates = false,
	paramtype = "light",
	walkable = true,
	groups = {snappy = 2, soil = 2, grassland = 1, desert = 1, hydroponic_medium = 1},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = function(pos)
		hydroponics.pipes(pos)
	end,
	after_dig_node = function(pos)
		hydroponics.pipes(pos)
	end,
})

minetest.register_node("hydroponics:bucket_wet", {
	description = "Hydroponic Bucket (Wet)",
	tiles = {
		"hydroponics_wet_gravel.png^hydroponics_bucket_top.png",
		"hydroponics_bucket_sides.png"
	},
	sunlight_propagates = false,
	paramtype = "light",
	walkable = true,
	drop = "hydroponics:bucket_dry",
	groups = {snappy = 2, soil = 3, grassland = 1, desert = 1, hydroponic_medium = 1,
			not_in_creative_inventory = 1},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = function(pos)
		hydroponics.pipes(pos)
	end,
	after_dig_node = function(pos)
		hydroponics.pipes(pos)
	end,
})

if pipeworks_mod then
	local plastic = "homedecor:plastic_sheeting"
	minetest.register_craft({
		output = "hydroponics:bucket_dry",
		recipe = {
			{plastic, "dye:black", plastic},
			{plastic, "default:gravel", plastic},
			{plastic, plastic, plastic},
        },
	})

else
	minetest.register_craft({
		output = "hydroponics:bucket_dry",
		recipe = {
			{ "group:leaves", "dye:black", "group:leaves" },
			{ "group:leaves", "default:gravel", "group:leaves" },
			{ "group:leaves", "group:leaves", "group:leaves" },
        },
	})
end

minetest.register_abm({
	nodenames = {"group:hydroponic_medium"},
	interval = wet_dry_speed,
	chance = wet_dry_chance,
	action = function(pos, node)
		hydroponics.check_water(pos, node)
	end,
})
