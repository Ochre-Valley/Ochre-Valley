#define SHRINEPRIEST_TUTORIAL "You are a shrine priest from the far eastern lands of Kazengun, trained in the holy arts of your homeland. You have a history, however vast or small, of performing rituals, communing with the spirits, laying those spirits to rest, and more such holy services at shrine that was your charge. For one reason or another you have departed from both your shrine and Kazengun, and have traveled far across the seas to the west. Your single-minded devotion to the holy arts will prove useful in these violent lands." // OV Add

/datum/advclass/foreigner/shrine_priest
	name = "Shrine Priest"
	tutorial = SHRINEPRIEST_TUTORIAL // OV Edit
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_SMALL) //no dwarf sprites
	allowed_patrons = ALL_KAZENGUN_PATRONS //guardian of the twelve... and saidon but no undivided
	outfit = /datum/outfit/job/roguetown/mercenary/shrine_priest
	subclass_languages = list(/datum/language/kazengunese)
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/combat_kazengite.ogg'
	subclass_stats = list(
		STATKEY_WIL = 1,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
		// 5 stat weight. Compared to Missionary (stat weight 7,) we start with slightly nicer gear, and we do have crit resistance, so we dock 2 comparative stat weight.
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "This subclass regenerates Devotion far quicker, and has access to Tier 3 miracles. It also starts with slightly better gear than Missionary, such as "

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

	H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_JOURNEYMAN)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_3)//Minor regen, capped to T3, parity with other Holy and/or Arcyne caster - no others spend 15 minutes idling only to unlock their entire potential.
	to_chat(H, span_notice(SHRINEPRIEST_TUTORIAL))

	switch(H.patron?.type)
		if(/datum/patron/old_god)
			neck = /obj/item/clothing/neck/roguetown/psicross
			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
			H.adjust_skillrank(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
			ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC) // we keep this one since adventuring cleric doesnt get it like the regular acolyte.
			H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE) // for their arcane spells, very little CDR and cast speed.
			if(H.mind)
				H.mind.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)
			ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC) // So that they can take arcyne potential and not break.
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			H.adjust_skillrank(/datum/skill/labor/fishing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
			ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
			H.grant_language(/datum/language/abyssal)
		if(/datum/patron/divine/dendor)
			H.grant_language (/datum/language/beast)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.adjust_skillrank(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank(/datum/skill/misc/hunting, SKILL_LEVEL_NOVICE, TRUE)
			ADD_TRAIT(H, TRAIT_EXPERT_HUNTER, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_WOODWALKER, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_APPRENTICE, TRUE) // digging graves and carrying bodies builds muscles probably.
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
			var/list/necra_tools = list("Shovel", "Scythe")
			var/tool_choice = input(H, "A reaper, or a digger?", "HOW WILL YOU APPEASE NERIKO?") as anything in necra_tools
			switch(tool_choice) // choose wisely... larp or effectiveness?
				if("Shovel")
					l_hand = /obj/item/rogueweapon/shovel
				if("Scythe") // o lawd we farmin
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					l_hand = /obj/item/rogueweapon/scythe
					H.adjust_skillrank(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE) // We get a bit of skill for farmin as part of our "slightly better gear than Missionary" upside
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
			H.adjust_skillrank(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, SKILL_LEVEL_NOVICE, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
			H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
			// We have no staff, so we instead get even BETTER unarmed skill! (up to Journeyman)
			H.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_NOVICE, TRUE)
			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
			ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank(/datum/skill/labor/lumberjacking, SKILL_LEVEL_APPRENTICE, TRUE)
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
			backpack_contents[/obj/item/reagent_containers/eoran_seed] = 1
			r_hand = /obj/item/rogueweapon/huntingknife/scissors
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/craft/sewing, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/labor/farming, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
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
			H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/music, SKILL_LEVEL_EXPERT, TRUE)
			H.cmode_music = 'sound/music/combat_jester.ogg'
			var/datum/inspiration/I = new /datum/inspiration(H)
			I.grant_inspiration(H, bard_tier = BARD_T2)
			if(H.mind)
				var/instruments = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman", "Psyaltery", "Flute", "Drum", "Shamisen")
				var/instrument_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", instruments)
				H.set_blindness(0)
				switch(instrument_choice)
					if("Harp")
						l_hand = /obj/item/rogue/instrument/harp
					if("Lute")
						l_hand = /obj/item/rogue/instrument/lute
					if("Accordion")
						l_hand = /obj/item/rogue/instrument/accord
					if("Guitar")
						l_hand = /obj/item/rogue/instrument/guitar
					if("Hurdy-Gurdy")
						l_hand = /obj/item/rogue/instrument/hurdygurdy
					if("Viola")
						l_hand = /obj/item/rogue/instrument/viola
					if("Vocal Talisman")
						l_hand = /obj/item/rogue/instrument/vocals
					if("Psyaltery")
						l_hand = /obj/item/rogue/instrument/psyaltery
					if("Flute")
						l_hand = /obj/item/rogue/instrument/flute
					if("Drum")
						l_hand = /obj/item/rogue/instrument/drum
					if("Shamisen")
						l_hand = /obj/item/rogue/instrument/shamisen
	// OV Edit End
	H.set_blindness(0)

#undef SHRINEPRIEST_TUTORIAL
#undef SHRINEPRIEST_CHOICE_MIRACLES
#undef SHRINEPRIEST_CHOICE_BLADE
