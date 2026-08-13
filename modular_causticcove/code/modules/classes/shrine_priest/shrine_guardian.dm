# define SHRINEGUARDIAN_TUTORIAL "You were once a guardian of a shrine in the far eastern lands of Kazengun. For one reason or another you have departed from your homeland and sailed far across the seas to these western lands. Perhaps you were forced out by marauding ronin or beasts. Regardless of the cause, these foreign lands are lethal indeed... but you will be even more so."

/datum/advclass/foreigner/shrine_guardian
	name = "Shrine Guardian"
	tutorial = SHRINEGUARDIAN_TUTORIAL
	allowed_sexes = list(MALE, FEMALE)
	allowed_patrons = ALL_KAZENGUN_PATRONS //guardian of the twelve... and saidon but no undivided
	outfit = /datum/outfit/job/roguetown/mercenary/shrine_guardian
	subclass_languages = list(/datum/language/kazengunese)
	category_tags = list(CTAG_ADVENTURER)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_CRITICAL_RESISTANCE) // NO dodge expert. Hit fast, hit hard, but survive attacks by sheer grit and avoidance. You have spacing tools to avoid getting whacked - use 'em!
	cmode_music = 'sound/music/combat_kazengite.ogg'
	//OV edit
	subclass_stats = list(
		STATKEY_WIL = 1,
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_PER = 1
		// 6 stat weight. Unlike the advent Paladin (5 stat weight), these guys don't even have medium armor. A more lightweight, mobility-focused, Kazengunese paladin of sorts.
	)
	//OV edit end
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN
	)

/*/datum/outfit/job/roguetown/mercenary/shrine_guardian //OV Edit - All Kazengun Patrons Unlocked
	allowed_patrons = list(/datum/patron/divine/astrata)*/

/datum/outfit/job/roguetown/mercenary/shrine_guardian/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning(SHRINEGUARDIAN_TUTORIAL))
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1) //Capped to T1 miracles.
	head = /obj/item/clothing/head/roguetown/mentorhat
	cloak = /obj/item/clothing/cloak/kazengun //OV Add: Added Kazengun Drip to Kazengun Class
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	shoes = /obj/item/clothing/shoes/roguetown/gladiator //OV Edit: Fixed pathing for sandals
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata //OV Edit: Moved to wrists slot
	gloves = /obj/item/clothing/gloves/roguetown/plate/kote //OV Edit: Parity with priest + fashion
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/kazengun
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/needle,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		)
	var/weapons = list("Eagle's Beak + Shortbow","Naginata + Shortbow","Naginata + Recurve Bow") //OV Edit: Added Naginata + Shortbow
	if(H.mind)
		var/weapon_choice = input(H, "Choose your weapons.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Eagle's Beak + Shortbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/eaglebeak
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
				beltr = /obj/item/quiver/arrows
				//OV Add Start
			if("Naginata + Shortbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/spear/naginata
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
				beltr = /obj/item/quiver/arrows
				//OV Add End: Added option for Naginata Maxing on spawn
			if("Naginata + Recurve Bow")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
				backr = /obj/item/rogueweapon/scabbard/gwstrap //OV Add: Added so can holster naginata
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve //OV Edit: Adjusted for spawn
				l_hand = /obj/item/rogueweapon/spear/naginata //OV Edit: Adjusted for spawn
				beltr = /obj/item/quiver/arrows

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
		if(/datum/patron/divine/dendor)
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

#undef SHRINEGUARDIAN_TUTORIAL
