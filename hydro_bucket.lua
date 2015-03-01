-- Hydroponic Bucket

local pipeworks_mod = minetest.get_modpath("pipeworks")
local homedecor_mod = minetest.get_modpath("homedecor")

-- Settings --
local wet_dry_speed = 10	-- How fast the hydroponic medium dries or gets wet
local wet_dry_chance = 2	-- Chance of hydroponic medium drying out or getting wet

function hydroponics.pipes(pos)
	if pipeworks_mod then
		pipeworks.scan_for_pipe_objects(pos)
	else
		return
	end
end

function hydroponics.water_check(pos, node)
	local nx1 = minetest.get_node({ x=pos.x-1, y=pos.y  , z=pos.z   })
	local nx2 = minetest.get_node({ x=pos.x+1, y=pos.y  , z=pos.z   })
	local nz1 = minetest.get_node({ x=pos.x  , y=pos.y  , z=pos.z-1 })
	local nz2 = minetest.get_node({ x=pos.x  , y=pos.y  , z=pos.z+1 })
	local ny1 = minetest.get_node({ x=pos.x  , y=pos.y-1  , z=pos.z })
	if pipeworks_mod then
		-- Check if pipes have water.
		if (string.find(nx1.name, "pipeworks:") and string.find(nx1.name, "_loaded"))
			or (string.find(nx2.name, "pipeworks:") and string.find(nx2.name, "_loaded"))
			or (string.find(nz1.name, "pipeworks:") and string.find(nz1.name, "_loaded"))
			or (string.find(nz2.name, "pipeworks:") and string.find(nz2.name, "_loaded"))
			or (string.find(ny1.name, "pipeworks:") and string.find(ny1.name, "_loaded")) then
				if node.name ~= "hydroponics:bucket_dry" then
					return
				else
					minetest.set_node(pos, {name = "hydroponics:bucket_wet"})
				end
		else
			minetest.set_node(pos, {name = "hydroponics:bucket_dry"})
		end
	else
		-- Check for water group right next to bucket.
		if minetest.get_item_group(nx1.name, "water") ~= 0
			or minetest.get_item_group(nx2.name, "water") ~= 0
			or minetest.get_item_group(nz1.name, "water") ~= 0
			or minetest.get_item_group(nz2.name, "water") ~= 0
			or minetest.get_item_group(ny1.name, "water") ~= 0 then
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

-- Dry Hydro-Bucket
minetest.register_node("hydroponics:bucket_dry", {
	description = "Hydroponic Bucket",
	tiles = {"default_gravel.png^hydroponics_bucket_top.png", "hydroponics_bucket_sides.png"},
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

-- Wet Hydro-Bucket
minetest.register_node("hydroponics:bucket_wet", {
	description = "Hydroponic Bucket (Wet)",
	tiles = {"hydroponics_wet_gravel.png^hydroponics_bucket_top.png", "hydroponics_bucket_sides.png"},
	sunlight_propagates = false,
	paramtype = "light",
	walkable = true,
	drop = "hydroponics:bucket_dry",
	groups = {snappy = 2, soil = 3, grassland = 1, desert = 1, hydroponic_medium = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = function(pos)
		hydroponics.pipes(pos)
	end,
	after_dig_node = function(pos)
		hydroponics.pipes(pos)
	end,
})

if homedecor_mod or pipeworks_mod then
	-- Hydro-Bucket Craft (With Homedecor or Pipeworks)
	minetest.register_craft({
		output = "hydroponics:bucket_dry",
		recipe = {
			{ "homedecor:plastic_sheeting", "dye:black", "homedecor:plastic_sheeting" },
			{ "homedecor:plastic_sheeting", "default:gravel", "homedecor:plastic_sheeting" },
			{ "homedecor:plastic_sheeting", "homedecor:plastic_sheeting", "homedecor:plastic_sheeting" },
        },
	})

else
	-- Hydro-Bucket Craft (Without Homedecor or Pipeworks)
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
	action = function(pos, node, active_object_count, active_object_count_wider)
		hydroponics.water_check(pos, node)
	end,
})
