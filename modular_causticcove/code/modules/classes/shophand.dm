/datum/advclass/guildthug
	name = "Guild Thug"
	tutorial = "You've been hired by the Merchant's Guild to be their brawn. Valued for your strength and little else, you assist the Merchant in hauling heavy goods, or strong arming potential thiefs."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/adventurer/guildthug
	category_tags = list(CTAG_SHOPHAND)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_CON = 3,
		STATKEY_INT = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_NOVICE,
	)


/datum/outfit/job/roguetown/adventurer/guildthug/pre_equip(mob/living/carbon/human/H)
	..()
	var/weapons = list("Knuckles","Cudgel")
	var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Knuckles")
			gloves = /obj/item/clothing/gloves/roguetown/knuckles/bronze
		if("Cudgel")
			beltl = /obj/item/rogueweapon/mace/cudgel
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood
	belt = /obj/item/storage/belt/rogue/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/merchant = 1,
	)
	H.grant_language(/datum/language/thievescant)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)

/datum/advclass/guildinformant
	name = "Guild Informant"
	tutorial = "You started as a basic street urchin sneaking and stealing as you needed. On one fateful day you chose to steal from the Merchant's Guild, and now find yourself indebted to their service. Now, you serve as their eyes and ears on the streets of the city."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/adventurer/guildinformant
	category_tags = list(CTAG_SHOPHAND)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)


/datum/outfit/job/roguetown/adventurer/guildinformant/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/mace/cudgel
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	backpack_contents = list(
				/obj/item/flashlight/flare/torch = 1,
				/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1,
				/obj/item/storage/keyring/merchant = 1,
				)
	H.grant_language(/datum/language/thievescant)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)

/datum/advclass/hiredservant
	name = "Hired Servant"
	tutorial = "You are an expert courtier, though find yourself in the service to an aristocrat rather than nobility. Your ability to cater to your Merchant's needs are unparalleled."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/adventurer/hiredservant
	category_tags = list(CTAG_SHOPHAND)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_INT = 1,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_EXP_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
	)


/datum/outfit/job/roguetown/adventurer/hiredservant/pre_equip(mob/living/carbon/human/H)
	..()
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
				/obj/item/kitchen/rollingpin = 1,
				/obj/item/flint = 1,
				/obj/item/cooking/pan = 1,
				/obj/item/reagent_containers/peppermill = 1,
			)
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/keyring/merchant
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	r_hand = /obj/item/reagent_containers/glass/bucket/pot
	var/loadouts = list("Maid","Butler")
	var/loadout_choice = input("Choose your attire.") as anything in loadouts
	H.set_blindness(0)
	switch(loadout_choice)
		if("Maid")
			head = /obj/item/clothing/head/roguetown/armingcap
			armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/black
			shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
			pants = /obj/item/clothing/under/roguetown/tights/stockings/black
			cloak = /obj/item/clothing/cloak/apron/waist
		if("Butler")
			pants = /obj/item/clothing/under/roguetown/tights/black
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
	ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)

//The original version of the shophand
/datum/advclass/shoplackey
	name = "Shop Lackey"
	tutorial = "You were once a beggar on the street struggling to find your next meal. The Merchant's Guild offered you a roof in exchange for your labor. Now you find yourself as little more than an indentured servant to the Merchant and their whims."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/adventurer/shoplackey
	category_tags = list(CTAG_SHOPHAND)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_INT = 1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		//worse skills than a normal peasant, generally, with random bad combat skill
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/shoplackey/pre_equip(mob/living/carbon/human/H)
	..()
	var/loadouts = list("Shirt","Dress")
	var/loadout_choice = input("Choose your attire.") as anything in loadouts
	H.set_blindness(0)
	switch(loadout_choice)
		if("Dress")
			pants = /obj/item/clothing/under/roguetown/tights
			armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/blue
			shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
			belt = /obj/item/storage/belt/rogue/leather
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
			beltl = /obj/item/storage/keyring/merchant
			backr = /obj/item/storage/backpack/rogue/satchel
		if("Shirt")
			pants = /obj/item/clothing/under/roguetown/tights
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
			belt = /obj/item/storage/belt/rogue/leather
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
			beltl = /obj/item/storage/keyring/merchant
			backr = /obj/item/storage/backpack/rogue/satchel
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)
	if(prob(33))
		H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
	else if(prob(33))
		H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	else //the legendary shopARM
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
		H.change_stat(STATKEY_STR, 1)
