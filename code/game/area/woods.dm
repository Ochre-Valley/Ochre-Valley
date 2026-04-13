// Azure Grove - the areas to the south of the map

/area/rogue/outdoors/woods
	name = "The Azure Grove"
	icon_state = "woods"
	ambientsounds = AMB_FORESTDAY
	ambientnight = AMB_FORESTNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_FOREST
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/forestnight.ogg'
	soundenv = 15
	warden_area = TRUE
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
				/mob/living/carbon/human/species/skeleton/npc/easy = 10,
				/mob/living/carbon/human/species/goblin/npc/ambush = 30,
				/mob/living/carbon/human/species/human/northern/militia/deserter = 20,
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 10,
				new /datum/ambush_config/hobgoblin_woods = 20, //CC Add
				)
	first_time_text = "THE AZURE GROVE"
	converted_type = /area/rogue/indoors/shelter/woods
	deathsight_message = "somewhere in the wilds"
	threat_region = THREAT_REGION_AZURE_GROVE
	detail_text = DETAIL_TEXT_AZURE_GROVE

/area/rogue/indoors/shelter/woods
	name = "Azure Grove"
	icon_state = "woods"
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/forestnight.ogg'
	threat_region = THREAT_REGION_AZURE_GROVE
	deathsight_message = "somewhere in the wilds"


/area/rogue/outdoors/woods/north
	name = "Azure Grove - North"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/easy = 20,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30,
		new /datum/ambush_config/hobgoblin_woods = 20, //CC Add
		new /datum/ambush_config/hobgoblin_woods/medium = 15, //CC Add
		new /datum/ambush_config/hobgoblin_woods/hard = 10, //CC Add
		)
	threat_region = THREAT_REGION_AZURE_GROVE

/area/rogue/outdoors/woods/northeast
	name = "Azure Grove - Northeast"
	ambush_mobs = list(
			/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
			/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
			/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
			/mob/living/carbon/human/species/skeleton/npc/easy = 10,
			/mob/living/carbon/human/species/skeleton/npc/pirate = 10,
			/mob/living/carbon/human/species/goblin/npc/ambush = 20,
			/mob/living/carbon/human/species/goblin/npc/sea = 10,
			/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30,
			new /datum/ambush_config/hobgoblin_woods = 25, //CC Add
			new /datum/ambush_config/hobgoblin_woods/medium = 20, //CC Add
			new /datum/ambush_config/hobgoblin_woods/hard = 15, //CC Add
			)
	threat_region = THREAT_REGION_AZURE_GROVE

/area/rogue/outdoors/woods/southeast
	name = "Azure Grove - Southeast"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/easy = 10,
		/mob/living/carbon/human/species/skeleton/npc/pirate = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 20,
		/mob/living/carbon/human/species/goblin/npc/sea = 10,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30,
		new /datum/ambush_config/hobgoblin_woods = 25, //CC Add
		new /datum/ambush_config/hobgoblin_woods/medium = 20, //CC Add
		new /datum/ambush_config/hobgoblin_woods/hard = 10, //CC Add
		)

/area/rogue/outdoors/woods/south
	name = "Azure Grove - South"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/hard = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20,
		new /datum/ambush_config/hobgoblin_woods = 15, //CC Add
		new /datum/ambush_config/hobgoblin_woods/medium = 10, //CC Add
		)

/area/rogue/outdoors/woods/southwest
	name = "Azure Grove - Southwest"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/hard = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20,
		new /datum/ambush_config/hobgoblin_woods = 15, //CC Add
		new /datum/ambush_config/hobgoblin_woods/medium = 10, //CC Add
		new /datum/ambush_config/hobgoblin_woods/hard = 5, //CC Add
		)

/area/rogue/outdoors/woods/northwest
	name = "Azure Grove - Northwest"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/hard = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20,
		new /datum/ambush_config/hobgoblin_woods = 20, //CC Add
		new /datum/ambush_config/hobgoblin_woods/medium = 15, //CC Add
		new /datum/ambush_config/hobgoblin_woods/hard = 5, //CC Add
		)

/area/rogue/outdoors/woods/vampire_lair
	warden_area = FALSE
	ambush_times = list()
	ambush_mobs = null
	threat_region = ""

/area/rogue/outdoors/woods/wretch_lair
	warden_area = FALSE
	ambush_times = list()
	ambush_mobs = null
	threat_region = ""
