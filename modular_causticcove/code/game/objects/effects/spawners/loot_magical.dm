//Tier 1 magical loot; Melded variants have a 1/19 chance of spawning.
/obj/effect/spawner/lootdrop/magic_loot_tier_1
	name = "tier 1 magic loot spawner"
	icon_state = "genlow" //Add magic versions.
	lootcount = 1
	loot = list(
		//mats
		/obj/item/magic/infernal/ash = 6,
		/obj/item/magic/elemental/mote = 6
	)

//1/22 chance for a T2 meld
/obj/effect/spawner/lootdrop/magic_loot_tier_2
	name = "tier 2 magic loot spawner"
	icon_state = "genmid"
	lootcount = 1
	loot = list(
		//mats
		/obj/item/magic/infernal/fang = 7,
		/obj/item/magic/elemental/shard = 7
	)

//Voidstone also included in T3; Only because it can be used to summon boss mobs. Makes the chance
// 1/26 chance to spawn a T3 meld or Voidstone
/obj/effect/spawner/lootdrop/magic_loot_tier_3
	name = "tier 3 magic loot spawner"
	icon_state = "genhi"
	lootcount = 1
	loot = list(
		//mats
		/obj/item/magic/voidstone = 1,
		/obj/item/magic/infernal/core = 8,
		/obj/item/magic/elemental/fragment = 8
	)

//Basic loot; can be looted off map, but also a random dungeon loot for easier dungeons.
//Manabloom not included, you can easily find this and farm it.
/obj/effect/spawner/lootdrop/magic_loot_base
	name = "base tier magic loot spawner"
	icon_state = "genlow"
	lootcount = 1
	loot = list(
		//mats
		/obj/item/magic/obsidian = 1,
		/obj/item/magic/leyline = 1,
		/obj/item/magic/manacrystal = 1,
		/obj/item/magic/artifact = 1
	)
/obj/effect/spawner/lootdrop/magic_loot_tier_1/x3
	lootcount = 3

/obj/effect/spawner/lootdrop/magic_loot_tier_2/x3
	lootcount = 3

/obj/effect/spawner/lootdrop/magic_loot_tier_3/x3
	lootcount = 3

/obj/effect/spawner/lootdrop/magic_loot_base/x3
	lootcount = 3
