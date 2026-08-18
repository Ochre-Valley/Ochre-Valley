/datum/advclass/wretch/madtinkerer //The wretch evolution of a tinkerer who goes a bit too far. Similar to munitioneer- but with gadgets instead of a riddle of steel, and magic instead of miracles
	name = "Mad Tinkerer"
	tutorial = "Your craft has fascinated you beyond what most would consider reasonable limits. No lawful guild would fund your machinations. No matter. Your work will continue, at any cost."
	outfit = /datum/outfit/job/roguetown/wretch/madtinkerer
	cmode_music = 'sound/music/combat_dwarf.ogg'
	class_select_category = CLASS_CAT_ROGUE
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_TRAINED_SMITH, TRAIT_INTELLECTUAL, TRAIT_ARCYNE, TRAIT_SMITHING_EXPERT, TRAIT_ALCHEMY_EXPERT, TRAIT_JACKOFALLTRADES) //gains jackofalltrades in place of forgeblessed, such that you don't have to be a malumite to effectively level crafting skills
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
		STATKEY_WIL = 1,
		STATKEY_FOR = 1
	)

	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE, //crossbows, firearms, and a big wrench
		/datum/skill/combat/firearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_MASTER,
		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN, //similar skill list to munitioneer, but their skills start a touch lower, with the exception of Engineering
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN
	)

/datum/outfit/job/roguetown/wretch/madtinkerer/pre_equip(mob/living/carbon/human/H)
	to_chat(H, span_warning("Combat is not ideal, but you're no pushover. Your prowess would be called madness, to the close-minded folks of 'proper society'. They might even say your ambition will lead to ruin. You know better."))
	mask = /obj/item/clothing/mask/rogue/facemask/steel/confessor/tinkerer
	cloak = /obj/item/clothing/suit/roguetown/shirt/robe/physician/tinkerer
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/labboots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/white
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/labcoat
	gloves = /obj/item/clothing/gloves/roguetown/angle/labgloves
	cloak = /obj/item/clothing/suit/roguetown/shirt/robe/physician/tinkerer
	belt = /obj/item/storage/belt/rogue/leather/black
	neck = /obj/item/clothing/neck/roguetown/leather
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/contraption/linker/mace/big/steel/precharged
	backpack_contents = list(
		/obj/item/rogueweapon/tongs/bronze = 1,
		/obj/item/chalk = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/rogueweapon/hammer/bronze = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/clothing/mask/rogue/spectacles/golden = 1,
		/obj/item/storage/hip/orestore/bronze = 1
		)
	if(H.mind)
		H.AddComponent(/datum/component/ore_sight)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/engineeranalyze)
		var/fixations = list("Of Arcyne Laws and Convolutions", "Of Lux, Metal, and Flesh", "Of Cog-song and Alchymical Truimph")
		var/fixation_choice = input(H, "What is your pursuit?", "THEY CALLED ME MAD!") as anything in fixations
		var/mage = FALSE
		switch(fixation_choice)
			if("Of Arcyne Laws and Convolutions") //you get better magic than the other tinkerers, but still on the lower end of magic users who get a major aspect.
				to_chat(H, span_warning("Within the secrets of the Arcyne lie the fundament, the true underpinnings of reality, dream, and divinity. Through Arcyne mastery, the world might be brought to heel. No pursuit is greater"))
				H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 6, "allowed_majors" = list(/datum/magic_aspect/pyromancy, /datum/magic_aspect/ferramancy, /datum/magic_aspect/cryomancy, /datum/magic_aspect/kinesis, /datum/magic_aspect/battlewardry), "locked_aspects" = list(/datum/magic_aspect/artifice), "ward" = TRUE))
				mage = TRUE
				backr = /obj/item/rogueweapon/contraption/linker/mace/big/preloaded/implement //worse damage, but works as an arcane focus
			if("Of Lux, Metal, and Flesh")//get medical ability, and a special prosthetic of your choice, as well as relevant crafting recipes
				to_chat(H, span_warning("The truth of humenity and inhumenity lies within the Lux, the tapestry of control and the mind. The shape of the body is yet flawed, and might be bolstered by masterworks in rivalry to those of the gods. No pursuit is greater"))
				ADD_TRAIT(H, TRAIT_MEDICINE_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_EXPERT, TRUE)//allows for organ manipulation, and use of the fulmenor chair
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backpack_contents += /obj/item/storage/belt/rogue/surgery_bag/full/physician

			if("Of Cog-song and Alchymical Truimph")//classic tinkerer. You get to start with a bunch of fun gadgets. And explosives!
				ADD_TRAIT(H, TRAIT_EXPLOSIVE_SUPPLY, TRAIT_GENERIC)
				to_chat(H, span_warning("The dance of the cosmos is the stage of the divine, yet measurable all the same in teeth of a simple bronze cog. With the correct reagents and medicines, under the correct sky, the work of humen hands might shape the tapestry of the world. No pursuit is greater"))
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_JOURNEYMAN, TRUE)
				cloak = /obj/item/twstrap/bombstrap/bomb_and_fire
				gloves = /obj/item/clothing/gloves/roguetown/chain/contraption/voltic/precharged
				backpack_contents += /obj/item/grapplinghook
				backpack_contents += /obj/item/herbseed/fyritius //for blowing things up ::)
				backpack_contents += /obj/item/folding_alchcauldron_stored
				backpack_contents += /obj/item/folding_alchstation_stored
				backpack_contents += /obj/item/reagent_containers/glass/bottle/waterskin/purifier
		if(!mage)
			H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 5, "locked_aspects" = list(/datum/magic_aspect/artifice), "ward" = TRUE))
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			var/weapons = list("Pistol", "Slurbow", "Arcyne Silver Dagger")
			var/weapon_choice = input(H, "Choose your sidearm.", "A COMPELLING ARGUMENT") as anything in weapons
			switch(weapon_choice)
				if("Pistol")
					H.adjust_skillrank_up_to(/datum/skill/combat/firearms, SKILL_LEVEL_EXPERT, TRUE)
					l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/arquebus/pistol
					beltl = /obj/item/quiver/bulletpouch/iron
					beltr = /obj/item/powderflask
				if("Slurbow")
					H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
					beltl = /obj/item/quiver/bolt/light
					beltr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
				if("Arcyne Silver Dagger")
					H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
					l_hand =  /obj/item/rogueweapon/huntingknife/idagger/silver/arcyne
					beltl = /obj/item/rogueweapon/scabbard/sheath
		wretch_select_bounty(H)

/obj/item/clothing/mask/rogue/facemask/steel/confessor/tinkerer
	name = "strange mask"
	desc = "A product of strange artifice, protecting the wearer from noxious fumes and shrapnel to the eyes. You can taste copper whenever you draw breath."
	icon_state = "tinkerermask"
	icon = 'modular_ochrevalley/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_ochrevalley/icons/roguetown/clothing/onmob/masks.dmi'
	max_integrity = ARMOR_INT_MASK_IRON
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	armor = ARMOR_LABWEAR
	smeltresult = /obj/item/ingot/bronze
	block2add = FOV_DEFAULT //similar to the malpractitioner's mask, you get full vision for the sake of drip. You do not, however, gain the full integrity of the confessor's mask

/obj/item/clothing/mask/rogue/facemask/steel/confessor/tinkerer/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/clothing/mask/rogue/spectacles/inq))
		to_chat(user, span_info("The lenses won't fit your mask."))
	else
		return(..())

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/labcoat
	name = "treated leather coat"
	desc = "A heavy coat of hide, reinforced with copper threads and bleached white by a potent alchemical treatment. Capable of withstanding extreme heat, and protecting the wearer, somewhat, from lightning."
	armor = ARMOR_LABWEAR
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	color = "#feead7"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/white
	color = "#feead7"

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/labcoat/equipped(mob/user, slot)
	..()
	if(HAS_TRAIT(user, TRAIT_IRONMAN)) //there's a bunch of construct jank if they get shock immunity. don't fuck wth it
		return
	if(slot == SLOT_ARMOR)
		ADD_TRAIT(user, TRAIT_SHOCKIMMUNE, "labcoat") //not a terribly relevant trait here, but it'll come up at times
		return

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/labcoat/dropped(mob/user, slot)
	..()
	if(slot != SLOT_ARMOR)
		REMOVE_TRAIT(user, TRAIT_SHOCKIMMUNE, "labcoat")
		return

/obj/item/clothing/gloves/roguetown/angle/labgloves
	name = "treated leather gloves"
	desc = "A pair of heavy leather gloves, treated for extreme resistance to heat and foul liquid alike."
	armor = ARMOR_LABWEAR
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	color = "#3d3d3e"

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/labboots
	name = "treated leather boots"
	desc = "A pair of heavy leather boots, alchemically treated to resist both flame and acid."
	armor = ARMOR_LABWEAR
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/item/rogueweapon/contraption/linker/mace/big/preloaded/implement
	name = "Infused Wrench"
	desc = "An inordinately large bronze wrench, altered to function as a spellcasting focus"
	implement_tier = IMPLEMENT_TIER_LESSER
	implement_refund = IMPLEMENT_REFUND_LESSER

/obj/item/clothing/suit/roguetown/shirt/robe/physician/tinkerer
	name = "natural philosopher's coat"
	desc = "A smart-looking coat for a smart individual."
