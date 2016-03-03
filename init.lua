-- Minetest Mod: Hydroponics [hydroponics]
-- See README.txt for licensing and other information.

hydroponics = {}

dofile(minetest.get_modpath("hydroponics").."/grow_light.lua")
dofile(minetest.get_modpath("hydroponics").."/hydro_bucket.lua")

if minetest.get_modpath("pipeworks") then
	dofile(minetest.get_modpath("hydroponics").."/pipe_override.lua")
end
