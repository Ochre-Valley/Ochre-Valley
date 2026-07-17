/datum/advclass/rogue/buccaneer
	name = "Buccaneer"
	tutorial = "You are a daring rogue of the seas! Buccaneers wield deadly firearms and ruthless cunning - fighting dirty to outgun foes with swagger."
	outfit = /datum/outfit/job/roguetown/adventurer/buccaneer
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_NUTCRACKER, TRAIT_DECEIVING_MEEKNESS)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/firearms = SKILL_LEVEL_APPRENTICE, // Instead of knives, you have a gun! But it's still just a sidearm.
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
	)

/* OV Edit: Refactor arquebus pistol to inherit from arquebus.
/datum/outfit/job/roguetown/adventurer/buccaneer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a daring rogue of the seas! Buccaneers wield deadly firearms and ruthless cunning - fighting dirty to outgun foes with swagger."))
	r_hand = /obj/item/gun/ballistic/arquebus_pistol // The gun!
	l_hand = /obj/item/powderflask
	head = /obj/item/clothing/head/roguetown/helmet/tricorn
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogue/instrument/hurdygurdy
	belt = /obj/item/storage/belt/rogue/leather // No tossblades for you, I gave you a gun.
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltl = /obj/item/quiver/bulletpouch/iron
	beltr = /obj/item/rogueweapon/sword/cutlass
	backpack_contents = list(
		/obj/item/bomb = 1,
		/obj/item/lockpick = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/recipe_book/survival = 1
		)
*/ // OV Edit End
