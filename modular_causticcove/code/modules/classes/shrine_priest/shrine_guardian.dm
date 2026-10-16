# define SHRINEGUARDIAN_TUTORIAL "You were once a guardian of a shrine in the far eastern lands of Kazengun. For one reason or another you have departed from your homeland and sailed far across the seas to these western lands. Perhaps you were forced out by marauding ronin or beasts. Or maybe you have an unusual desire to spread the word of Aisata and Saidon's Twelve Children to the west. These foreign lands are lethal indeed, but you will be more so."

/datum/advclass/foreigner/shrine_guardian
	name = "Shrine Guardian"
	tutorial = SHRINEGUARDIAN_TUTORIAL
	allowed_sexes = list(MALE, FEMALE)
	allowed_patrons = ALL_KAZENGUN_PATRONS //guardian of the twelve... and saidon but no undivided
	outfit = /datum/outfit/job/roguetown/adventurer/shrine_guardian
	subclass_languages = list(/datum/language/kazengunese)
	category_tags = list(CTAG_ADVENTURER)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT) // Hit fast, hit hard, but survive attacks by  avoidance. You have spacing tools to avoid getting whacked - use 'em!
	cmode_music = 'sound/music/combat_kazengite.ogg'
	//OV edit
	subclass_stats = list(
		STATKEY_WIL = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = 1,
		// 5 stat weight. Unlike the advent Paladin (7 stat weight), these guys don't even have medium armor, but they do have the strong dodge expert! A more lightweight, mobility-focused, Kazengunese paladin of sorts.
	)
	//OV edit end
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

	extra_context = "This class has access to tier 1 miracles, and can choose between four combinations of a weapon and bow: Naginata + Shortbow, Hwando + Shortbow, Kanabo + Shortbow, or Naginata + Recurve Bow."

/*/datum/outfit/job/roguetown/adventurer/shrine_guardian //OV Edit - All Kazengun Patrons Unlocked
	allowed_patrons = list(/datum/patron/divine/astrata)*/

/datum/outfit/job/roguetown/adventurer/shrine_guardian/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_notice(SHRINEGUARDIAN_TUTORIAL))
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1) //Capped to T1 miracles.
	head = /obj/item/clothing/head/roguetown/mentorhat
	cloak = /obj/item/clothing/cloak/kazengun //OV Add: Added Kazengun Drip to Kazengun Class
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
	shoes = /obj/item/clothing/shoes/roguetown/gladiator //OV Edit: Fixed pathing for sandals
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	gloves = /obj/item/clothing/gloves/roguetown/plate/kote //OV Edit: Parity with priest + fashion
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/kazengun
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/quiver/arrows
	backpack_contents = list(
		/obj/item/flashlight/flare/torch,
		/obj/item/needle/thorn/cleric
		)
	var/weapons = list("Naginata + Shortbow", "Hwando + Shortbow", "Kanabo + Shortbow", "Naginata + Recurve Bow") //OV Edit: Added Naginata + Shortbow
	if(H.mind)
		var/weapon_choice = input(H, "Choose your weapons.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Kanabo + Shortbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/mace/goden/steel/kanabo
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
				//OV Add Start
			if("Naginata + Shortbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/spear/naginata
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
				//OV Add End: Added option for Naginata Maxing on spawn
			if("Hwando + Shortbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
				r_hand = /obj/item/rogueweapon/sword/sabre/mulyeog
				beltl = /obj/item/rogueweapon/scabbard/sword/kazengun
				//OV Add End: Added option for Naginata Maxing on spawn
			if("Naginata + Recurve Bow")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/rogueweapon/scabbard/gwstrap //OV Add: Added so can holster naginata
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve //OV Edit: Adjusted for spawn
				l_hand = /obj/item/rogueweapon/spear/naginata //OV Edit: Adjusted for spawn

	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
		if(/datum/patron/divine/noc)
			wrists = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/roguetown/psicross/necra
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			wrists = /obj/item/clothing/neck/roguetown/psicross/eora
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/roguetown/psicross/xylix
		if(/datum/patron/divine/pestra)
			wrists = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/inhumen/zizo)
			wrists = /obj/item/clothing/neck/roguetown/psicross
			H.mind?.special_items["Amulet of Zimiko"] = /obj/item/clothing/neck/roguetown/psicross/inhumen
		if(/datum/patron/inhumen/baotha)
			wrists = /obj/item/clothing/neck/roguetown/psicross
			H.mind?.special_items["Amulet of Baosumi"] = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
		if(/datum/patron/inhumen/matthios)
			wrists = /obj/item/clothing/neck/roguetown/psicross
			H.mind?.special_items["Amulet of Matoko"] = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
		if(/datum/patron/inhumen/graggar)
			wrists = /obj/item/clothing/neck/roguetown/psicross
			H.mind?.special_items["Amulet of Gaiyuke"] = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
		else
			wrists = /obj/item/clothing/neck/roguetown/psicross

#undef SHRINEGUARDIAN_TUTORIAL
