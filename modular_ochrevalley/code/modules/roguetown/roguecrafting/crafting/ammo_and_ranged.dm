/datum/crafting_recipe/roguetown/survival/arquebuspouchcraft
	name = "arquebus bullet pouch"
	category = "Ranged"
	result = /obj/item/quiver/bulletpouch
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/natural/hide/cured = 1,
		)
	verbage_simple = "craft"
	verbage = "crafts"
	craftdiff = 0

/datum/crafting_recipe/roguetown/engineering/shotkitcraft
	name = "powder-and-shot kit"
	category = "Ranged"
	result = /obj/item/quiver/bulletpouch
	skillcraft = /datum/skill/craft/engineering
	reqs = list(
		/obj/item/quiver/bulletpouch = 1,
		/obj/item/natural/hide/cured = 1,
		/obj/item/powderflask
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/hollowpoint
	name = "cruciform bronze round"
	category = "Ranged"
	display_category = ITEM_CAT_ENG_COMBAT
	result = /obj/item/ammo_casing/caseless/rogue/bullet/bronze/hollowpoint
	reqs = list(
		/obj/item/ammo_casing/caseless/rogue/bullet/bronze = 1
	)
	tools = list(/obj/item/rogueweapon/huntingknife)
	structurecraft = /obj/structure/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/scatter
	name = "bronze scattershot (x3)"
	category = "Ranged"
	display_category = ITEM_CAT_ENG_COMBAT
	result = list(
		/obj/item/ammo_casing/caseless/rogue/bullet/scatter,
		/obj/item/ammo_casing/caseless/rogue/bullet/scatter,
		/obj/item/ammo_casing/caseless/rogue/bullet/scatter
	)
	reqs = list(
		/obj/item/ammo_casing/caseless/rogue/bullet/bronze = 3,
		/obj/item/natural/cloth = 1
	)
	tools = list(/obj/item/rogueweapon/hammer)
	structurecraft = /obj/structure/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/glassscatter
	name = "improvised scattershot (x3)"
	category = "Ranged"
	display_category = ITEM_CAT_ENG_COMBAT
	result = list(
		/obj/item/ammo_casing/caseless/rogue/bullet/scatter/glass,
		/obj/item/ammo_casing/caseless/rogue/bullet/scatter/glass,
		/obj/item/ammo_casing/caseless/rogue/bullet/scatter/glass
	)
	reqs = list(
		/obj/item/natural/glass_shard = 1,
		/obj/item/natural/cloth = 1
	)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 1

/datum/crafting_recipe/roguetown/engineering/burnscatter
	name = "infernal scattershot (x3)"
	category = "Ranged"
	display_category = ITEM_CAT_ENG_COMBAT
	result = list(
		/obj/item/ammo_casing/caseless/rogue/bullet/scatter/dragonsbreath,
		/obj/item/ammo_casing/caseless/rogue/bullet/scatter/dragonsbreath,
		/obj/item/ammo_casing/caseless/rogue/bullet/scatter/dragonsbreath
	)
	reqs = list(
		/obj/item/ammo_casing/caseless/rogue/bullet/scatter = 3,
		/obj/item/magic/infernal/fang = 1
	)
	tools = list(/obj/item/chalk)
	structurecraft = /obj/structure/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

//ENCHANTED ROUNDS
//balance is tentative- if these turn out to be too strong or available, make them need an arcyne silver dagger, not chalk. Alternatively, require higher tier components

/datum/crafting_recipe/roguetown/engineering/ricochet
	name = "ricochet shot (x3)"
	category = "Ranged"
	display_category = ITEM_CAT_ENG_COMBAT
	result = list(
		/obj/item/ammo_casing/caseless/rogue/bullet/ricochet,
		/obj/item/ammo_casing/caseless/rogue/bullet/ricochet,
		/obj/item/ammo_casing/caseless/rogue/bullet/ricochet
	)
	reqs = list(
		/obj/item/ammo_casing/caseless/rogue/bullet/bronze = 3,
		/obj/item/magic/fae/iridescentscale = 1
	)
	tools = list(/obj/item/chalk)
	structurecraft = /obj/structure/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/concussive
	name = "concussive shot (x3)"
	category = "Ranged"
	display_category = ITEM_CAT_ENG_COMBAT
	result = list(
		/obj/item/ammo_casing/caseless/rogue/bullet/concussive,
		/obj/item/ammo_casing/caseless/rogue/bullet/concussive,
		/obj/item/ammo_casing/caseless/rogue/bullet/concussive
	)
	reqs = list(
		/obj/item/ammo_casing/caseless/rogue/bullet/bronze = 3,
		/obj/item/magic/elemental/shard = 1
	)
	tools = list(/obj/item/chalk)
	structurecraft = /obj/structure/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5
