local mesecons_mod = minetest.get_modpath("mesecons")

-- How far lights can be from a plant. 0 = infinite
local height_max = 2

local grow_light_rules = {
	{x = 1, y = 0, z = 0},
	{x = -1, y = 0, z = 0},
	{x = 0, y = -1, z = 0},
	{x = 0, y = 1, z = 0},
	{x = 0, y = 0, z = -1},
	{x = 0, y = 0, z = 1},
}

function hydroponics.toggle_light(pos, toggle_state, dug)
	if toggle_state then
		minetest.set_node(pos, {name = "hydroponics:grow_light_on"})
	elseif not dug then
		minetest.set_node(pos, {name = "hydroponics:grow_light_off"})
	end
	local p = {x = pos.x, y = pos.y - 1, z = pos.z}
	local n = minetest.get_node(p)
	local height = 0
	while n.name == "air" and height ~= height_max do
		if toggle_state then
			minetest.set_node(p, {name = "air", param1 = 238})
		else
			minetest.set_node(p, {name = "air", param1 = 0})
		end
		p = {x = p.x, y = p.y - 1, z = p.z}
		n = minetest.get_node(p)
		height = height + 1
	end
end

minetest.register_node("hydroponics:grow_light_off", {
	description = "Hydroponic Grow Light",
	tiles = {
		"hydroponics_grow_light_ts.png",
		"hydroponics_grow_light_b_off.png",
		"hydroponics_grow_light_ts.png"
	},
	groups = {snappy = 2},
	sounds = default.node_sound_stone_defaults(),
	on_punch = function(pos, node, puncher, pointed_thing)
		if not mesecons_mod then
			hydroponics.toggle_light(pos, true)
		else
			return
		end
	end,
	after_dig_node = function(pos, node, digger)
		hydroponics.toggle_light(pos, false, true)
	end,
	mesecons = {
		effector = {
			rules = grow_light_rules,
			action_on = function (pos, node)
				hydroponics.toggle_light(pos, true)
			end,
			action_off = function (pos, node)
				hydroponics.toggle_light(pos, false)
			end,
		},
	},
})

minetest.register_node("hydroponics:grow_light_on", {
	description = "Hydroponic Grow Light (On)",
	tiles = {
		"hydroponics_grow_light_ts.png",
		"hydroponics_grow_light_b_on.png",
		"hydroponics_grow_light_ts.png"
	},
	light_source = 14,
	drop = "hydroponics:grow_light_off",
	groups = {snappy = 2, not_in_creative_inventory = 1},
	sounds = default.node_sound_stone_defaults(),
	on_punch = function(pos, node, puncher, pointed_thing)
		if not mesecons_mod then
			hydroponics.toggle_light(pos, false)
		else
			return
		end
	end,
	after_dig_node = function(pos, node, digger)
		hydroponics.toggle_light(pos, false, true)
	end,
	mesecons = {
		effector = {
			rules = grow_light_rules,
			action_on = function (pos, node)
				hydroponics.toggle_light(pos, true)
			end,
			action_off = function (pos, node)
				hydroponics.toggle_light(pos, true)
			end,
		},
	},
})

minetest.register_craft({
	output = "hydroponics:grow_light_off",
	recipe = {
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
		{ "default:steel_ingot", "default:torch", "default:steel_ingot" },
		{ "default:steel_ingot", "default:torch", "default:steel_ingot" },
	},
})
