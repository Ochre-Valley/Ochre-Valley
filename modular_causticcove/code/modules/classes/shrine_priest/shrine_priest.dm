/datum/advclass/mercenary/shrine_priest
	name = "Shrine Priest"
	tutorial = "Your a Shrine Priest someone trained in the mystical arts of Kazegun not a farmer or commonfolk, the rituals you preform to comune with spirits or lay them to rest. Weither it be through prayer, or a dance of miracles and blade. For one reason or another you have left Kazegun wether to pursue a better life, coin or just seeking a fresh start."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES //no dwarf sprites
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

/*/datum/outfit/job/roguetown/mercenary/shrine_priest //OV Edit - All Kazengun Patrons Unlocked
	allowed_patrons = list(/datum/patron/divine/astrata)*/

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
