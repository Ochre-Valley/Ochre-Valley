// OV File

/datum/outfit/job/roguetown/adventurer/buccaneer/pre_equip(mob/living/carbon/human/H)
    ..()
    to_chat(H, span_warning("You are a daring rogue of the seas! Buccaneers wield deadly firearms and ruthless cunning - fighting dirty to outgun foes with swagger."))
    r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/pistol // The gun!
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

/datum/advclass/rogue/tinkerer //
	name = "Itinerant Tinkerer"
	tutorial = "In another life, your intellect, connections, and aptitude for blending well-worked bronze with Arcyne mysteries would have made for a fine guildsman. Whilst unnaccustomed to combat, your cleverness and inventions offer you a novel edge."
	outfit = /datum/outfit/job/roguetown/adventurer/tinkerer
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(TRAIT_SEEPRICES, TRAIT_INTELLECTUAL, TRAIT_ARCYNE, TRAIT_SMITHING_EXPERT, TRAIT_LEYLINE_ATTUNEMENT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_STR = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE, 
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,//besides engineering, they have the bare minimum to maintain most equipment. Meant to run a repair-support role in most parties
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/smelting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE
	)
	extra_context = "Chooses between a Pistol, a Grappler, a Clockwork Drill, Voltic Gauntlets (+2 STR, -2 SPD), Bronze Arms(+2 STR, -2 SPD), or Bronze Legs."

/datum/outfit/job/roguetown/adventurer/tinkerer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("In another life, your intellect, connections, and aptitude for blending well-worked bronze with Arcyne mysteries would have made for a fine guildsman. Whilst unnaccustomed to combat, your cleverness and inventions offer you a novel edge."))
	if(H.mind)
		var/gadgets = list("Pistol", "Grappling Hook", "Clockwork Drill", "Voltic Gauntlets", "Bronze Arms", "Bronze Legs")
		var/gadget_choice = input(H, "Choose a gadget.", "YOUR LATEST MASTERPIECE") as anything in gadgets
		H.set_blindness(0)
		switch(gadget_choice)
			if("Pistol")
				H.adjust_skillrank_up_to(/datum/skill/combat/firearms, SKILL_LEVEL_APPRENTICE, TRUE)
				beltl = /obj/item/quiver/bulletpouch/iron
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/pistol
				l_hand = /obj/item/powderflask
			if("Grappling Hook")
				H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/grapplinghook
			if("Clockwork Drill")
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
				r_hand = /obj/item/contraption/pick/drill/precharged
			if("Voltic Gauntlets")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_APPRENTICE, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/chain/contraption/voltic/precharged
				H.change_stat(STATKEY_STR, 2) //we're gonna make the gauntlet tinkerers punchier and slower. trust me, they'll want this. This changes them from a +2 spd, -1 str class, to a +1 str class
				H.change_stat(STATKEY_SPD, -2)
				to_chat(H, span_warning("Compared to your average Tinkerer, I'm a bit burly (+2 Strength, -2 Speed)"))
			if("Bronze Arms")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_APPRENTICE, TRUE)
				H.change_stat(STATKEY_STR, 2) //Tinkerers with big buff metal arms *also* get to feel kinda buff. for a rogue.
				H.change_stat(STATKEY_SPD, -2)
				to_chat(H, span_warning("Compared to your average Tinkerer, I'm a bit burly (+2 Strength, -2 Speed)"))
				var/obj/item/bodypart/rightarm = H.get_bodypart(BODY_ZONE_R_ARM)
				if(rightarm)
					rightarm.drop_limb()
					qdel(rightarm)
				if(H.charflaws.len)
					var/obj/item/bodypart/r_arm/prosthetic/bronzeright/rightbarm = new()
					rightbarm.attach_limb(H)
				var/obj/item/bodypart/leftarm = H.get_bodypart(BODY_ZONE_L_ARM)
				if(leftarm)
					leftarm.drop_limb()
					qdel(leftarm)
				if(H.charflaws.len)
					var/obj/item/bodypart/l_arm/prosthetic/bronzeleft/leftbarm = new()
					leftbarm.attach_limb(H)
			if("Bronze Legs")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
				var/obj/item/bodypart/rightleg = H.get_bodypart(BODY_ZONE_R_LEG)
				if(rightleg)
					rightleg.drop_limb()
					qdel(rightleg)
				if(H.charflaws.len)
					var/obj/item/bodypart/r_leg/prosthetic/bronzeright/rightbleg = new()
					rightbleg.attach_limb(H)
				var/obj/item/bodypart/leftleg = H.get_bodypart(BODY_ZONE_L_LEG)
				if(leftleg)
					leftleg.drop_limb()
					qdel(leftleg)
				if(H.charflaws.len)
					var/obj/item/bodypart/l_leg/prosthetic/bronzeleft/leftbleg = new()
					leftbleg.attach_limb(H)
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/scabbard/sheath
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	belt = /obj/item/storage/belt/rogue/leather
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/chalk = 1,
		/obj/item/rogueweapon/handsaw = 1,
		/obj/item/rogueweapon/hammer/iron,
		/obj/item/clothing/mask/rogue/spectacles/golden = 1// a good tinkerer needs a pair of sickass looking goggles. In backpack so vices won't replace 'em
		)
	H.AddSpell(new /obj/effect/proc_holder/spell/invoked/secularbarter) //They have the Connections like an antiquarian does, but none of the alchemical tricks
	H.mind.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)//A tinkerer is a bit magical, but one of their spells has to be mending 
	H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
	if(!LAZYLEN(H.mind.mage_aspect_config)) 
		H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 2))
		H.mind.check_learnspell()

/obj/item/clothing/gloves/roguetown/chain/contraption/voltic/precharged
	current_charge = 20

/obj/item/contraption/pick/drill/precharged
	current_charge = 600
