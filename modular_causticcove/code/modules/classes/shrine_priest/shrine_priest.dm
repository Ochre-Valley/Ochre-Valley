#define CHOICE_NORMALMISSIONARY "Not terribly. (Normal Missionary)"
#define CHOICE_SHRINEPRIEST "Closely! (Shrine Priest)"
#define SHRINEPRIEST_TUTORIAL "You are a shrine priest from the far eastern lands of Kazengun, trained in the holy arts of your homeland. You have a history of performing rituals, communing with the spirits, laying those spirits to rest, and more such holy services at shrine that was your charge. For one reason or another you have departed from both your shrine and Kazengun, and have traveled far across the seas to the west."

/datum/outfit/job/roguetown/adventurer/missionary/proc/apply_shrine_priest(mob/living/carbon/human/H)
	cloak = /obj/item/clothing/cloak/kazengun
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan/shitty
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/kazengun
	backl = /obj/item/storage/backpack/rogue/satchel
	head = null // A lot of hoods are applied by normal Missionary...
	to_chat(H, span_notice(SHRINEPRIEST_TUTORIAL))
	// Sovlful additional text based on specific patrons
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			to_chat(H, span_warning("Even the people of your homeland reviled those who harness the gifts of Zimiko. You will show these people why they, too, are wrong to reject the power of the so-called 'Bastard Daughter'."))
		if(/datum/patron/inhumen/graggar)
			to_chat(H, span_warning("Those of your homeland reviled Gaiyuke for his relentless, violent pursuits. You will show these people, too, the true reason for Gaiyuke's fury."))
		if(/datum/patron/inhumen/baotha)
			to_chat(H, span_warning("Baosumi brought Joy and Pleasure to this world. In your homeland, she is respected and revered like the rest of the Twelve. Here, though, she is decried as a being of Evil. It's a good thing you know better."))
		if(/datum/patron/inhumen/matthios)
			to_chat(H, span_warning("Matoko brought Wealth and Trade to this world. In your homeland, he is respected and revered like the rest of the Twelve. Here, though, he is decried as a being of Evil. It's a good thing you know better."))

/datum/outfit/job/roguetown/adventurer/missionary/proc/try_get_shrinepriest_choice(mob/living/carbon/human/H)
	var/datum/preferences/prefs = H.client?.prefs
	var/start_choices = list(CHOICE_NORMALMISSIONARY, CHOICE_SHRINEPRIEST)
	// If we're Kazengunese and aren't Undivded (Undivided is not a thing in Kazengun; they worship the Twelve, not the Ten!)
	if(prefs && istype(prefs.virtue_origin, /datum/virtue/origin/kazengun) && !istype(H.patron, /datum/patron/divine/undivided))
		var/choice = tgui_input_list(H, "How tightly bound to the traditions of my homeland am I? (This only affects my starting outfit.)", "Shrine Priest?", start_choices, CHOICE_NORMALMISSIONARY)
		return (choice == CHOICE_SHRINEPRIEST)
	return FALSE

/* OV Remove - this is now a Missionary "subclass"!
/datum/advclass/mercenary/shrine_priest
	name = "Shrine Priest"
	tutorial = "Your a Shrine Priest someone trained in the mystical arts of Kazegun not a farmer or commonfolk, the rituals you preform to comune with spirits or lay them to rest. Weither it be through prayer, or a dance of miracles and blade. For one reason or another you have left Kazegun wether to pursue a better life, coin or just seeking a fresh start."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_SMALL) //no dwarf sprites
	allowed_patrons = ALL_KAZENGUN_PATRONS //guardian of the twelve... and saidon but no undivided
	outfit = /datum/outfit/job/roguetown/mercenary/shrine_priest
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_KAZENGUN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_CRITICAL_RESISTANCE, TRAIT_RITUALIST)
	cmode_music = 'sound/music/combat_kazengite.ogg'
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_LCK = 2, //OV Edit: Fixing stat issue while fixing sandals
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT
	)
*/
/*/datum/outfit/job/roguetown/mercenary/shrine_priest //OV Edit - All Kazengun Patrons Unlocked
	allowed_patrons = list(/datum/patron/divine/astrata)*/

/*
/datum/outfit/job/roguetown/mercenary/shrine_priest/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Your a Shrine Priest someone trained in the mystical arts of Kazegun not a farmer or commonfolk, the rituals you preform to comune with spirits or lay them to rest. Weither it be through prayer, or a dance of miracles and blade. For one reason or another you have left Kazegun wether to pursue a better life, coin or just seeking a fresh start."))
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_2)
	head = /obj/item/clothing/head/roguetown/mentorhat
	cloak = /obj/item/clothing/cloak/kazengun
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	shoes = /obj/item/clothing/shoes/roguetown/gladiator //OV Edit: Fixed pathing for sandals
	neck = /obj/item/clothing/neck/roguetown/psicross/astrata
	gloves = /obj/item/clothing/gloves/roguetown/plate/kote //OV Edit: Removed unused glove spawn call above
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/kazengun
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/needle,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		/obj/item/roguekey/mercenary,
		/obj/item/ritechalk
		)
	H.set_blindness(0)
	beltl = /obj/item/rogueweapon/sword/sabre/mulyeog
	beltr = /obj/item/rogueweapon/scabbard/sword/kazengun
*/

#undef CHOICE_NORMALMISSIONARY
#undef CHOICE_SHRINEPRIEST
#undef SHRINEPRIEST_TUTORIAL
