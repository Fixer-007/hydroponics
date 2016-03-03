Minetest Mod: Hydroponics [hydroponics]
=======================================
by mtmodder148

Dependencies:
-------------
default
dye
mesecons?
pipeworks?

Summary:
--------
Something I thought minetest farming was missing.

New Nodes:
	Hydroponic Bucket
		Function:
			1. Grows plants that check for soil.
			2. Hooks up to pipes if pipeworks is in use.
		Crafting:
			With pipeworks:
				[plastic_sheeting][black dye][plastic_sheeting]
				[plastic_sheeting][gravel][plastic_sheeting]
				[plastic_sheeting][plastic_sheeting][plastic_sheeting]
			Without:
				[leaves][black dye][leaves]
				[leaves][gravel][leaves]
				[leaves][leaves][leaves]
	Grow Light
		Function:
			1. Provides light for plants.
			2. Has an adjustable height (default = 2).
		Crafting:
			[steel ingot][steel ingot][steel ingot]
			[steel ingot][torch][steel ingot]
			[steel ingot][torch][steel ingot]

License of source code:
-----------------------
WTFPL (See LICENSE.txt for more information)
