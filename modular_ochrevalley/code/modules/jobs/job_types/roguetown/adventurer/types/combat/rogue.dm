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
	cmode_music = 'sound/music/combat_dungeoneer.ogg'
	traits_applied = list(TRAIT_TRAINED_SMITH, TRAIT_INTELLECTUAL, TRAIT_ARCYNE, TRAIT_SMITHING_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 4, "locked_aspects" = list(/datum/magic_aspect/artifice), "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/firearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,//besides engineering, they have the bare minimum to maintain most equipment. Meant to run a repair-support role in most parties
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE
	)
	extra_context = "Chooses between a Pistol, a Rifle, a Grappler, a Clockwork Drill, Voltic Gauntlets, or Bronze Limbs. May have a big wrench, or a small wrench."

/datum/outfit/job/roguetown/adventurer/tinkerer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("In another life, your intellect, connections, and aptitude for blending well-worked bronze with Arcyne mysteries would have made for a fine guildsman. Whilst unnaccustomed to combat, your cleverness and inventions offer you a novel edge."))
	if(H.mind)
		var/gadgets = list("Pistol", "Rifle", "Crossbow", "Grappling Hook", "Clockwork Drill", "Voltic Gauntlets", "Bronze Limbs")
		var/gadget_choice = input(H, "Choose a gadget.", "YOUR LATEST CREATION") as anything in gadgets
		H.set_blindness(0)
		switch(gadget_choice)
			if("Pistol")
				beltl = /obj/item/quiver/bulletpouch/iron
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/pistol
				l_hand = /obj/item/powderflask
			if("Rifle")
				beltl = /obj/item/quiver/bulletpouch/iron
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus
				l_hand = /obj/item/powderflask
			if("Crossbow")
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/quiver/bolt/standard
			if("Grappling Hook")
				r_hand = /obj/item/grapplinghook
			if("Clockwork Drill")
				backr = /obj/item/rogueweapon/contraption/pick/drill/precharged
			if("Voltic Gauntlets")
				gloves = /obj/item/clothing/gloves/roguetown/chain/contraption/voltic/precharged
			if("Bronze Limbs")
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
		var/wrenches = list("Compact Wrench", "Massive Wrench")
		var/wrench_choice = input(H, "Choose your tool.", "TINKERER'S PRIDE") as anything in wrenches
		switch(wrench_choice)
			if("Compact Wrench")
				beltr = /obj/item/rogueweapon/contraption/linker/mace/preloaded
			if("Massive Wrench")
				beltr = /obj/item/rogueweapon/contraption/linker/mace/big/preloaded
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	head = /obj/item/clothing/mask/rogue/spectacles/golden //DRIP
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/backpack
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	belt = /obj/item/storage/belt/rogue/leather
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/chalk = 1,
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/rogueweapon/tongs = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		)

/obj/item/clothing/gloves/roguetown/chain/contraption/voltic/precharged
	current_charge = 20

/obj/item/rogueweapon/contraption/pick/drill/precharged
	current_charge = 600
