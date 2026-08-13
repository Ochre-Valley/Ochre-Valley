#define SHRINEPRIEST_TUTORIAL "You are a shrine priest from the far eastern lands of Kazengun, trained in the holy arts of your homeland. You have a history, however vast or small, of performing rituals, communing with the spirits, laying those spirits to rest, and more such holy services at shrine that was your charge. For one reason or another you have departed from both your shrine and Kazengun, and have traveled far across the seas to the west." // OV Add
#define SHRINEPRIEST_CHOICE_MIRACLES "Holy Arts (T3 Miracles + Medicine skill)" // OV Add
#define SHRINEPRIEST_CHOICE_BLADE "Swordsmanship (T2 Miracles + Hwando) (-1 STR)" // OV Add

/datum/advclass/foreigner/shrine_priest
	name = "Shrine Priest"
	tutorial = SHRINEPRIEST_TUTORIAL // OV Edit
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_SMALL) //no dwarf sprites
	allowed_patrons = ALL_KAZENGUN_PATRONS //guardian of the twelve... and saidon but no undivided
	outfit = /datum/outfit/job/roguetown/mercenary/shrine_priest
	subclass_languages = list(/datum/language/kazengunese)
	category_tags = list(CTAG_ADVENTURER)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_CRITICAL_RESISTANCE, TRAIT_RITUALIST)
	cmode_music = 'sound/music/combat_kazengite.ogg'
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_LCK = 1, //OV Edit: Fixing stat issue while fixing sandals
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
		// 7 stat weight. Compared to Missionary (stat weight 8,) we start with slightly nicer gear.
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT
	)

/*/datum/outfit/job/roguetown/mercenary/shrine_priest //OV Edit - All Kazengun Patrons Unlocked
	allowed_patrons = list(/datum/patron/divine/astrata)*/

/datum/outfit/job/roguetown/mercenary/shrine_priest/pre_equip(mob/living/carbon/human/H)
	..()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	head = /obj/item/clothing/head/roguetown/mentorhat
	cloak = /obj/item/clothing/cloak/kazengun
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	shoes = /obj/item/clothing/shoes/roguetown/gladiator //OV Edit: Fixed pathing for sandals
	gloves = /obj/item/clothing/gloves/roguetown/plate/kote //OV Edit: Removed unused glove spawn call above
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/kazengun
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/needle,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		)
	// OV Edit Start - Choose between regular shrine priest (w/ sword) or focus more on miracles
	var/options = list(SHRINEPRIEST_CHOICE_BLADE, SHRINEPRIEST_CHOICE_MIRACLES)
	var/choice = tgui_input_list(H, "What was my dedication while I served my shrine?", "CHOOSE YOUR ARTS", options, default = SHRINEPRIEST_CHOICE_BLADE)
	// If for whatever reason they closed the choice menu or cancelled, fall back to the default
	if(!choice)
		choice = SHRINEPRIEST_CHOICE_BLADE

	switch(choice)
		if(SHRINEPRIEST_CHOICE_BLADE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN)
			r_hand = /obj/item/rogueweapon/sword/sabre/mulyeog
			beltr = /obj/item/rogueweapon/scabbard/sword/kazengun
			C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_2)
			H.change_stat(STATKEY_STR, -1) // Cuts down our stat weight to 5. You will pay the stat price if you want the cool sword AND T2 miracles!
			to_chat(H, span_notice(SHRINEPRIEST_TUTORIAL + " Although dedicated to the holy arts, you are not defenseless - your blade will see to that."))
		// Sacrifice your neat sword for better holy magic and medicine! Kazengunese missionary, essentially.
		if(SHRINEPRIEST_CHOICE_MIRACLES)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_JOURNEYMAN)
			C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_3)
			to_chat(H, span_notice(SHRINEPRIEST_TUTORIAL + " Your single-minded devotion to the holy arts will prove useful in these violent lands."))

	switch(H.patron?.type)
		if(/datum/patron/old_god)
			neck = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			H.grant_language(/datum/language/abyssal)
		if(/datum/patron/divine/dendor)
			H.grant_language (/datum/language/beast)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		// Kazengun considers Matoko and Baosumi to be benevolent and a part of the holy pantheon with the rest of the Ten. We therefore do not give them TRAIT_HERESIARCH. However the character no doubt knows how heretical they are in these lands, so we put their cross in their stash.
		if(/datum/patron/inhumen/matthios)
			neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			H.mind?.special_items["Amulet of Matoko"] = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
		if(/datum/patron/inhumen/baotha)
			neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			H.mind?.special_items["Amulet of Baosumi"] = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'
	// OV Edit End
	H.set_blindness(0)

#undef SHRINEPRIEST_TUTORIAL
#undef SHRINEPRIEST_CHOICE_MIRACLES
#undef SHRINEPRIEST_CHOICE_BLADE
