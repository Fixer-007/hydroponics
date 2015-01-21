-- Hydroponic Grow Light

-- Can be used with mesecons or (without mesecons) punched to turn on.
-- Can be placed two nodes above soil/medium.
-- If placed two nodes above soil/medium then nothing can be placed one node under it.

local grow_light_rules = {
	-- X
	{x=1,	y=0,	z=0},
	{x=-1,	y=0,	z=0},
	-- XY
	{x=1,	y=1,	z=0},
	{x=1,	y=-1,	z=0},
	{x=-1,	y=1,	z=0},
	{x=-1,	y=-1,	z=0},
	-- Y
	{x=0,	y=-1,	z=0},
	{x=0,	y=1,	z=0},
	-- Z
	{x=0,	y=0,	z=-1},
	{x=0,	y=0,	z=1},
	-- ZY
	{x=0,	y=1,	z=-1},
	{x=0,	y=-1,	z=-1},
	{x=0,	y=1,	z=1},
	{x=0,	y=-1,	z=1},
}

minetest.register_node("hydroponics:grow_light_off", {
	description = "Hydroponic Grow Light",
	tiles = {"hydroponics_grow_light_ts.png", "hydroponics_grow_light_b_off.png", "hydroponics_grow_light_ts.png"},
	groups = {snappy = 2},
	sounds = default.node_sound_stone_defaults(),
	on_punch = function(pos, node, puncher, pointed_thing)
		if not minetest.get_modpath("mesecons") then
			minetest.set_node(pos, {name = "hydroponics:grow_light_on"})
		else
			return
		end
	end,
	on_construct = function(pos)
		if minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "air" then
			minetest.set_node({x=pos.x, y=pos.y-1, z=pos.z}, {name = "hydroponics:light_off"})
		end
	end,
	on_destruct = function(pos)
		if minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "hydroponics:light_off" then
			minetest.set_node({x=pos.x, y=pos.y-1, z=pos.z}, {name = "air"})
		end
	end,
	mesecons = {effector = {
		rules = grow_light_rules,
		action_on = function (pos, node)
			minetest.set_node(pos, {name = "hydroponics:grow_light_on"})
		end,
	}}
})

minetest.register_node("hydroponics:grow_light_on", {
	description = "Hydroponic Grow Light (On)",
	tiles = {"hydroponics_grow_light_ts.png", "hydroponics_grow_light_b_on.png", "hydroponics_grow_light_ts.png"},
	light_source = 14,
	drop = "hydroponics:grow_light_off",
	groups = {snappy = 2, not_in_creative_inventory = 1},
	sounds = default.node_sound_stone_defaults(),
	on_punch = function(pos, node, puncher, pointed_thing)
		if not minetest.get_modpath("mesecons") then
			minetest.set_node(pos, {name = "hydroponics:grow_light_off"})
		else
			return
		end
	end,
	on_construct = function(pos)
		if minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "air" then
			minetest.set_node({x=pos.x, y=pos.y-1, z=pos.z}, {name = "hydroponics:light_on"})
		end
	end,
	on_destruct = function(pos)
		if minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "hydroponics:light_on" then
			minetest.set_node({x=pos.x, y=pos.y-1, z=pos.z}, {name = "air"})
		end
	end,
	mesecons = {effector = {
		rules = grow_light_rules,
		action_off = function (pos, node)
			minetest.set_node(pos, {name = "hydroponics:grow_light_off"})
		end,
	}}
})

minetest.register_node("hydroponics:light_on", {
	description = "Hydroponic Grow Light (Air On)",
	drawtype = "airlike",
	paramtype = "light",
	light_source = 14,
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	groups = {not_in_creative_inventory=1},
})

minetest.register_node("hydroponics:light_off", {
	description = "Hydroponic Grow Light (Air Off)",
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	groups = {not_in_creative_inventory=1},
})

if not minetest.get_modpath("moreblocks") then

	minetest.register_craft({
		output = "hydroponics:grow_light_off",
		recipe = {
			{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
			{ "default:steel_ingot", "default:torch", "default:steel_ingot" },
			{ "default:steel_ingot", "default:torch", "default:steel_ingot" },
        },
	})

else

	minetest.register_craft({
		output = "hydroponics:grow_light_off",
		recipe = {
			{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
			{ "default:steel_ingot", "moreblocks:super_glow_glass", "default:steel_ingot" },
			{ "default:steel_ingot", "", "default:steel_ingot" },
        },
	})

end
