//Default grove encounter, 1 hobgoblin and 2 regular gobbagools.
/datum/ambush_config/hobgoblin_woods
	mob_types = list(
		/mob/living/carbon/human/species/goblin/npc/ambush = 2,
		/mob/living/carbon/human/species/hobgoblin/npc/ambush = 1
	)
	threat_point = THREAT_MODERATE + 2 * THREAT_LOW

//Spawns 2 hobgoblins as opposed to one... Relatively difficult.
/datum/ambush_config/hobgoblin_woods/medium
	mob_types = list(/mob/living/carbon/human/species/hobgoblin/npc/ambush = 2)
	threat_point = 2 * THREAT_MODERATE

//2 hobbos and 1 goblin. Rough fight...
/datum/ambush_config/hobgoblin_woods/hard
	mob_types = list(/mob/living/carbon/human/species/hobgoblin/npc/ambush = 2,
	/mob/living/carbon/human/species/goblin/npc/ambush = 1)
	threat_point = THREAT_LOW + 2 * THREAT_MODERATE

//4 total mobs, 2 small gobbos and 2 big hobbos...
/datum/ambush_config/hobgoblin_band
	mob_types = list(/mob/living/carbon/human/species/hobgoblin/npc/ambush = 2,
	/mob/living/carbon/human/species/goblin/npc/ambush = 2)
	threat_point = (2* THREAT_LOW) + (2 * THREAT_MODERATE)

//5 total mobs. 2 smalls and 3 big hoblins.
/datum/ambush_config/hobgoblin_band/circus
	mob_types = list(/mob/living/carbon/human/species/hobgoblin/npc/ambush = 3,
	/mob/living/carbon/human/species/goblin/npc/ambush = 2)
	threat_point =(2 * THREAT_LOW) + (3 * THREAT_MODERATE)
