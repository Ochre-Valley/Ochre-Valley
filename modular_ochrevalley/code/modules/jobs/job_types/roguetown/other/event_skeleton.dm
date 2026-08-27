/*
EVENT SKELETONS
*/


/datum/job/roguetown/greater_skeleton/event
	title = "Envigorated Skeleton"
	advclass_cat_rolls = list(CTAG_ESKELETON = 20)
	tutorial = "You are bygone. Your will belongs to your master. Fulfil and kill."

	outfit = /datum/outfit/job/roguetown/greater_skeleton/event
	vice_restrictions = list(/datum/charflaw/hunted, /datum/charflaw/targeted, /datum/charflaw/wanted)

/datum/outfit/job/roguetown/greater_skeleton/event

/datum/outfit/job/roguetown/greater_skeleton/event/pre_equip(mob/living/carbon/human/H)
	..()
	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_LICHLAIR, TRAIT_GENERIC) //Ability to leave/enter the lich's lair without being softlocked inside.
	H.taints_loot = TRUE

// Melee goon w/ sidearm picks like javs/sling/knife/single use net. All-rounder.
/datum/advclass/greater_skeleton/event/legionnaire
	name = "Legionnaire"
	tutorial = "A veteran lineman - oh, how far you've fallen. Your old King is dead, yet your vigil has not yet ended. Bring the fight to those who'd dare to impede your master's rule, with shield-and-sword alike."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/event/legionnaire

	category_tags = list(CTAG_ESKELETON)

/datum/outfit/job/roguetown/greater_skeleton/event/legionnaire/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 12
	H.STASPD = 8
	H.STACON = 9
	H.STAWIL = 12
	H.STAINT = 3
	H.STAPER = 11

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	//Utility skills, unlyve to serve
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy
	belt = /obj/item/storage/belt/rogue/leather/black

	backl = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(
		/obj/item/natural/feather = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy = 1 //Hilarious
	)

	H.adjust_blindness(-3)
	var/weapons = list("Gladius","Khopesh","Shortsword","Axe","Flail")
	var/weapon_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Gladius")
			beltr = /obj/item/rogueweapon/sword/short/gladius/pagladius
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Khopesh")
			beltr = /obj/item/rogueweapon/sword/sabre/palloy
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Shortsword")
			beltr = /obj/item/rogueweapon/sword/short/pashortsword
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Axe")
			beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
			H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
		if("Flail")
			beltr = /obj/item/rogueweapon/flail/sflail/paflail
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
	var/legionnairesidearm = list("A Javelin's Bag + Ancient Shield", "A Throwing Net + Ancient Shield", "A Sling With Decrepit Pellets + Wooden Shield", "An Ancient Dagger + Ancient Shield")
	var/legionnairesidearm_choice = input(H, "Choose your SYDEARM.", "RAGE AGAINST THE LYVING.") as anything in legionnairesidearm
	switch(legionnairesidearm_choice)
		if("A Javelin's Bag + Ancient Shield")
			beltl = /obj/item/quiver/javelin/paalloy
			backr = /obj/item/rogueweapon/shield/bronze/paalloy
		if("A Throwing Net + Ancient Shield")
			beltl = /obj/item/net
			backr = /obj/item/rogueweapon/shield/bronze/paalloy
		if("A Sling With Decrepit Pellets + Wooden Shield")
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, 2, TRUE) //Only apprentice, enough to be annoying
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			beltl = /obj/item/quiver/sling/aalloy //Decrepit vs ballistaires, weak but good for harrassment
			backr = /obj/item/rogueweapon/shield/wood //Weaker, go ballistaire for a good shield w/this
		if("An Ancient Dagger + Ancient Shield")
			beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
			backr = /obj/item/rogueweapon/shield/bronze/paalloy
	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak + Greathood", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Cloak + Greathood")
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/hoodlich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

// Ranged goon w/ a dumb bow. Ranger, what else is there to say.
/datum/advclass/greater_skeleton/event/ballistiares
	name = "Ballistiares"
	tutorial = "Your frame has wept off your skin. Your fingers are mere peaks. Yet your aim remains true. Assail those who defy your master's command with bolt-and-arrow from afar - weather them down to the soil."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/event/ballistiares

	category_tags = list(CTAG_ESKELETON)

/datum/outfit/job/roguetown/greater_skeleton/event/ballistiares/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 10
	H.STASPD = 10
	H.STACON = 7
	H.STAWIL = 14
	H.STAINT = 6
	H.STAPER = 15

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/bows , 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/slings, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

	//Utility skills, unlyve to serve
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/kettle/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather/black

	backl = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(
		/obj/item/natural/cloth = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy = 1 //Hilarious
	)
	H.adjust_blindness(-3)
	var/weapons = list("Bow & 20 Arrows", "Bow & 20 Broadheads", "Longbow & 20 Arrows", "Longbow & 20 Broadheads", "Crossbow & 16 Bolts", "Sling + Ancient Shield")
	var/weapon_choice = input(H, "Choose your MISSILE.", "CONDEMN THE LYVING FROM AFAR.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Bow & 20 Arrows")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			beltl = /obj/item/quiver/paalloy
			H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		if("Bow & 20 Broadheads")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			beltl = /obj/item/quiver/broadhead_aalloy
			H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		if("Longbow & 20 Arrows")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
			beltl = /obj/item/quiver/paalloy
			H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		if("Longbow & 20 Broadheads")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
			beltl = /obj/item/quiver/broadhead_aalloy
			H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		if("Crossbow & 16 Bolts")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/aalloy
			beltl = /obj/item/quiver/bolt/paalloy
			H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
		if("Sling + Ancient Shield")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			beltl = /obj/item/quiver/sling/paalloy
			H.adjust_skillrank(/datum/skill/combat/slings, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE) //Not enough to do shield specials w/knifepick or stabs, go legionnaire for that.
			backr = /obj/item/rogueweapon/shield/bronze/paalloy // the midground for less damage output w/more defensive value vs ranged in turn. Yes you can use the sling with it.
	var/tabards = list("Black Cloak + Greathood", "Black Jupon", "Black Tabard", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Cloak + Greathood")
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/hoodlich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

// Heavy/Tanky goon. Heavy armor but without an armaments rite, their skill is locked at journeyman. Death knights perform better than them and thus lich is encouraged to arm those first.
// This one specialises in 3 different playstyles (disiplines) which your statline changes around the weapon choice, all choices are intended to have a noticable flaw as these are disposable goons.
/datum/advclass/greater_skeleton/event/bulwark
	name = "Death Bulwark"
	tutorial = "All throughout, you've borne the brunt. And even in death, will you continue. Shrug off terrible blows and deliver crushing sweeps with your greatweapons, in order to see your master's will done."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/event/bulwark

	category_tags = list(CTAG_ESKELETON)

/datum/outfit/job/roguetown/greater_skeleton/event/bulwark/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 11
	H.STASPD = 6
	H.STACON = 11
	H.STAWIL = 10
	H.STAINT = 1
	H.STAPER = 10

	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	//Utility skills, unlyve to serve
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy //Intended as non-plate, stands out from knights this way.
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/paalloy
	neck = /obj/item/clothing/neck/roguetown/gorget/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy
	belt = /obj/item/storage/belt/rogue/leather/black

	backl = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(
		/obj/item/natural/feather = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy = 1 //Hilarious
	)

	H.adjust_blindness(-3)
	var/weapons = list("Greatweapon - Greatsword, -2 CON / +2 STR / -1 SPD", "Greatweapon - Grand Mace, -3 CON / +2 STR / -1 SPD", "Pikeman - Spear, +1 STR", "Pikeman - Bardiche, +1 STR", "Shieldbearer - Mace + Shield, +3 WIL / -1 SPD", "Shieldbearer - Warhammer + Shield, +3 WIL / -1 SPD")
	var/weapon_choice = input(H, "Choose your DISCIPLINE.", "DEVASTATE THE LYVING UP CLOSE.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Greatweapon - Greatsword, -2 CON / +2 STR / -1 SPD") //Nasty Special, decent strength, slower, lower con.
			r_hand = /obj/item/rogueweapon/greatsword/paalloy
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE) //Tradeoff is no expert shield skill + -2 CON
			H.change_stat(STATKEY_CON, -2)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_SPD, -1)
		if("Greatweapon - Grand Mace, -3 CON / +2 STR / -1 SPD") //Hurts your stamina, bad. decent strength, slower, lowest con.
			r_hand = /obj/item/rogueweapon/mace/goden/steel/paalloy
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE) //Tradeoff is no expert shield skill + -3 CON
			H.change_stat(STATKEY_CON, -3)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_SPD, -1)
		if("Pikeman - Spear, +1 STR") //Pikeman is the inbetween of picks, slightly faster.
			r_hand = /obj/item/rogueweapon/spear/paalloy
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
			H.change_stat(STATKEY_STR, 1)
		if("Pikeman - Bardiche, +1 STR")
			r_hand = /obj/item/rogueweapon/halberd/bardiche/paalloy
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
			H.change_stat(STATKEY_STR, 1)
		if("Shieldbearer - Mace + Shield, +3 WIL / -1 SPD") //Bulwark in the name, these guys are harder than legionarries to tire but they don't do as much damage and are much slower.
			r_hand = /obj/item/rogueweapon/mace/steel/palloy
			l_hand = /obj/item/rogueweapon/shield/tower/metal/palloy
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE) //Upto expert
			H.change_stat(STATKEY_WIL, 3)
			H.change_stat(STATKEY_SPD, -1)
		if("Shieldbearer - Warhammer + Shield, +3 WIL / -1 SPD")
			r_hand = /obj/item/rogueweapon/mace/warhammer/steel/paalloy
			l_hand = /obj/item/rogueweapon/shield/tower/metal/palloy
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE) //Upto expert
			H.change_stat(STATKEY_WIL, 3)
			H.change_stat(STATKEY_SPD, -1)
	var/armors = list("Sayovard + Cuirass & Hauberk", "Bascinet + Heavy Hauberk")
	var/armor_choice = input(H, "Choose your PLATE.", "SHRUG OFF THINE BLOWS.") as anything in armors
	switch(armor_choice)
		if("Sayovard + Cuirass & Hauberk")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/paalloy
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy
			wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/paalloy
		if("Bascinet + Heavy Hauberk")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/paalloy
			wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy/chain
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy
	var/tabards = list("Black Tabard", "Black Jupon", "Black Cloak + Greathood", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Cloak + Greathood")
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/hoodlich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

// Fragile Non-Combat crafter/demolishing artificer goon with a seige-use cavet. Worse weapons + very little armor but does base-building. Fortnite.
// Has a unique extra varient calcic outburst choice that destroys walls and does a huge amount of damage on exploding but takes 8 seconds to prime, on top of their regular varient.
/datum/advclass/greater_skeleton/event/sapper
	name = "'Broken Bone' Sapper"
	tutorial = "Simple. Obedient. Like an ant in a colony. Toil, fortify, smelt, labor and destroy to the tune of your master's whims. After all; what good is an army if it hasn't a sword-nor-shield to wield?"
	outfit = /datum/outfit/job/roguetown/greater_skeleton/event/sapper

	category_tags = list(CTAG_ESKELETON)

/datum/outfit/job/roguetown/greater_skeleton/event/sapper/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 10
	H.STASPD = 10
	H.STACON = 5 //Low con so you can kill them quickly since they're literally wall-leveling bombs.
	H.STAWIL = 10
	H.STAINT = 6
	H.STAPER = 9

	//No medium armor because avantyne half-plate exists and we don't want legionarrie ++
	ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_TRAINED_SMITH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)

	H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4))
	//For summoning rocks or whatever, or utility like mending/mindlink

	// Sapper-exclusive self-exploding spell
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/sapperbomb)

	H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

	//Utility skills, unlyve to serve (more than everyone else)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE) //Just give them a little extra for utility.
	H.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE) //For making traps mostly, since they need it for crafting amythortz, remove if the recipes change.
	H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE) //For the alchemy mortar + pestle for explosives, remove once the recipe changes.
	H.adjust_skillrank(/datum/skill/craft/carpentry, 5, TRUE) //Good for planks, build fast.
	H.adjust_skillrank(/datum/skill/craft/masonry, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/traps, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/blacksmithing, 3, TRUE) //Nessessities to work these better than virtue.
	H.adjust_skillrank(/datum/skill/craft/armorsmithing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/smelting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, 4, TRUE) //Artificer construction specialist, keep higher
	H.adjust_skillrank(/datum/skill/labor/mining, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/lumberjacking, 6, TRUE) //Get up a deathfort, very fast by maximal yields from logs.

	head = /obj/item/clothing/head/roguetown/helmet/kettle/minershelm
	mask = /obj/item/clothing/mask/rogue/spectacles/golden //Structure inspection
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer/lich
	pants = /obj/item/clothing/under/roguetown/trou/artipants/lich
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/lich
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith/lich
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	belt = /obj/item/storage/belt/rogue/leather //regular looks nicer

	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/rogueweapon/hammer/paalloy = 1,
		/obj/item/rogueweapon/tongs/paalloy = 1,
		/obj/item/rogueweapon/hammer/wood = 1,
		/obj/item/storage/belt/rogue/pouch/coins/aalloy = 1, //Hilarious
		/obj/item/rogueweapon/chisel = 1, //avoiding a dupe glitch I have no idea how to fix atm
		/obj/item/rogueweapon/handsaw/bronze = 1,
		/obj/item/dye_brush = 1
	)

	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
	beltl = /obj/item/rogueweapon/pick/paalloy

	H.adjust_blindness(-3)
	var/tabards = list("Black Cloak", "Black Jupon", "Black Tabard", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	H.set_blindness(0)
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Cloak") //No hood because spectacles.
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

/////////////////////////////
// SPECIAL / LIMITED SLOTS //
/////////////////////////////
// Use this section to drop slot-limited subclasses.
// Below is an example. You can adjust how many instances of a subclass can exist on any given round by changing the number that's attached to the 'maximum_possible_slots' variable.

// Limited slot. Exclusive access to the Siegebow and slightly better melee skills, but worse speed.
/datum/advclass/greater_skeleton/event/rareballistiares
	name = "Siege-Ballistiares"
	tutorial = "Few in number, yet known in presence. Fleshless palms cradle the pinnacle of siegebreakage; a massive weapon, capable of sundering all the walls-and-defenses that'd impede your master's path."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/event/rareballistiares
	maximum_possible_slots = 3 //Limited, but powerful.
	category_tags = list(CTAG_ESKELETON)

/datum/outfit/job/roguetown/greater_skeleton/event/rareballistiares/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 12
	H.STASPD = 7
	H.STACON = 7
	H.STAWIL = 16
	H.STAINT = 6
	H.STAPER = 16

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/crossbows, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/slings, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

	//Utility skills, unlyve to serve
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/kettle/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy
	belt = /obj/item/storage/belt/rogue/leather/black

	backl = /obj/item/storage/backpack/rogue/satchel

	l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy/paalloy
	beltl = /obj/item/quiver/bolt/heavy/paalloy

	backpack_contents = list(
		/obj/item/natural/cloth = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy/mid = 1 //Hilarious
	)

	H.adjust_blindness(-3)
	var/weapons = list("Gladius", "Dagger")
	var/weapon_choice = input(H, "Choose your SIDEARM.", "BREAK THE CASTLES WHICH HIDE THE LYVING.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Gladius")
			beltr = /obj/item/rogueweapon/sword/short/gladius/pagladius
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Dagger")
			beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
			H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	var/tabards = list("Black Cloak + Greathood", "Black Jupon", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Cloak + Greathood")
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/hoodlich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

//Stronger sidegrade of the Bulwark. Fully armored juggetnaut with high Intelligence, Strength and Perception for overwhelming, fienting and resisting fients, but extremely low Speed and complete inability to sprint at all. Crack open the armor, overwhelm and they're dead meat.
//They lack the easily ability to escape fights including no climbing skill, they're tough and will tire you very fast. They have good armor off-the-bat. They're sturdy and difficult to tire but archers/mages/swarms of people will hardcounter them in open ground.
/datum/advclass/greater_skeleton/event/bulwarkrare
	name = "Death Knight"
	tutorial = "Swerve, parry, riposte. The wetness along your mortal wound has dried centuries ago, yet your wit remains unsullied in the slightest. Bring your master's chivalry to the battlefield, through both plate-and-blade."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/event/bulwarkrare
	maximum_possible_slots = 2 //Limited, but powerful. Could serve as either champions or commanders for the Lich's army.
	category_tags = list(CTAG_ESKELETON)

/datum/outfit/job/roguetown/greater_skeleton/event/bulwarkrare/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 16 //Zizo's strongest skeleton
	H.STASPD = 5 //Slow as they come, lock in or get overwhelmed. Can't do much to dodgers. No ability to sprint
	H.STACON = 9 //Rugged, but no sprinting vs other skeles so they need some leeway
	H.STAWIL = 12 //Can't retreat, needs this to not die to stamchecks as easily
	H.STAINT = 14
	H.STAPER = 14

	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC) //Unique perk, you can splash out a TON of damage.
	ADD_TRAIT(H, TRAIT_NORUN, TRAIT_GENERIC) //You can't sprint at all, lock in. Mages/Archers will wipe you.

	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
	//Again, their flaw is inability to escape, no climbing here.

	//Utility skills, unlyve to serve
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/paalloy
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich //Felt sovlful
	armor = /obj/item/clothing/suit/roguetown/armor/plate/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy //So you can't just shatter them with a mace + fients super quickly, aim for the head
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	pants = /obj/item/clothing/under/roguetown/platelegs/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/plate/paalloy
	neck = /obj/item/clothing/neck/roguetown/gorget/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/paalloy
	belt = /obj/item/storage/belt/rogue/leather/black

	backl = /obj/item/storage/backpack/rogue/satchel/black

	backpack_contents = list(
		/obj/item/natural/feather = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy/rich = 1 //Hilarious
	)

	H.adjust_blindness(-3)
	var/weapons = list("Flamberge", "Flail + Greatshield")
	var/weapon_choice = input(H, "Choose your GREATWEAPON.", "FELL THE CHAMPIONS OF THE LYVING.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Flamberge")
			r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge/paalloy //Distance and damage as well as crowd control with high strength.
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Flail + Greatshield")
			r_hand = /obj/item/rogueweapon/flail/sflail/paflail
			l_hand = /obj/item/rogueweapon/shield/bronze/great/paalloy //study, range resistance vs range to tradeoff for no reach + sweep.
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
	var/tabards = list("Black Tabard", "Black Jupon", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	if(H.mind) //2 slot, irreplacable skeletons.
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending) //Gets replaced w/weaker version w/ritual armor. it balances out.
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)

	H.energy = H.max_energy

// Spellblade skeleton. Rarest of the bunch - a true Azurcaephan from the ancient era.
// Medium armor, high INT, same chant/spells as regular spellblade. No miracles.
/datum/advclass/greater_skeleton/event/spellblade
	name = "Envigorated Azurcaephan"
	tutorial = "Swerve, parry, cast. Your bones have dried, and your flesh have withered. But your wits, and the flow of the arcyne remains untamed. Fuse gilbranze and sorcery, let the legends of the Azurcaephan be known again. Azurea, reborn in arcyne fyre! No! Tarichea! Tarichea! Tarichea! Long may she live! Long may she reign! Tarichea forevermore! My blade undulled, my chant unbroken, my wits untarnished!"
	outfit = /datum/outfit/job/roguetown/greater_skeleton/event/spellblade
	maximum_possible_slots = 1
	category_tags = list(CTAG_ESKELETON)

/datum/outfit/job/roguetown/greater_skeleton/event/spellblade
	var/subclass_selected

/datum/outfit/job/roguetown/greater_skeleton/event/spellblade/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/greater_skeleton/event/spellblade/pre_equip(mob/living/carbon/human/H)
	..()

	//1:1 almost w/unbound not including statpacks
	H.STASTR = 9
	H.STASPD = 9
	H.STACON = 10
	H.STAWIL = 12
	H.STAINT = 14
	H.STAPER = 12

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE) //A true Azurcaephan, they know their stuff.

	//Utility skills, unlyve to serve
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/paalloy
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich //Stands out
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy
	backr = /obj/item/rogueweapon/shield/bronze/paalloy
	belt = /obj/item/storage/belt/rogue/leather/black

	backl = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(
		/obj/item/natural/feather = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy/rich = 1 //Hilarious
	)


	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "undead")
	H << browse(selection_html, "window=spellblade_chant;size=1100x900")
	onclose(H, "spellblade_chant", src)

	var/open_time = world.time
	while(!subclass_selected && world.time - open_time < 5 MINUTES)
		stoplag(1)
	H << browse(null, "window=spellblade_chant")

	if(!subclass_selected)
		subclass_selected = "blade"

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = subclass_selected

	if(H.mind)
		switch(subclass_selected)
			if("blade")
				H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
				H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
				H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/blade_storm)
			if("phalangite")
				H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
				H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
				H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
			if("macebearer")
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter)
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
				H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)

		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonemend) //So you don't die from damaging yourself by your own gameplay loop.
		H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4))

	H.adjust_blindness(-3)
	switch(subclass_selected)
		if("blade")
			var/weapons = list("Ancient Khopesh", "Ancient Dagger")
			var/weapon_choice = input(H, "Choose your BLADE.", "RAGE AGAINST THE LYVING.") as anything in weapons
			switch(weapon_choice)
				if("Ancient Khopesh")
					beltr = /obj/item/rogueweapon/sword/sabre/palloy
				if("Ancient Dagger")
					beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
			if(weapon_choice == "Ancient Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("phalangite")
			var/weapons = list("Ancient Spear", "Ancient Bardiche")
			var/weapon_choice = input(H, "Choose your SPEAR.", "RAGE AGAINST THE LYVING.") as anything in weapons
			switch(weapon_choice)
				if("Ancient Spear")
					r_hand = /obj/item/rogueweapon/spear/paalloy
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Ancient Bardiche")
					r_hand = /obj/item/rogueweapon/halberd/bardiche/paalloy
					backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("macebearer")
			var/weapons = list("Ancient Mace", "Ancient Warhammer", "Ancient Grand Mace", "Ancient Alloy Axe", "Steel Greataxe")
			var/weapon_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
			var/picked_axe = FALSE
			switch(weapon_choice)
				if("Ancient Mace")
					beltr = /obj/item/rogueweapon/mace/steel/palloy
				if("Ancient Warhammer")
					beltr = /obj/item/rogueweapon/mace/warhammer/steel/paalloy
				if("Ancient Grand Mace")
					r_hand = /obj/item/rogueweapon/mace/goden/steel/paalloy
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Ancient Alloy Axe")
					beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
					picked_axe = TRUE
				if("Steel Greataxe")
					r_hand = /obj/item/rogueweapon/greataxe/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					picked_axe = TRUE
			if(picked_axe)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
	H.set_blindness(0)

	// Hack for ordering
	H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/suicidebomb/lesser)
	H.mind.AddSpell(/obj/effect/proc_holder/spell/self/suicidebomb/lesser)
	// Reorder undead eyes action to the end
	var/obj/item/organ/eyes/existing_eyes = H.getorganslot(ORGAN_SLOT_EYES)
	if(existing_eyes)
		existing_eyes.Remove(H, TRUE)
		existing_eyes.Insert(H)

	var/tabards = list("Black Tabard", "Black Jupon", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

//Cleric skeleton, specialises in ranged casting + lesser magic utility use. They're also able to herald the darkness and snuff out lights.
//They're quite a potent healer but they struggle with light armor and most of their body being covered by /very/ obvious heretical robes.
//Can parry somewhat okay in melee, but they're too weak to really /hurt/ someone badly via that. Generally though you're going to taken out by mages/archers pretty decently, this is intended.

//Most importantly, unlike other lich skeletons, these ones really stand out amongst the many. You know who to target on-sight pretty much.
//Yes the name is a bitter irony because Sectarian means a closed-minded us vs them, mindset. Aka limited or bigoted, but this fits the "slaughter the living so they may walk with her" mindset of skeletons.
/datum/advclass/greater_skeleton/event/sectarian
	name = "Zizite Sectarian"
	tutorial = "'Progress. Ascension. Destiny. A mandate, commanded by God, to be fufilled by Man.' - Amongst the many fallen, few not only take their place not only in reverence but through faith and channeling divinity. No matter how far you've fallen, your faith will be that which shall peirce the heavens - Let Progress be your chariot, let her will be your guide and let your master's vision become reality."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/event/sectarian
	maximum_possible_slots = 3 //don't want too many healers for skeletons in a round but we want leniency for when they die and get replaced

	category_tags = list(CTAG_ESKELETON)

/datum/outfit/job/roguetown/greater_skeleton/event/sectarian/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 8
	H.STASPD = 8
	H.STACON = 7 //Flimsy vs others, not as non-combat as a sapper though
	H.STAWIL = 11
	H.STAINT = 12 //acolyte-esc role, smarter than most skeletons
	H.STAPER = 10

	//No medium armor because avantyne half-plate exists and we do not want heretic ++

	ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC) //"we have rituos at home"
	ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC) //Sovl Bonus from heretic
	ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC) //Flavor, nothing to do w/ zurch, it solely means worse spire if you somehow get an abyssal dream shard (unstable one you throw)

	H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 4))
	//Your "rituos", notably weaker than adv missionary as your tradeoff is being actually undead and untirable. Your minor aspect is a cantrip more than anything.
	//No free ward, never. period. Do not, I will find you. They will spend their singular minor aspect if they want one.


	H.adjust_skillrank(/datum/skill/combat/staves, 4, TRUE) //Intended choice of parrying off blows, won't last amazingly long though
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)

	//You're a true devout, a disiple, here's your "sovl" patron boons (basically you /have/ artifice potental)
	H.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/smelting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, 2, TRUE)

	//Utility skills, unlyve to serve
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/roguehood/lich_sectarian
	mask = /obj/item/clothing/mask/rogue/facemask/steel/paalloy //Face protection
	shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded/lich //Extra obvious herecy + better goes with the fit
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	cloak = /obj/item/clothing/cloak/tabard/toga/lich //Goes with the fit, so you get no choice of picks
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/lich
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted/lich //Second weak spot, hands.
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/paalloy //UP THE Z
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded/dark
	pants = /obj/item/clothing/under/roguetown/trou/leather/mourning

	//Legs are intended to have have weaker armor, this is their weak-spot. Cut them down and smash their ribs in/cut their head off/burn them to death.

	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff/quarterstaff/iron //replace w/ gilbranze once ancient ver added (its literally +3 force w/ steel grade staff vs iron anyway)

	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/aalloy/mid = 1, //Hilarious
		/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy = 4 //SPREAD HER INFLUENCE. ZIZO. ZIZO. ZIZO. (or just wear them all to aurafarm on the Psydonites, IDK)
	)

	H.adjust_blindness(-3)

	//Our offensive kit
	H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/unholy_blast)
	H.mind.AddSpell(new /datum/action/cooldown/spell/raise_deadite) //SPREAD THE... ROT? turn-player-corpses-into-player-zombies spell. No skeleton mitosis please.
	//Our Utility Spells
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
	//No bone chill, Zizo miracle heals all limbs which is strong enough as is + scales to bones. Lesser formations will be making a lot of those.

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_1, start_maxed = TRUE)	//Major acolyte-level regeneration, capped to T1 since Zizo miracles don't work w/ lich's skeleton spam
	//up this if the miracle set is less about summonspam and knockdowns in future, please. They're meant to be a templar level caster vs heretic wretch. So T2 casters. No revival miracles.
	//Starts w/1000 devotion, capped out. Cooldowns still balance this out. On-par w/zeretic spellblade devotion wise + ability (Outside of light snuff).

	H.mind.RemoveSpell(/datum/action/cooldown/spell/miracle/bloodmiracle) //We don't have blood, QOL since we can't use this.

	// Reorder undead eyes action to the end, hacky but makes it easier to focus.
	var/obj/item/organ/eyes/existing_eyes = H.getorganslot(ORGAN_SLOT_EYES)
	if(existing_eyes)
		existing_eyes.Remove(H, TRUE)
		existing_eyes.Insert(H)

	H.energy = H.max_energy
