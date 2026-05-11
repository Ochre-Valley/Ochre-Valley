/mob/living/carbon/human/species/human/northern/doppelganger
	ai_controller = /datum/ai_controller/human_npc
	faction = list("viking", "station")
	ambushable = FALSE
	cmode = 1
	setparrytime = 30
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)
	var/custom_speech = TRUE // New one specifically for doppelgangers
	var/cloned_target = FALSE // Check whether to clone someone or not.

	var/list/dying_voicelines = list(
		"Augh, no...",
		"I only wanted a chance.",
		"I was the real one..."
	)

	var/list/combat_voicelines = list(
		"Help me!",
		"I'm the real one!",
		"They're fake!",
		"What the fuck.",
		"Who-",
		"They're me!",
		"Get them!!!",
		"???"
	)

/mob/living/carbon/human/species/human/northern/doppelganger/Life()
	.=..()
	if(!cloned_target)
		handle_doppelganger()
	if(prob(3)) // do not make this big or else they NEVER SHUT UP
		if(prob(35))
			emote("laugh")
		else if(custom_speech)
			say(doppel_voiceline(FALSE))

/mob/living/carbon/human/species/human/northern/doppelganger/proc/handle_doppelganger()
	if(cloned_target)
		return FALSE

	for(var/mob/living/carbon/human/our_target in range(15, src))
		if(our_target == src)
			continue
		if(istype(our_target, /mob/living/carbon/human/species/human/northern/doppelganger)) //Don't copy other doppelgangers
			continue
		if(!our_target.client)
			continue
		if(full_clone(our_target, TRUE, TRUE))
			cloned_target = TRUE
			for(var/obj/item/equipped_item in get_equipped_items() + held_items)
				equipped_item.AddComponent(/datum/component/item_on_drop/dust)
			for(var/obj/item/held_item in held_items)
				ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)
			return TRUE

/mob/living/carbon/human/species/human/northern/doppelganger/death(gibbed, nocutscene = FALSE)
	if(custom_speech)
		say(doppel_voiceline(TRUE))
	if(!gibbed)
		var/obj/item/reagent_containers/doppel_heart/our_heart = new /obj/item/reagent_containers/doppel_heart(get_turf(src))
		var/highest_stat = "str"
		var/current_value = STASTR
		if(STASPD > current_value)
			highest_stat = "spd"
			current_value = STASPD
		if(STACON > current_value)
			highest_stat = "con"
			current_value = STACON
		if(STAWIL > current_value)
			highest_stat = "wil"
			current_value = STAWIL
		if(STAPER > current_value)
			highest_stat = "per"
			current_value = STAPER
		if(STAINT > current_value)
			highest_stat = "int"
		our_heart.affected_stat = highest_stat
	.=..()
	if(!gibbed)
		dust(FALSE, FALSE, TRUE)

/mob/living/carbon/human/species/human/northern/doppelganger/ambush
	threat_point = THREAT_HIGH
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/doppelganger/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/doppelganger/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Garrison Deserter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC) //For when they're just kinda patrolling around/ambushes
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()

/mob/living/carbon/human/species/human/northern/doppelganger/proc/doppel_voiceline(var/dying)
	var/mob/living/carbon/human/selected_audience
	for(var/mob/living/carbon/human/audience in range(7, src))
		if(!audience.client) //Only troll players
			continue
		if(audience.nickname == "Please Change Me") //Make sure they have a real nickname
			continue
		if(audience.name == name) //Don't plea to ourselves
			continue
		if(audience == src)
			continue
		selected_audience = audience
		break
	
	var/our_message
	
	if(dying)
		if(patron)
			switch(patron.name)
				if("Psydon")
					dying_voicelines += "Allfather, I could not endure any longer..."
				if("Undivided")
					dying_voicelines += "I fall into the arms of the ten..."
				if("Xylix")
					dying_voicelines += "Xylix, did I amuse you?"
				if("Ravox")
					dying_voicelines += "Ravox, was I unjust?"
				if("Abyssor")
					dying_voicelines += "Sink me into the abyss of dreams."
				if("Astrata")
					dying_voicelines += "Sun, please shine your light on me one last time..."
				if("Dendor")
					dying_voicelines += "Argh- NOW I AM ONE WITH THE TREEFATHER!"
				if("Eora")
					dying_voicelines += "Into the bosom I fall..."
				if("Malum")
					dying_voicelines += "What was I if not a beautiful creation?"
				if("Necra")
					dying_voicelines += "My lady, I was always ready."
				if("Noc")
					dying_voicelines += "I have never seen the night so dark..."
				if("Pestra")
					dying_voicelines += "Imbue my heart unto others, it is my gift to you."
				if("Baotha")
					dying_voicelines += "What an interruption..."
				if("Graggar")
					dying_voicelines += "I fought to the end..."
				if("Matthios")
					dying_voicelines += "You stole my right to a lyfe."
				if("Zizo")
					dying_voicelines += "What am I?"
		if(selected_audience)
			dying_voicelines += "[selected_audience.real_name], why?"
		our_message = pick(dying_voicelines)
		return our_message
	
	if(selected_audience)
		combat_voicelines += "Help, [selected_audience.nickname]!"
		combat_voicelines += "Please, [selected_audience.real_name]!"
		combat_voicelines += "[selected_audience.nickname]!"
		combat_voicelines += "I'm the real [real_name]!"
		combat_voicelines += "It's me, [real_name]!"
		combat_voicelines += "[selected_audience.real_name]..."
		combat_voicelines += "[selected_audience.nickname], get the fake [real_name]!"
		combat_voicelines += "[real_name] is a fake!"
	
	if(patron)
		switch(patron.name)
			if("Psydon")
				combat_voicelines += "I will ENDURE!"
			if("Undivided")
				combat_voicelines += "By the Ten!"
			if("Xylix")
				combat_voicelines += "HAHAHA!"
			if("Ravox")
				combat_voicelines += "I will deliver you unto justice!"
			if("Abyssor")
				combat_voicelines += "I shall crash a tide upon you!"
			if("Astrata")
				combat_voicelines += "Light guide my hand!"
			if("Dendor")
				combat_voicelines += "For the call of the wilds!"
			if("Eora")
				combat_voicelines += "I have Eora's love about me."
			if("Malum")
				combat_voicelines += "I am a divine instrument!"
			if("Necra")
				combat_voicelines += "Fear not, I shall bury you proper."
			if("Noc")
				combat_voicelines += "For the moon."
			if("Pestra")
				combat_voicelines += "I shall soothe what ails you."
			if("Baotha")
				combat_voicelines += "Oh, what joy!"
			if("Graggar")
				combat_voicelines += "I WILL kill you!"
			if("Matthios")
				combat_voicelines += "This is justice!"
			if("Zizo")
				combat_voicelines += "What manner of creation are you?"
	our_message = pick(combat_voicelines)
	return our_message


///////////////FULL CLONE PROC - May move to its own place one day

/mob/living/carbon/human/proc/full_clone(var/mob/living/carbon/human/our_target, var/npc_setup, var/include_equipment)
	if(!ishuman(our_target))
		return FALSE
	if(our_target == src)
		return FALSE
	

	if(npc_setup)
		ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
		ADD_TRAIT(src, TRAIT_STEELHEARTED, TRAIT_GENERIC)

	//Appearance copy
	set_species(our_target.dna.species.type)
	eye_color = our_target.eye_color
	gender = our_target.gender
	dna.features = our_target.dna.features.Copy()
	name = our_target.name
	real_name = our_target.real_name
	patron = our_target.patron
	pronouns = our_target.pronouns
	mob_descriptors = our_target.mob_descriptors.Copy()
	voice_type = our_target.voice_type
	d_intent = our_target.d_intent
	

	//head
	for(var/obj/item/bodypart/head/our_head in bodyparts)
		for(var/obj/item/bodypart/head/their_head in our_target.bodyparts)
			for(var/datum/bodypart_feature/part in their_head.bodypart_features)
				our_head.clone_bodypart_feature(part)
	
	//taur
	for(var/obj/item/bodypart/taur/part in our_target.bodyparts)
		Taurize(part.type)
	
	//tail
	for(var/obj/item/organ/tail/part in our_target.internal_organs)
		var/obj/item/organ/tail/new_part = new part.type()
		new_part.accessory_colors = part.accessory_colors
		new_part.accessory_type = part.accessory_type 
		var/obj/item/organ/tail/old_part = getorganslot(ORGAN_SLOT_TAIL)
		if(old_part)
			old_part.Remove(src)
			qdel(old_part)
		new_part.Insert(src, TRUE, FALSE)
	
	//ears
	for(var/obj/item/organ/ears/part in our_target.internal_organs)
		var/obj/item/organ/ears/new_part = new part.type()
		new_part.accessory_colors = part.accessory_colors
		new_part.accessory_type = part.accessory_type 
		var/obj/item/organ/ears/old_part = getorganslot(ORGAN_SLOT_EARS)
		if(old_part)
			old_part.Remove(src)
			qdel(old_part)
		new_part.Insert(src, TRUE, FALSE)

	//snout
	for(var/obj/item/organ/snout/part in our_target.internal_organs)
		var/obj/item/organ/snout/new_part = new part.type()
		new_part.accessory_colors = part.accessory_colors
		new_part.accessory_type = part.accessory_type 
		var/obj/item/organ/snout/old_part = getorganslot(ORGAN_SLOT_SNOUT)
		if(old_part)
			old_part.Remove(src)
			qdel(old_part)
		new_part.Insert(src, TRUE, FALSE)
	
	//horns
	for(var/obj/item/organ/horns/part in our_target.internal_organs)
		var/obj/item/organ/horns/new_part = new part.type()
		new_part.accessory_colors = part.accessory_colors
		new_part.accessory_type = part.accessory_type 
		var/obj/item/organ/horns/old_part = getorganslot(ORGAN_SLOT_HORNS)
		if(old_part)
			old_part.Remove(src)
			qdel(old_part)
		new_part.Insert(src, TRUE, FALSE)
	
	//wings
	for(var/obj/item/organ/wings/part in our_target.internal_organs)
		var/obj/item/organ/wings/new_part = new part.type()
		new_part.accessory_colors = part.accessory_colors
		new_part.accessory_type = part.accessory_type 
		var/obj/item/organ/wings/old_part = getorganslot(ORGAN_SLOT_WINGS)
		if(old_part)
			old_part.Remove(src)
			qdel(old_part)
		new_part.Insert(src, TRUE, FALSE)
	
	//frills
	for(var/obj/item/organ/frills/part in our_target.internal_organs)
		var/obj/item/organ/frills/new_part = new part.type()
		new_part.accessory_colors = part.accessory_colors
		new_part.accessory_type = part.accessory_type 
		var/obj/item/organ/frills/old_part = getorganslot(ORGAN_SLOT_FRILLS)
		if(old_part)
			old_part.Remove(src)
			qdel(old_part)
		new_part.Insert(src, TRUE, FALSE)
	
	//belly
	for(var/obj/item/organ/belly/part in our_target.internal_organs)
		var/obj/item/organ/belly/new_part = new part.type()
		new_part.accessory_colors = part.accessory_colors
		new_part.accessory_type = part.accessory_type 
		new_part.belly_size = part.belly_size
		var/obj/item/organ/belly/old_part = getorganslot(ORGAN_SLOT_BELLY)
		if(old_part)
			old_part.Remove(src)
			qdel(old_part)
		new_part.Insert(src, TRUE, FALSE)
	
	//breasts
	for(var/obj/item/organ/breasts/part in our_target.internal_organs)
		var/obj/item/organ/breasts/new_part = new part.type()
		new_part.accessory_colors = part.accessory_colors
		new_part.accessory_type = part.accessory_type 
		new_part.breast_size = part.breast_size
		var/obj/item/organ/breasts/old_part = getorganslot(ORGAN_SLOT_BREASTS)
		if(old_part)
			old_part.Remove(src)
			qdel(old_part)
		new_part.Insert(src, TRUE, FALSE)
	
	//vagina
	for(var/obj/item/organ/vagina/part in our_target.internal_organs)
		var/obj/item/organ/vagina/new_part = new part.type()
		new_part.accessory_colors = part.accessory_colors
		new_part.accessory_type = part.accessory_type 
		var/obj/item/organ/vagina/old_part = getorganslot(ORGAN_SLOT_VAGINA)
		if(old_part)
			old_part.Remove(src)
			qdel(old_part)
		new_part.Insert(src, TRUE, FALSE)
	
	//penis
	for(var/obj/item/organ/penis/part in our_target.internal_organs)
		var/obj/item/organ/penis/new_part = new part.type()
		new_part.accessory_colors = part.accessory_colors
		new_part.accessory_type = part.accessory_type 
		new_part.penis_size = part.penis_size
		var/obj/item/organ/penis/old_part = getorganslot(ORGAN_SLOT_PENIS)
		if(old_part)
			old_part.Remove(src)
			qdel(old_part)
		new_part.Insert(src, TRUE, FALSE)
	
	//balls
	for(var/obj/item/organ/testicles/part in our_target.internal_organs)
		var/obj/item/organ/testicles/new_part = new part.type()
		new_part.accessory_colors = part.accessory_colors
		new_part.accessory_type = part.accessory_type 
		new_part.ball_size = part.ball_size
		var/obj/item/organ/testicles/old_part = getorganslot(ORGAN_SLOT_PENIS)
		if(old_part)
			old_part.Remove(src)
			qdel(old_part)
		new_part.Insert(src, TRUE, FALSE)

	resize(our_target.size_multiplier)

	//Prefs setting

	devourable = FALSE //Don't allow them to be eaten, it's other players names and appearances, pref break central!

	//Skill copy
	STASTR = our_target.STASTR
	STASPD = our_target.STASPD
	STACON = our_target.STACON
	STAWIL = our_target.STAWIL
	STAPER = our_target.STAPER
	STAINT = our_target.STAINT
	STALUC = our_target.STALUC

	if(include_equipment)
		var/obj/item/equipping_back = our_target.get_item_by_slot(SLOT_BACK)
		if(equipping_back)
			var/obj/item/our_equipment = new equipping_back.type(src)
			equip_to_slot(our_equipment, SLOT_BACK)
		var/obj/item/equipping_wear_mask = our_target.get_item_by_slot(SLOT_WEAR_MASK)
		if(equipping_wear_mask)
			var/obj/item/our_equipment = new equipping_wear_mask.type(src)
			equip_to_slot(our_equipment, SLOT_WEAR_MASK)
		var/obj/item/equipping_wear_neck = our_target.get_item_by_slot(SLOT_NECK)
		if(equipping_wear_neck)
			var/obj/item/our_equipment = new equipping_wear_neck.type(src)
			equip_to_slot(our_equipment, SLOT_NECK)
		var/obj/item/equipping_belt = our_target.get_item_by_slot(SLOT_BELT)
		if(equipping_belt)
			var/obj/item/our_equipment = new equipping_belt.type(src)
			equip_to_slot(our_equipment, SLOT_BELT)
		var/obj/item/equipping_wear_ring = our_target.get_item_by_slot(SLOT_RING)
		if(equipping_wear_ring)
			var/obj/item/our_equipment = new equipping_wear_ring.type(src)
			equip_to_slot(our_equipment, SLOT_RING)
		var/obj/item/equipping_wear_wrists = our_target.get_item_by_slot(SLOT_WRISTS)
		if(equipping_wear_wrists)
			var/obj/item/our_equipment = new equipping_wear_wrists.type(src)
			equip_to_slot(our_equipment, SLOT_WRISTS)
		var/obj/item/equipping_mouth = our_target.get_item_by_slot(SLOT_MOUTH)
		if(equipping_mouth)
			var/obj/item/our_equipment = new equipping_mouth.type(src)
			equip_to_slot(our_equipment, SLOT_MOUTH)
		var/obj/item/equipping_wear_shirt = our_target.get_item_by_slot(SLOT_SHIRT)
		if(equipping_wear_shirt)
			var/obj/item/our_equipment = new equipping_wear_shirt.type(src)
			equip_to_slot(our_equipment, SLOT_SHIRT)
		var/obj/item/equipping_cloak = our_target.get_item_by_slot(SLOT_CLOAK)
		if(equipping_cloak)
			var/obj/item/our_equipment = new equipping_cloak.type(src)
			equip_to_slot(our_equipment, SLOT_CLOAK)
		var/obj/item/equipping_backr = our_target.get_item_by_slot(SLOT_BACK_R)
		if(equipping_backr)
			var/obj/item/our_equipment = new equipping_backr.type(src)
			equip_to_slot(our_equipment, SLOT_BACK_R)
		var/obj/item/equipping_backl = our_target.get_item_by_slot(SLOT_BACK_L)
		if(equipping_backl)
			var/obj/item/our_equipment = new equipping_backl.type(src)
			equip_to_slot(our_equipment, SLOT_BACK_L)
		var/obj/item/equipping_beltl = our_target.get_item_by_slot(SLOT_BELT_L)
		if(equipping_beltl)
			var/obj/item/our_equipment = new equipping_beltl.type(src)
			equip_to_slot(our_equipment, SLOT_BELT_L)
		var/obj/item/equipping_beltr = our_target.get_item_by_slot(SLOT_BELT_R)
		if(equipping_beltr)
			var/obj/item/our_equipment = new equipping_beltr.type(src)
			equip_to_slot(our_equipment, SLOT_BELT_R)
		var/obj/item/equipping_glasses = our_target.get_item_by_slot(SLOT_GLASSES)
		if(equipping_glasses)
			var/obj/item/our_equipment = new equipping_glasses.type(src)
			equip_to_slot(our_equipment, SLOT_GLASSES)
		var/obj/item/equipping_gloves = our_target.get_item_by_slot(SLOT_GLOVES)
		if(equipping_gloves)
			var/obj/item/our_equipment = new equipping_gloves.type(src)
			equip_to_slot(our_equipment, SLOT_GLOVES)
		var/obj/item/equipping_head = our_target.get_item_by_slot(SLOT_HEAD)
		if(equipping_head)
			var/obj/item/our_equipment = new equipping_head.type(src)
			equip_to_slot(our_equipment, SLOT_HEAD)
		var/obj/item/equipping_shoes = our_target.get_item_by_slot(SLOT_SHOES)
		if(equipping_shoes)
			var/obj/item/our_equipment = new equipping_shoes.type(src)
			equip_to_slot(our_equipment, SLOT_SHOES)
		var/obj/item/equipping_wear_armor = our_target.get_item_by_slot(SLOT_ARMOR)
		if(equipping_wear_armor)
			var/obj/item/our_equipment = new equipping_wear_armor.type(src)
			equip_to_slot(our_equipment, SLOT_ARMOR)
		var/obj/item/equipping_wear_pants = our_target.get_item_by_slot(SLOT_PANTS)
		if(equipping_wear_pants)
			var/obj/item/our_equipment = new equipping_wear_pants.type(src)
			equip_to_slot(our_equipment, SLOT_PANTS)
		var/obj/item/equipping_l_store = our_target.get_item_by_slot(SLOT_L_STORE)
		if(equipping_l_store)
			var/obj/item/our_equipment = new equipping_l_store.type(src)
			equip_to_slot(our_equipment, SLOT_L_STORE)
		var/obj/item/equipping_r_store = our_target.get_item_by_slot(SLOT_R_STORE)
		if(equipping_r_store)
			var/obj/item/our_equipment = new equipping_r_store.type(src)
			equip_to_slot(our_equipment, SLOT_R_STORE)
		var/obj/item/equipping_s_store = our_target.get_item_by_slot(SLOT_S_STORE)
		if(equipping_s_store)
			var/obj/item/our_equipment = new equipping_s_store.type(src)
			equip_to_slot(our_equipment, SLOT_S_STORE)
		var/obj/item/equipping_hand1 = our_target.get_active_held_item()
		if(equipping_hand1)
			var/obj/item/our_equipment = new equipping_hand1.type(src)
			put_in_hands(our_equipment)
		var/obj/item/equipping_hand2 = our_target.get_inactive_held_item()
		if(equipping_hand2)
			var/obj/item/our_equipment = new equipping_hand2.type(src)
			put_in_hands(our_equipment)
		var/obj/item/equipping_skin = our_target.skin_armor
		if(equipping_skin)
			skin_armor = new equipping_skin.type(src)
	
	update_body()
	update_hair()
	update_icon()

	return TRUE


/// AMBUSHES

/datum/ambush_config/doppelganger
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/doppelganger/ambush = 1
	)
	threat_point = THREAT_HIGH

/datum/ambush_config/doppelgangers
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/doppelganger/ambush = 2
	)
	threat_point = 2* THREAT_HIGH

//DOPPEL HEART!

/obj/item/reagent_containers/doppel_heart
	name = "doppel heart"
	desc = "A chalky white still beating heart full of vitae. A master of medicine may be able to make use of this."
	icon = 'modular_ochrevalley/icons/roguetown/items/produce.dmi'
	icon_state = "doppel"
	item_state = "doppel"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/vitae = 10)
	grind_results = list(/datum/reagent/vitae = 10)
	sellprice = 150
	var/affected_stat = "str"

/atom/movable/screen/alert/status_effect/buff/doppel_hearted
	name = "Doppel Hearted"
	desc = "This week I am infused with the energy of another being atop my own."
	icon_state = "buff"

/datum/status_effect/buff/doppel_hearted_str
	id = "doppel_heart_str"
	alert_type = /atom/movable/screen/alert/status_effect/buff/doppel_hearted
	effectedstats = list(STATKEY_STR = 1)
	duration = 4 HOURS

/datum/status_effect/buff/doppel_hearted_int
	id = "doppel_heart_int"
	alert_type = /atom/movable/screen/alert/status_effect/buff/doppel_hearted
	effectedstats = list(STATKEY_INT = 1)
	duration = 4 HOURS

/datum/status_effect/buff/doppel_hearted_spd
	id = "doppel_heart_spd"
	alert_type = /atom/movable/screen/alert/status_effect/buff/doppel_hearted
	effectedstats = list(STATKEY_SPD = 1)
	duration = 4 HOURS

/datum/status_effect/buff/doppel_hearted_per
	id = "doppel_heart_per"
	alert_type = /atom/movable/screen/alert/status_effect/buff/doppel_hearted
	effectedstats = list(STATKEY_PER = 1)
	duration = 4 HOURS

/datum/status_effect/buff/doppel_hearted_wil
	id = "doppel_heart_wil"
	alert_type = /atom/movable/screen/alert/status_effect/buff/doppel_hearted
	effectedstats = list(STATKEY_WIL = 1)
	duration = 4 HOURS

/datum/status_effect/buff/doppel_hearted_con
	id = "doppel_heart_con"
	alert_type = /atom/movable/screen/alert/status_effect/buff/doppel_hearted
	effectedstats = list(STATKEY_CON = 1)
	duration = 4 HOURS
