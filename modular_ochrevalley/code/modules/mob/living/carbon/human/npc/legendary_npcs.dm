//These are GM spawn only mobs for events, designed to be proper boss enemies
GLOBAL_LIST_INIT(psydonite_aggro, world.file2list("modular_ochrevalley/strings/rt/psydonhereticlines.txt"))
GLOBAL_LIST_INIT(bogbun_aggro, world.file2list("modular_ochrevalley/strings/rt/bogbunlines.txt"))

//SEA RAIDER
/mob/living/carbon/human/species/human/northern/searaider_legendary
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	faction = list(FACTION_GRONNMEN, FACTION_STATION)
	ambushable = FALSE
	dodgetime = 30
	blood_toll_bucket = STATS_KILLED_GRONNMEN

/mob/living/carbon/human/species/human/northern/searaider_legendary/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/searaider_legendary/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.searaider_aggro, TRUE)
	job = "Sea Raider"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/searaider_legendary)
	gender = pick(MALE, FEMALE)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/lowbraid,
						/datum/sprite_accessory/hair/head/countryponytailalt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher,
						/datum/sprite_accessory/hair/head/lowbraid))
	var/beard = pick(list(/datum/sprite_accessory/hair/facial/viking,
						/datum/sprite_accessory/hair/facial/manly,
						/datum/sprite_accessory/hair/facial/longbeard))
	head.sellprice = 30 // 50% More than gobbo

	var/datum/bodypart_feature/hair/head/new_hair = new()
	var/datum/bodypart_feature/hair/facial/new_facial = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)
		new_facial.set_accessory_type(beard, null, src)

	if(prob(50))
		new_hair.accessory_colors = "#C1A287"
		new_hair.hair_color = "#C1A287"
		new_facial.accessory_colors = "#C1A287"
		new_facial.hair_color = "#C1A287"
		hair_color = "#C1A287"
	else
		new_hair.accessory_colors = "#A56B3D"
		new_hair.hair_color = "#A56B3D"
		new_facial.accessory_colors = "#A56B3D"
		new_facial.hair_color = "#A56B3D"
		hair_color = "#A56B3D"

	head.add_bodypart_feature(new_hair)
	head.add_bodypart_feature(new_facial)

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)

	if(organ_eyes)
		organ_eyes.eye_color = "#336699"
		organ_eyes.accessory_colors = "#336699#336699"

	if(gender == FEMALE)
		real_name = pick(world.file2list("strings/rt/names/human/vikingf.txt"))
	else
		real_name = pick(world.file2list("strings/rt/names/human/vikingm.txt"))
	update_hair()
	update_body()


/datum/outfit/job/roguetown/human/species/human/northern/searaider_legendary/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	head = /obj/item/clothing/head/roguetown/helmet/winged
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead

	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	H.STASPD = 10
	H.STACON = 17
	H.STAWIL = 13
	H.STAPER = 14
	H.STAINT = 1
	H.STASTR = 20
	H.adjust_skillrank(/datum/skill/combat/polearms, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)

//ORC
/mob/living/carbon/human/species/orc/orc_legendary
	faction = list(FACTION_ORCS, FACTION_STATION)
	ai_controller = /datum/ai_controller/human_npc
	cmode_music = FALSE

/mob/living/carbon/human/species/orc/orc_legendary/Initialize()
	. = ..()
	set_species(/datum/species/orc)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/orc/orc_legendary/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Legendary Orc"
	equipOutfit(new /datum/outfit/job/roguetown/orc/orc_legendary)
	gender = pick(MALE, FEMALE)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/lowbraid, 
						/datum/sprite_accessory/hair/head/countryponytailalt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher, 
						/datum/sprite_accessory/hair/head/lowbraid))
	var/beard = pick(list(/datum/sprite_accessory/hair/facial/viking,
						/datum/sprite_accessory/hair/facial/manly,
						/datum/sprite_accessory/hair/facial/longbeard))
	head.sellprice = 30

	src.set_patron(/datum/patron/inhumen/graggar)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)

	var/datum/bodypart_feature/hair/head/new_hair = new()
	var/datum/bodypart_feature/hair/facial/new_facial = new()
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/organ/ears/organ_ears = getorgan(/obj/item/organ/ears)

	if(organ_eyes)
		organ_eyes.eye_color = "#FF0000"
		organ_eyes.accessory_colors = "#FF0000#FF0000"

	skin_tone = "50715C"

	if(organ_ears)
		organ_ears.accessory_colors = "#50715C"

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)
		new_facial.set_accessory_type(beard, null, src)
		
	head.add_bodypart_feature(new_hair)
	head.add_bodypart_feature(new_facial)

	new_hair.accessory_colors = "#31302E"
	new_hair.hair_color = "#31302E"
	new_facial.accessory_colors = "#31302E"
	new_facial.hair_color = "#31302E"
	hair_color = "#31302E"

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)
	if(gender == FEMALE)
		real_name = pick(world.file2list("strings/rt/names/other/halforcf.txt"))
	else
		real_name = pick(world.file2list("strings/rt/names/other/halforcm.txt"))
	update_hair()
	update_body()

/datum/outfit/job/roguetown/orc/orc_legendary/pre_equip(mob/living/carbon/human/H) //gives some default skills and equipment for player controlled orcs
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	head = /obj/item/clothing/head/roguetown/helmet/leather/advanced
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/troll
	l_hand = /obj/item/rogueweapon/shield/tower/metal

	H.STASTR = 20
	H.STASPD = 10
	H.STACON = 16
	H.STAWIL = 14
	H.STAINT = 4

	//light labor skills for armor repairs and such, equipment is so-so, with good stats
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 1, TRUE)

	H.adjust_skillrank(/datum/skill/combat/polearms, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 6, TRUE)

//LEGENDARY WILDMAN
/mob/living/carbon/human/species/human/northern/wildman_legendary
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	faction = list(FACTION_BANDITS)
	ambushable = FALSE
	dodgetime = 30
	blood_toll_bucket = STATS_KILLED_HIGHWAYMEN

/mob/living/carbon/human/species/human/northern/wildman_legendary/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/wildman_legendary/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Wildsoul"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/wildman_legendary)
	gender = pick(MALE, FEMALE)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/lowbraid,
						/datum/sprite_accessory/hair/head/countryponytailalt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher,
						/datum/sprite_accessory/hair/head/lowbraid))
	var/beard = pick(list(/datum/sprite_accessory/hair/facial/viking,
						/datum/sprite_accessory/hair/facial/manly,
						/datum/sprite_accessory/hair/facial/longbeard))
	head.sellprice = 30 // 50% More than gobbo

	var/datum/bodypart_feature/hair/head/new_hair = new()
	var/datum/bodypart_feature/hair/facial/new_facial = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)
		new_facial.set_accessory_type(beard, null, src)

	if(prob(50))
		new_hair.accessory_colors = "#C1A287"
		new_hair.hair_color = "#C1A287"
		new_facial.accessory_colors = "#C1A287"
		new_facial.hair_color = "#C1A287"
		hair_color = "#C1A287"
	else
		new_hair.accessory_colors = "#A56B3D"
		new_hair.hair_color = "#A56B3D"
		new_facial.accessory_colors = "#A56B3D"
		new_facial.hair_color = "#A56B3D"
		hair_color = "#A56B3D"

	head.add_bodypart_feature(new_hair)
	head.add_bodypart_feature(new_facial)

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)

	if(organ_eyes)
		organ_eyes.eye_color = "#336699"
		organ_eyes.accessory_colors = "#336699#336699"

	if(gender == FEMALE)
		real_name = pick(world.file2list("strings/rt/names/human/vikingf.txt"))
	else
		real_name = pick(world.file2list("strings/rt/names/human/vikingm.txt"))
	update_hair()
	update_body()

/datum/outfit/job/roguetown/human/species/human/northern/wildman_legendary/pre_equip(mob/living/carbon/human/H)
	pants = /obj/item/clothing/under/roguetown/loincloth
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	gloves = /obj/item/clothing/gloves/roguetown/knuckles/bronze
	H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/natural_armor/dense(H)
	l_hand = /obj/item/rogueweapon/wildman_fist
	r_hand = /obj/item/rogueweapon/wildman_fist
	H.STASPD = 20
	H.STACON = 20
	H.STAWIL = 15
	H.STAPER = 14
	H.STAINT = 1
	H.STASTR = 20
	H.adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)

/obj/item/rogueweapon/wildman_fist
	name = "strong fist"
	desc = "A strong, ready fist."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = null
	force = 30
	wdefense = 10
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_LONG
	wbalance = WBALANCE_NORMAL
	can_parry = TRUE
	sharpness = IS_BLUNT
	parrysound = list('sound/combat/parry/parrygen.ogg')
	possible_item_intents = list(/datum/intent/simple/slam)
	item_flags = DROPDEL
	special = /datum/special_intent/upper_cut
	max_blade_int = 8000
	max_integrity = 8000

//SEA RAIDER
/mob/living/carbon/human/species/human/northern/psydonite_heretic_legendary
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	faction = list(FACTION_HERETICAL_FIEND)
	ambushable = FALSE
	dodgetime = 30
	blood_toll_bucket = STATS_KILLED_HIGHWAYMEN

/mob/living/carbon/human/species/human/northern/psydonite_heretic_legendary/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/psydonite_heretic_legendary/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.psydonite_aggro, TRUE)
	job = "Psydonite Heretic"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_PSYDONITE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_PSYDONIAN_GRIT, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/psydonite_heretic_legendary)
	gender = pick(MALE, FEMALE)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/bob,
						/datum/sprite_accessory/hair/head/ponytail3))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/bald,
						/datum/sprite_accessory/hair/head/monk))
	var/beard = pick(list(/datum/sprite_accessory/hair/facial/shaved))
	head.sellprice = 30 // 50% More than gobbo

	var/datum/bodypart_feature/hair/head/new_hair = new()
	var/datum/bodypart_feature/hair/facial/new_facial = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)
		new_facial.set_accessory_type(beard, null, src)

	if(prob(50))
		new_hair.accessory_colors = "#C1A287"
		new_hair.hair_color = "#C1A287"
		new_facial.accessory_colors = "#C1A287"
		new_facial.hair_color = "#C1A287"
		hair_color = "#C1A287"
	else
		new_hair.accessory_colors = "#A56B3D"
		new_hair.hair_color = "#A56B3D"
		new_facial.accessory_colors = "#A56B3D"
		new_facial.hair_color = "#A56B3D"
		hair_color = "#A56B3D"

	head.add_bodypart_feature(new_hair)
	head.add_bodypart_feature(new_facial)

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)

	if(organ_eyes)
		organ_eyes.eye_color = "#336699"
		organ_eyes.accessory_colors = "#336699#336699"

	update_hair()
	update_body()


/datum/outfit/job/roguetown/human/species/human/northern/psydonite_heretic_legendary/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/psythorns
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	pants = /obj/item/clothing/under/roguetown/platelegs/blacksteel
	head = /obj/item/clothing/head/roguetown/helmet/heavy/absolver/unblessed
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	cloak = /obj/item/clothing/neck/roguetown/psicross/weeping
	gloves = /obj/item/clothing/gloves/roguetown/chain/psydon
	if(prob(50))
		r_hand = /obj/item/rogueweapon/greatsword/bsword/psy/unforgotten
	else
		r_hand =  /obj/item/rogueweapon/mace/goden/psymace
		l_hand = /obj/item/rogueweapon/shield/tower/metal/psy

	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel
	H.STASPD = 20
	H.STACON = 20
	H.STAWIL = 20
	H.STAPER = 20
	H.STAINT = 20
	H.STASTR = 20
	H.adjust_skillrank(/datum/skill/combat/polearms, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)

//Bog Bunny
/mob/living/carbon/human/species/human/northern/bogbun_legendary
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	faction = list(FACTION_BANDITS, FACTION_STATION)
	ambushable = FALSE
	dodgetime = 30
	blood_toll_bucket = STATS_KILLED_HIGHWAYMEN

/mob/living/carbon/human/species/human/northern/bogbun_legendary/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/bogbun_legendary/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.bogbun_aggro, TRUE)
	job = "Garrison Deserter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/northern/bog_deserters/bogbun_legendary)
	gender = pick(MALE, FEMALE)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/long_over_eye,
						/datum/sprite_accessory/hair/head/bobcurl))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/crew,
						/datum/sprite_accessory/hair/head/bald))
	var/beard = pick(list(/datum/sprite_accessory/hair/facial/viking,
						/datum/sprite_accessory/hair/facial/manly,
						/datum/sprite_accessory/hair/facial/longbeard))
	head.sellprice = 80

	var/datum/bodypart_feature/hair/head/new_hair = new()
	var/datum/bodypart_feature/hair/facial/new_facial = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)
		new_facial.set_accessory_type(beard, null, src)

	if(prob(50))
		new_hair.accessory_colors = "#C1A287"
		new_hair.hair_color = "#C1A287"
		new_facial.accessory_colors = "#C1A287"
		new_facial.hair_color = "#C1A287"
		hair_color = "#C1A287"
	else
		new_hair.accessory_colors = "#A56B3D"
		new_hair.hair_color = "#A56B3D"
		new_facial.accessory_colors = "#A56B3D"
		new_facial.hair_color = "#A56B3D"
		hair_color = "#A56B3D"

	head.add_bodypart_feature(new_hair)
	head.add_bodypart_feature(new_facial)
	
	//Bog bunny ears
	var/obj/item/organ/ears/new_ears = new /obj/item/organ/ears/anthro
	new_ears.accessory_colors = new_hair.hair_color
	new_ears.accessory_type = /datum/sprite_accessory/ears/big/rabbit_large
	var/obj/item/organ/ears/old_part = getorganslot(ORGAN_SLOT_EARS)
	if(old_part)
		old_part.Remove(src)
		qdel(old_part)
	new_ears.Insert(src, TRUE, FALSE)

	for(var/obj/item/clothing/head/roguetown/helmet in contents)
		helmet.flags_inv &= ~HIDE_HEADTOP
	for(var/obj/item/clothing/neck/roguetown/coif in contents)
		coif.flags_inv &= ~HIDE_HEADTOP
	update_inv_head()

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)

	if(organ_eyes)
		organ_eyes.eye_color = "#336699"
		organ_eyes.accessory_colors = "#336699#336699"

	update_hair()
	update_body()


/datum/outfit/job/roguetown/human/northern/bog_deserters/bogbun_legendary/pre_equip(mob/living/carbon/human/H)
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor

	add_random_deserter_beltl_stuff(H)
	add_random_deserter_beltr_stuff(H)

	l_hand = /obj/item/rogueweapon/shield/tower/metal
	if(prob(30))
		r_hand = /obj/item/rogueweapon/sword/decorated
	else if(prob(50))
		r_hand = /obj/item/rogueweapon/mace/warhammer/steel
	else
		r_hand = /obj/item/rogueweapon/pick/militia

	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	H.STASPD = 20
	H.STACON = 17
	H.STAWIL = 16
	H.STAPER = 14
	H.STAINT = 17
	H.STASTR = 20
	H.adjust_skillrank(/datum/skill/combat/polearms, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 6, TRUE)


//VOLF
/mob/living/simple_animal/hostile/retaliate/rogue/wolf/legendary
	name = "great volf"
	desc = "A massive snarling beast of mangy fur and yellowed teeth. This volf is not only larger than most, it looks more aggressive, faster and more dangerous than any other."
	gender = FEMALE
	move_to_delay = 2
	melee_damage_lower = 35
	melee_damage_upper = 50
	turns_per_move = 3
	health = 600
	maxHealth = 600
	STACON = 16
	STASTR = 16
	STASPD = 20
	retreat_health = 0.1
	head_butcher = /obj/item/natural/head/volf/legendary

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/legendary/Initialize()
	..()
	resize(1.3)

/obj/item/natural/head/volf/legendary
	name = "great volf head"
	desc = "The head of a particularly beastly volf."
	sellprice = 30

//DIREBEAR
/mob/living/simple_animal/hostile/retaliate/rogue/direbear/legendary
	name = "ghastly direbear"
	desc = "Renowned as a symbol of strength and rebirth by followers of Dendor, these mighty beasts are said to sleep for months on end without ever starving. This beast in particular is massive compared to others, covered in scars and frothing at the maw."
	melee_damage_lower = 80
	melee_damage_upper = 95
	health = 1000
	maxHealth = 1000
	STACON = 20
	STASTR = 20
	STASPD = 14
	head_butcher = /obj/item/natural/head/direbear/legendary

/mob/living/simple_animal/hostile/retaliate/rogue/direbear/legendary/Initialize(mapload)
	..()
	resize(1.3)

/obj/item/natural/head/direbear/legendary
	name = "ghastly direbear head"
	desc = "The head of a horrifying, massive direbear."
	sellprice = 40

//MOSSBACK
/mob/living/simple_animal/hostile/retaliate/rogue/mossback/legendary
	name = "giant mossback"
	desc = "Much feared by all those who live on Psydonia's coasts, these creatures are said to be the envoys of Abyssor. This specimen appears to be particularly massive, with scarred chitin and hulking proportions, it has survived undoubtedly much longer than others of its kind."
	health = 600
	maxHealth = 600
	melee_damage_lower = 50
	melee_damage_upper = 75
	STACON = 18
	STASTR = 17
	STASPD = 12

/mob/living/simple_animal/hostile/retaliate/rogue/mossback/Initialize(mapload, mob/user, townercrab = FALSE)
	..()
	resize(1.5)

//TROLL
/mob/living/simple_animal/hostile/retaliate/rogue/troll/axe/legendary
	name = "massive troll skull-splitter"
	desc = "This one seems bigger than the rest... And its axe could cut a crowd in two."
	health = 800
	maxHealth = 800
	melee_damage_lower = 70
	melee_damage_upper = 85
	STACON = 18
	STASTR = 20
	STASPD = 3
	STAWIL = 20
	head_butcher = /obj/item/natural/head/troll/axe/legendary

/mob/living/simple_animal/hostile/retaliate/rogue/troll/Initialize()
	..()
	resize(1.3)

/obj/item/natural/head/troll/axe/legendary
	name = "massive troll head"
	desc = "The head of a once terrifying, gigantic troll."
	sellprice = 75

//BOAR
/mob/living/simple_animal/hostile/retaliate/rogue/boar/legendary
	name = "colossal bramblesnout"
	desc = "The ever terrifying bramblesnout. Not just large, but its many tusks hook into flesh to create grievous wounds. Being charged is a surefire way to perish. It is a hulking mass of muscle, yet still nimble. This beast has likely claimed the lives of many you have dared to hunt it, as it's body is adorned with scars from humen weapons."
	move_to_delay = 3
	melee_damage_lower = 55
	melee_damage_upper = 70
	STASTR = 20
	STASPD = 18
	STACON = 18
	retreat_health = 0
	health = 1200
	maxHealth = 1200
	head_butcher = /obj/item/natural/head/boar/legendary

/mob/living/simple_animal/hostile/retaliate/rogue/boar/legendary/Initialize()
	..()
	resize(1.4)

/obj/item/natural/head/boar/legendary
	name = "colossal bramblesnout head"
	desc = "The head of a massive, brutally dangerous bramblesnout."
	sellprice = 70

//RAT
/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/legendary
	name = "ROIS"
	desc = "This is a rodent of incredible strength, a rat of impressive speed, a rous of infinite splendor."
	move_to_delay = 3
	melee_damage_lower = 50
	melee_damage_upper = 65
	STASTR = 16
	STASPD = 18
	STACON = 12
	retreat_health = 0
	health = 400
	maxHealth = 400
	head_butcher = /obj/item/natural/head/rous/legendary

/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/legendary/Initialize()
	..()
	resize(2)

/obj/item/natural/head/rous/legendary
	name = "rois head"
	desc = "The head of an impossibly sizable rat."
	sellprice = 30
