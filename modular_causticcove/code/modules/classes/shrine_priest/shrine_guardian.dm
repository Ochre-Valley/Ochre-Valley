/datum/advclass/mercenary/shrine_guardian
	name = "Shrine Guardian"
	tutorial = "You were once a guardian of your shrine in Kazengun. Something has forced you out, if it be maurauding ronin, or too many beasts for you to handle. You are skilled in polearms and bows, using an awkward battle style for hit and run tactics."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES //no dwarf sprites
	allowed_patrons = ALL_KAZENGUN_PATRONS //guardian of the twelve... and saidon but no undivided
	outfit = /datum/outfit/job/roguetown/mercenary/shrine_guardian
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_KAZENGUN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_CRITICAL_RESISTANCE)
	cmode_music = 'sound/music/combat_kazengite.ogg'
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_STR = 1,
		STATKEY_SPD = 3,
		STATKEY_PER = 2
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
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
	to_chat(H, span_warning("You were once a guardian of your shrine in Kazengun. Something has forced you out, if it be maurauding ronin, or too many beasts for you to handle. You are skilled in polearms and bows, using an awkward battle style for hit and run tactics."))
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
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
		/obj/item/roguekey/mercenary
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
