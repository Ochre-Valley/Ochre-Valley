/**
	Each threat spawner type defined by this macro simply makes different versions
	that have different initial cooldowns.
	By default, a threat spawner's initial cooldown is 30 minutes.
	- Shortinit
		Subtype of threat spawner with a short initial cooldown,
		intended for places that will be cleared out pretty early on in the round.
	- longinit
		Subtype of threat spawner with a longer initial cooldown,
		intended for places that will probably take a while before being cleared.
	- instant
		Attempts to spawn a threat every second.
		Intended for debugging only!!
		For the love of PSYDON do not use these in a normal round!!
*/
#define THREATSPAWNER_DEF(X) GLOBAL_REAL(SS##X, /obj/effect/landmark/threatspawner/##X);\
/obj/effect/landmark/threatspawner/##X/shortinit{\
	inital_cooldown = 15 MINUTES;\
};\
/obj/effect/landmark/threatspawner/##X/longinit{\
	inital_cooldown = 45 MINUTES;\
};\
/obj/effect/landmark/threatspawner/##X/instant{\
	inital_cooldown = 1 SECONDS;\
};\

// --------------- ONE-TYPE-SPAWN ---------------

// NORMAL GOBLIN
THREATSPAWNER_DEF(goblin)

/obj/effect/landmark/threatspawner/goblin
	icon_state = "threatspawner-goblin"

/obj/effect/landmark/threatspawner/goblin/get_mob_spawn_type(area/AR)
	return /mob/living/carbon/human/species/goblin/npc/ambush


// SEA GOBLIN
THREATSPAWNER_DEF(goblin_sea)

/obj/effect/landmark/threatspawner/goblin_sea
	icon_state = "threatspawner-goblin-sea"

/obj/effect/landmark/threatspawner/goblin_sea/get_mob_spawn_type(area/AR)
	return /mob/living/carbon/human/species/goblin/npc/ambush/sea

// HELL GOBLIN
THREATSPAWNER_DEF(goblin_hell)

/obj/effect/landmark/threatspawner/goblin_hell
	icon_state = "threatspawner-goblin-hell"

/obj/effect/landmark/threatspawner/goblin_hell/get_mob_spawn_type(area/AR)
	return /mob/living/carbon/human/species/goblin/npc/ambush/hell

// CAVE GOBLIN
THREATSPAWNER_DEF(goblin_cave)

/obj/effect/landmark/threatspawner/goblin_cave
	icon_state = "threatspawner-goblin-cave"

/obj/effect/landmark/threatspawner/goblin_cave/get_mob_spawn_type(area/AR)
	return /mob/living/carbon/human/species/goblin/npc/ambush/cave

// SKELETON
THREATSPAWNER_DEF(skeleton)

/obj/effect/landmark/threatspawner/skeleton
	icon_state = "threatspawner-skeleton"

/obj/effect/landmark/threatspawner/skeleton/get_mob_spawn_type(area/AR)
	return /mob/living/carbon/human/species/skeleton/npc/ambush

// WOLF
THREATSPAWNER_DEF(wolf)

/obj/effect/landmark/threatspawner/wolf
	icon_state = "threatspawner-wolf"

/obj/effect/landmark/threatspawner/wolf/get_mob_spawn_type(area/AR)
	return /mob/living/simple_animal/hostile/retaliate/rogue/wolf

// SEA RAIDER
THREATSPAWNER_DEF(searaider)

/obj/effect/landmark/threatspawner/searaider
	icon_state = "threatspawner-human"

/obj/effect/landmark/threatspawner/searaider/get_mob_spawn_type(area/AR)
	return /mob/living/carbon/human/species/human/northern/searaider/ambush

// BIG RAT
THREATSPAWNER_DEF(bigrat)

/obj/effect/landmark/threatspawner/bigrat
	icon_state = "threatspawner-rous"

/obj/effect/landmark/threatspawner/bigrat/get_mob_spawn_type(area/AR)
	return /mob/living/simple_animal/hostile/retaliate/rogue/bigrat

// SPIDER
THREATSPAWNER_DEF(spider)

/obj/effect/landmark/threatspawner/spider
	icon_state = "threatspawner-spider-honey"

/obj/effect/landmark/threatspawner/spider/get_mob_spawn_type(area/AR)
	return /mob/living/simple_animal/hostile/retaliate/rogue/spider

// BOG TROLL
THREATSPAWNER_DEF(troll_bog)
/obj/effect/landmark/threatspawner/troll_bog
	icon_state = "threatspawner-troll-bog"

/obj/effect/landmark/threatspawner/troll_bog/get_mob_spawn_type(area/AR)
	return /mob/living/simple_animal/hostile/retaliate/rogue/troll/bog

// CAVE TROLL
THREATSPAWNER_DEF(troll_cave)
/obj/effect/landmark/threatspawner/troll_cave
	icon_state = "threatspawner-troll-cave"
/obj/effect/landmark/threatspawner/troll_cave/get_mob_spawn_type(area/AR)
	return /mob/living/simple_animal/hostile/retaliate/rogue/troll/cave

#undef THREATSPAWNER_DEF
