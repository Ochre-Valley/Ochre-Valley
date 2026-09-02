// OV File

/datum/crafting_recipe/roguetown/engineering/arquebus
	name = "arquebus rifle"
	category = "Weapons"
	display_category = ITEM_CAT_ENG_COMBAT
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus
	reqs = list(
		/obj/item/roguegear = 2,
		/obj/item/ingot/bronze = 2, // ToDo: Replace these with anvil smithed items like "gun barrel" and "flintlock reciever". Sprites needed.
		/obj/item/natural/wood/plank = 4,
		/obj/item/ramrod = 1 // Teaches player that they can make these on an anvil.
	)
	structurecraft = /obj/structure/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5 // Historically, gun smiths started with rifles because they had more forgiving tolerances

/datum/crafting_recipe/roguetown/engineering/arquebus_pistol
	name = "arquebus pistol"
	category = "Weapons"
	display_category = ITEM_CAT_ENG_COMBAT
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/pistol
	reqs = list(
		/obj/item/roguegear = 2,
		/obj/item/ingot/bronze = 2, // ToDo: Replace these with anvil smithed items like "gun barrel" and "flintlock reciever". Sprites needed.
		/obj/item/natural/wood/plank = 4,
		/obj/item/ramrod = 1
	)
	structurecraft = /obj/structure/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 6 // whereas pistols could easily become a pipe bomb if you didn't know what you were doing.
