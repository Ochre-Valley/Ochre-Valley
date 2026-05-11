
//These are Hoblins. A play of Hobgoblin.
//Hoblins are stronger variants of Goblins, simply. They boast stronger stats and use pretty much the same items, except they're taller and do not flee from combat.

/mob/living/carbon/human/species/hobgoblin
	name = "hoblin"
	icon = 'modular_causticcove/icons/mob/monster/hobgoblins/hobgoblins.dmi'
	icon_state = "hobgoblin"
	race = /datum/species/hobgoblin
	gender = MALE
	bodyparts = list(/obj/item/bodypart/chest/hobgoblin, /obj/item/bodypart/head/hobgoblin, /obj/item/bodypart/l_arm/hobgoblin,
					/obj/item/bodypart/r_arm/hobgoblin, /obj/item/bodypart/r_leg/hobgoblin, /obj/item/bodypart/l_leg/hobgoblin)
	rot_type = /datum/component/rot/corpse/goblin
	var/hobgob_outfit = /datum/outfit/job/roguetown/npc/hobgoblin
	ambushable = FALSE
	base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	a_intent = INTENT_HELP
	possible_mmb_intents = list(INTENT_SPECIAL, INTENT_JUMP, INTENT_KICK, INTENT_BITE)

//////////////////   BODYPARTS	//////////////////
	//I am going to experiment with pain with Hobgoblins, and eventually spread to other mobs if this feels right.
	//Hobgoblins will be dismemberable by default for now, may change in the future. Naturally high CON counters this.
/obj/item/bodypart/chest/hobgoblin
	max_pain_damage = 100

/obj/item/bodypart/head/hobgoblin
	max_pain_damage = 100

/obj/item/bodypart/l_arm/hobgoblin
	max_pain_damage = 75

/obj/item/bodypart/r_arm/hobgoblin
	max_pain_damage = 75

/obj/item/bodypart/l_leg/hobgoblin
	max_pain_damage = 75

/obj/item/bodypart/r_leg/hobgoblin
	max_pain_damage = 75


//////////////////   PROCS	//////////////////
/obj/item/bodypart/head/hobgoblin/update_icon_dropped()
	return

/obj/item/bodypart/head/hobgoblin/get_limb_icon(dropped, hideaux = FALSE)
	return

/mob/living/carbon/human/species/hobgoblin/update_inv_head(hide_nonstandard = FALSE)
	update_wearable()

/mob/living/carbon/human/species/hobgoblin/update_inv_armor()
	update_wearable()

/mob/living/carbon/human/species/hobgoblin/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/obj/item/bodypart/head/hobgoblin/skeletonize()
	. = ..()
	icon_state = "hobgoblin_skel_head"
	sellprice = 2


/mob/living/carbon/human/species/hobgoblin/update_body()
	remove_overlay(BODY_LAYER)
	if(!dna || !dna.species)
		return
	var/datum/species/hobgoblin/G = dna.species
	if(!istype(G))
		return
	icon_state = ""
	var/list/standing = list()
	var/mutable_appearance/body_overlay
	var/obj/item/bodypart/chesty = get_bodypart("chest")
	var/obj/item/bodypart/headdy = get_bodypart("head")
	if(!headdy)
		if(chesty && chesty.skeletonized)
			body_overlay = mutable_appearance(icon, "hobgoblin_skel_decap", -BODY_LAYER)
		else
			body_overlay = mutable_appearance(icon, "[G.raceicon]_decap", -BODY_LAYER)
	else
		if(chesty && chesty.skeletonized)
			body_overlay = mutable_appearance(icon, "hobgoblin_skel", -BODY_LAYER)
		else
			body_overlay = mutable_appearance(icon, "[G.raceicon]", -BODY_LAYER)

	if(body_overlay)
		standing += body_overlay
	if(standing.len)
		overlays_standing[BODY_LAYER] = standing

	apply_overlay(BODY_LAYER)
	dna.species.update_damage_overlays()

/mob/living/carbon/human/species/hobgoblin/proc/update_wearable()
	remove_overlay(ARMOR_LAYER)

	var/list/standing = list()
	var/mutable_appearance/body_overlay
	if(wear_armor)
		body_overlay = mutable_appearance(icon, "[wear_armor.item_state]", -ARMOR_LAYER)
		if(body_overlay)
			standing += body_overlay
	if(head)
		body_overlay = mutable_appearance(icon, "[head.item_state]", -ARMOR_LAYER)
		if(body_overlay)
			standing += body_overlay
	if(standing.len)
		overlays_standing[ARMOR_LAYER] = standing

	apply_overlay(ARMOR_LAYER)

/mob/living/carbon/human/species/hobgoblin/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	ADD_TRAIT(src, TRAIT_HARDSOLE, INNATE_TRAIT)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.goblin_aggro, TRUE)
	gender = MALE
	if(src.dna && src.dna.species)
		src.dna.species.soundpack_m = new /datum/voicepack/other/goblin() //REMINDER TO UPDATE!!!
		src.dna.species.soundpack_f = new /datum/voicepack/other/goblin() //REMINDER TO UPDATE!!!
		var/obj/item/headdy = get_bodypart("head")
		if(headdy)
			headdy.icon = 'modular_causticcove/icons/mob/monster/hobgoblins/hobgoblins.dmi'
			headdy.icon_state = "[src.dna.species.id]_head"
			headdy.sellprice = 40 // Double the value, double the threat.
	src.grant_language(/datum/language/orcish)
	var/obj/item/organ/eyes/eyes = src.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/nightmare
	eyes.Insert(src)
	src.underwear = "Nude"
	for(var/datum/charflaw/cf in src.charflaws)
		QDEL_NULL(cf)
	update_body()
	faction = list(FACTION_ORCS)
	name = "hoblin"
	real_name = "hoblin"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	AddComponent(/datum/component/npc_death_line, GLOB.npc_death_lines_goblin, 25)
	if(hobgob_outfit)
		var/datum/outfit/O = new hobgob_outfit
		if(O)
			equipOutfit(O)


//////////////////   OUTFITS	//////////////////

/datum/outfit/job/roguetown/npc/hobgoblin/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 9 
	H.STAINT = 5 //Somewhat smart buggers!
	H.STACON = 10
	H.STAWIL = 10
	H.STASPD = 8 //But a little slow, considering that they're more tanky than bitey...


	var/loadout = rand(1,10)
	//If they can make metal/plate armor, they 100% can make metal / iron weapons.
	//Most hoblins will always be wearing armor when encountering. Hoblin armor is relatively weak due to there only being one layer. 
	switch(loadout)
		if(1) //Spear and Leathers
			r_hand = /obj/item/rogueweapon/spear
			if(prob(50))
				head = /obj/item/clothing/head/roguetown/helmet/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(2) //Axe and Leathers
			r_hand = /obj/item/rogueweapon/stoneaxe/handaxe
			if(prob(50))
				head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(3) //Mace and Leathers
			r_hand = /obj/item/rogueweapon/mace
			if(prob(50))
				head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(4) //Iron Messser and Leathers (Strong Foe, fight with caution. Rarer chance for helms)
			r_hand = /obj/item/rogueweapon/sword/short/messer/iron
			if(prob(15))
				head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(5)
			r_hand = /obj/item/rogueweapon/sword/short/iron
			l_hand = /obj/item/rogueweapon/shield/heater
			if(prob(75)) //Armored Hobbers, SnS w/ Plate Armor, leather if they don't roll plate.
				head = /obj/item/clothing/head/roguetown/helmet/hobgoblin
			else
				head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			if(prob(75))
				armor =	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin
			else
				armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(6) //Scary foes. Always spawn withour helmet protection to compensate for their AP potential.
			r_hand = /obj/item/rogueweapon/mace/warhammer
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(7) //Hoblin variant of scary knife holder that does a lot of stabby stabby. Very scary. Spawns without helmet to compensate.
			r_hand = /obj/item/rogueweapon/huntingknife/idagger
			l_hand = /obj/item/rogueweapon/huntingknife/idagger
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(8) //This Hoblin throws a MEAN punch... Tanky variant. Always spawn with plate. No helm as per usual with these specific niches.
			gloves = /obj/item/clothing/gloves/roguetown/knuckles/bronze
			armor =	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin
		if(9) //Spear and Shield Hoblin. Has distance to stab, and a shield to defend. Threatening, spawns in full leathers.
			r_hand = /obj/item/rogueweapon/spear
			l_hand = /obj/item/rogueweapon/shield/heater
			if(prob(33))
				head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(10) // The BIG BAD BOSS HOBLIN. This one is special, spawning with a Greatsword and full plate. Spawn rate should be offset by existing hoblin variants, 1/10 chance...
			r_hand = /obj/item/rogueweapon/greatsword/iron
			head = /obj/item/clothing/head/roguetown/helmet/hobgoblin
			armor =	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin

	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE) // Average Advent Dueler
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
