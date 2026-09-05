//Vheslyn cultist faction. A reminder to any admin/GM reading this file that these guys should be rare!
GLOBAL_LIST_INIT(vheslyn_cult_aggro, world.file2list("modular_ochrevalley/strings/rt/vheslyncultlines.txt"))
//Aggro lines written by yecrowbarman/crowbarlamb

//Low power cultists, extremely random and disjointed gear.
/mob/living/carbon/human/species/human/northern/infernal_cultist
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_INFERNAL)
	ambushable = FALSE
	cmode = 1
	setparrytime = 30
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)
	blood_toll_bucket = STATS_KILLED_INFERNALS
	var/infernal_cultist_outfit = /datum/outfit/job/roguetown/human/northern/infernal_cultist

/mob/living/carbon/human/species/human/northern/infernal_cultist/Initialize(mapload)
	. = ..()
	//Begin RANDOMISE here
	set_species(pick(NPC_RACES_TYPES))
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src) //Now we just randomise here, MUST be called after both race + gender
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/infernal_cultist/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.vheslyn_cult_aggro, TRUE)
	job = "Vheslyn Cultist"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_UNFORGIVABLE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DNR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DETACHED, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_PSYCHOSIS, TRAIT_GENERIC)
	equipOutfit(new infernal_cultist_outfit)
	AddComponent(/datum/component/npc_death_line, null, 25)
	dna.species.handle_body(src)
	random_voice_NPC()
	random_hair_NPC()
	random_eye_color_NPC()
	correct_features_NPC()

	if(gender == FEMALE)
		real_name = pick(world.file2list("strings/names/first_female.txt"))
	else
		real_name = pick(world.file2list("strings/names/first_male.txt"))
	update_hair()
	update_body()
	src.regenerate_icons() //Fixes the weird body

/datum/outfit/job/roguetown/human/northern/infernal_cultist/pre_equip(mob/living/carbon/human/H)
	..()
	//Skills
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
	//Stats
	H.STASTR = 12
	H.STASPD = 11
	H.STACON = 6
	H.STAWIL = 8
	H.STAPER = 12
	H.STAINT = 8
	//Head Gear
	if(prob(70))
		switch(rand(1, 4))
			if(1)
				head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
			if(2)
				head = /obj/item/clothing/head/roguetown/helmet/skullcap
				neck = /obj/item/clothing/neck/roguetown/coif
				mask = /obj/item/clothing/head/roguetown/roguehood/black
			if(3)
				head = /obj/item/clothing/head/roguetown/helmet/leather
				neck = /obj/item/clothing/neck/roguetown/leather
			if(4)
				neck = /obj/item/clothing/neck/roguetown/coif/heavypadding/black
				mask = /obj/item/clothing/head/roguetown/roguehood/black
	//Chest Gear
	switch(rand(1,4))
		if(1)
			cloak = /obj/item/clothing/cloak/raincloak/mortus
		if(2)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/black
		if(3)
			cloak = /obj/item/clothing/cloak/half
		if(4)
			cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	if(prob(50))
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	switch(rand(1, 7))
		if(1)
			armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		if(2)
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
		if(3)
			armor = /obj/item/clothing/suit/roguetown/armor/leather
		if(4)
			armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
		if(5)
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
		if(6)
			armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
		if(7)
			armor = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	//Arm Gear
	if(prob(50))
		gloves = /obj/item/clothing/gloves/roguetown/leather/black
	if(prob(75))
		switch(rand(1, 4))
			if(1)
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			if(2)
				wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
			if(3)
				wrists = /obj/item/clothing/wrists/roguetown/bracers/splint
			if(4)
				wrists = /obj/item/clothing/wrists/roguetown/bracers/copper
	//Leg Gear
	switch(rand(1, 6))
		if(1)
			pants = /obj/item/clothing/under/roguetown/splintlegs
		if(2)
			pants = /obj/item/clothing/under/roguetown/trou/leather
		if(3)
			pants = /obj/item/clothing/under/roguetown/trou
		if(4)
			pants = /obj/item/clothing/under/roguetown/tights/black
		if(5)
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun/black
		if(6)
			pants = /obj/item/clothing/under/roguetown/skirt/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	//Weapons
	switch(rand(1, 7))
		if(1)
			l_hand = /obj/item/rogueweapon/spear/short
			r_hand = /obj/item/rogueweapon/shield/iron
		if(2)
			r_hand = /obj/item/rogueweapon/sword/falchion/militia
			if(prob(30))
				l_hand = /obj/item/rogueweapon/shield/wood
		if(3)
			r_hand = /obj/item/rogueweapon/sword/short/iron
			if(prob(50))
				l_hand = /obj/item/rogueweapon/shield/wood
		if(4)
			r_hand = /obj/item/rogueweapon/flail/militia
			if(prob(75))
				l_hand = /obj/item/rogueweapon/shield/iron
		if(5)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
		if(6)
			r_hand = /obj/item/rogueweapon/sword/long/iron
		if(7)
			r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron

//Proper fighting cultists with much more organized gear and better stats.
/mob/living/carbon/human/species/human/northern/infernal_cultist/soldier
	infernal_cultist_outfit = /datum/outfit/job/roguetown/human/northern/infernal_cult_soldier

/mob/living/carbon/human/species/human/northern/infernal_cultist/soldier/after_creation()
	..()
	job = "Vheslyn Cult Warrior"
	ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)

/datum/outfit/job/roguetown/human/northern/infernal_cult_soldier/pre_equip(mob/living/carbon/human/H)
	..()
	//Skills
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
	//Stats
	H.STASTR = 14
	H.STASPD = 12
	H.STACON = 8
	H.STAWIL = 12
	H.STAPER = 12
	H.STAINT = 12
	//Head Gear
	switch(rand(1, 5))
		if(1)
			head = /obj/item/clothing/head/roguetown/helmet/heavy/beakhelm
			neck = /obj/item/clothing/neck/roguetown/coif/heavypadding/black
			mask = /obj/item/clothing/head/roguetown/roguehood/black
		if(2)
			head = /obj/item/clothing/head/roguetown/helmet/kettle
			neck = /obj/item/clothing/neck/roguetown/coif/heavypadding/black
		if(3)
			head = /obj/item/clothing/head/roguetown/helmet/sallet
			neck = /obj/item/clothing/neck/roguetown/gorget/aventail
		if(4)
			head = /obj/item/clothing/head/roguetown/helmet/skullcap/steel
			neck = /obj/item/clothing/neck/roguetown/gorget/steel
			mask = /obj/item/clothing/head/roguetown/roguehood/black
		if(5)
			head = /obj/item/clothing/head/roguetown/helmet/kettle
			neck = /obj/item/clothing/neck/roguetown/gorget/steel
	//Body Gear
	switch(rand(1, 4))
		if(1) //Brigandine
			armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
			wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
			pants = /obj/item/clothing/under/roguetown/brigandinelegs
		if(2) //Chainmail
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
			pants = /obj/item/clothing/under/roguetown/chainlegs
		if(3) //Cuirass
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
			wrists = /obj/item/clothing/wrists/roguetown/bracers
			pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
		if(4) //Scale
			armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
			wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/black
	gloves = /obj/item/clothing/gloves/roguetown/chain
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	switch(rand(1,4))
		if(1)
			cloak = /obj/item/clothing/cloak/raincloak/mortus
		if(2)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/black
		if(3)
			cloak = /obj/item/clothing/cloak/half
		if(4)
			cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
	//Weapons
	switch(rand(1, 9))
		if(1)
			r_hand = /obj/item/rogueweapon/mace/warhammer/steel
			l_hand = /obj/item/rogueweapon/shield/iron
		if(2)
			r_hand = /obj/item/rogueweapon/greataxe/steel
		if(3)
			r_hand = /obj/item/rogueweapon/greatsword/zwei
		if(4)
			r_hand = /obj/item/rogueweapon/pick/militia/steel
			l_hand = /obj/item/rogueweapon/shield/iron
		if(5)
			r_hand = /obj/item/rogueweapon/halberd/bardiche
		if(6)
			r_hand = /obj/item/rogueweapon/spear/billhook
		if(7)
			r_hand = /obj/item/rogueweapon/sword/falx
			l_hand = /obj/item/rogueweapon/shield/iron
		if(8)
			r_hand = /obj/item/rogueweapon/sword/sabre
			l_hand = /obj/item/rogueweapon/shield/iron
		if(9)
			r_hand = /obj/item/rogueweapon/sword/long/broadsword/steel

//Full-plate cultists with master skills and high stats.
/mob/living/carbon/human/species/human/northern/infernal_cultist/knight
	setparrytime = 12
	infernal_cultist_outfit = /datum/outfit/job/roguetown/human/northern/infernal_cult_knight

/mob/living/carbon/human/species/human/northern/infernal_cultist/knight/after_creation()
	..()
	job = "Vheslyn Cult Armored Warrior"
	ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)

/datum/outfit/job/roguetown/human/northern/infernal_cult_knight/pre_equip(mob/living/carbon/human/H)
	..()
	//Skills
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_MASTER, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_MASTER, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_MASTER, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
	//Stats
	H.STASTR = 16
	H.STASPD = 12
	H.STACON = 11
	H.STAWIL = 14
	H.STAPER = 14
	H.STAINT = 14
	//Head Gear
	switch(rand(1, 5))
		if(1)
			head = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great
			neck = /obj/item/clothing/neck/roguetown/chaincoif/full
			if(prob(50))
				mask = /obj/item/clothing/head/roguetown/roguehood/black
		if(2)
			head = /obj/item/clothing/head/roguetown/helmet/heavy/aventail
			neck = /obj/item/clothing/neck/roguetown/coif/heavypadding/black
			if(prob(50))
				mask = /obj/item/clothing/head/roguetown/roguehood/black
		if(3)
			head = /obj/item/clothing/head/roguetown/helmet/heavy/guard
			neck = /obj/item/clothing/neck/roguetown/gorget/aventail
			if(prob(50))
				mask = /obj/item/clothing/head/roguetown/roguehood/black
		if(4)
			head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
			neck = /obj/item/clothing/neck/roguetown/bevor
			if(prob(50))
				mask = /obj/item/clothing/head/roguetown/roguehood/black
		if(5)
			head = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff
			neck = /obj/item/clothing/neck/roguetown/gorget/steel
			if(prob(50))
				mask = /obj/item/clothing/head/roguetown/roguehood/black
	//Body Gear
	switch(rand(1, 4))
		if(1) //Full Plate
			armor = /obj/item/clothing/suit/roguetown/armor/plate/full
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
			wrists = /obj/item/clothing/wrists/roguetown/bracers
			pants = /obj/item/clothing/under/roguetown/platelegs
		if(2) //Half-Plate
			armor = /obj/item/clothing/suit/roguetown/armor/plate
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
			wrists = /obj/item/clothing/wrists/roguetown/bracers
			pants = /obj/item/clothing/under/roguetown/chainlegs/hose
		if(3) //Coat of Plates
			armor = /obj/item/clothing/suit/roguetown/armor/brigandine/heavy
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
			wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
			pants = /obj/item/clothing/under/roguetown/brigandinelegs
		if(4) //Plate and Maille
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
			wrists = /obj/item/clothing/wrists/roguetown/bracers
			pants = /obj/item/clothing/under/roguetown/chainlegs/hose
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/black
	gloves = /obj/item/clothing/gloves/roguetown/plate
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	switch(rand(1,4))
		if(1)
			cloak = /obj/item/clothing/cloak/raincloak/mortus
		if(2)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/black
		if(3)
			cloak = /obj/item/clothing/cloak/half
		if(4)
			cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
	//Weapons
	switch(rand(1, 9))
		if(1)
			r_hand = /obj/item/rogueweapon/mace/warhammer/steel
			l_hand = /obj/item/rogueweapon/shield/tower/metal
		if(2)
			r_hand = /obj/item/rogueweapon/greataxe/steel
		if(3)
			r_hand = /obj/item/rogueweapon/greatsword/zwei
		if(4)
			r_hand = /obj/item/rogueweapon/mace/cudgel/flanged
			l_hand = /obj/item/rogueweapon/shield/tower/metal
		if(5)
			r_hand = /obj/item/rogueweapon/estoc
		if(6)
			r_hand = /obj/item/rogueweapon/spear/billhook
		if(7)
			r_hand = /obj/item/rogueweapon/sword/falx
			l_hand = /obj/item/rogueweapon/shield/tower/metal
		if(8)
			r_hand = /obj/item/rogueweapon/sword/sabre
			l_hand = /obj/item/rogueweapon/shield/tower/metal
		if(9)
			r_hand = /obj/item/rogueweapon/sword/long/ap

//Cultist archers, pretty random armor quality, but otherwise very normal archers
/mob/living/carbon/human/species/human/northern/infernal_cultist/archer
	ai_controller = /datum/ai_controller/human_npc/archer
	infernal_cultist_outfit = /datum/outfit/job/roguetown/human/northern/infernal_cult_archer

/mob/living/carbon/human/species/human/northern/infernal_cultist/archer/after_creation()
	..()
	job = "Vheslyn Cult Archer"

/datum/outfit/job/roguetown/human/northern/infernal_cult_archer/pre_equip(mob/living/carbon/human/H)
	..()
	//Skills
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
	//Stats
	H.STASTR = 10
	H.STASPD = 11
	H.STACON = 6
	H.STAWIL = 10
	H.STAPER = 13
	H.STAINT = 11
	//Gear set
	switch(rand(1, 5))
		if(1) //Practically nothing
			head = /obj/item/clothing/head/roguetown/helmet/kettle
			neck = /obj/item/clothing/neck/roguetown/gorget/aventail
			armor = /obj/item/clothing/suit/roguetown/shirt/tunic/black
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
			pants = /obj/item/clothing/under/roguetown/tights/black
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		if(2) //Gambeson
			head = /obj/item/clothing/head/roguetown/roguehood/black
			neck = /obj/item/clothing/neck/roguetown/coif/heavypadding/black
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
			pants = /obj/item/clothing/under/roguetown/tights/black
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		if(3) //Full leather
			mask = /obj/item/clothing/head/roguetown/roguehood/black
			head = /obj/item/clothing/head/roguetown/helmet/skullcap/steel
			neck = /obj/item/clothing/neck/roguetown/gorget/aventail
			armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		if(4) //Brigandine
			head = /obj/item/clothing/head/roguetown/helmet/kettle
			neck = /obj/item/clothing/neck/roguetown/gorget/aventail
			armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
			wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
			pants = /obj/item/clothing/under/roguetown/brigandinelegs
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		if(5) // Chainmail
			head = /obj/item/clothing/head/roguetown/helmet/sallet
			neck = /obj/item/clothing/neck/roguetown/gorget/steel
			armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
			wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
			pants = /obj/item/clothing/under/roguetown/brigandinelegs
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/black
	switch(rand(1,4))
		if(1)
			cloak = /obj/item/clothing/cloak/raincloak/mortus
		if(2)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/black
		if(3)
			cloak = /obj/item/clothing/cloak/half
		if(4)
			cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
	//Weapons
	r_hand = /obj/item/rogueweapon/sword
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/quiver/randomfill/reaver

//Dodge expert cultists with dual wield, and fairly middling protection
/mob/living/carbon/human/species/human/northern/infernal_cultist/rogue
	dodgetime = 12
	d_intent = INTENT_DODGE
	infernal_cultist_outfit = /datum/outfit/job/roguetown/human/northern/infernal_cult_rogue

/mob/living/carbon/human/species/human/northern/infernal_cultist/rogue/after_creation()
	..()
	job = "Vheslyn Cult Skirmisher"
	ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUALWIELDER, TRAIT_GENERIC)

/datum/outfit/job/roguetown/human/northern/infernal_cult_rogue/pre_equip(mob/living/carbon/human/H)
	..()
	//Skills
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
	//Stats
	H.STASTR = 14
	H.STASPD = 14
	H.STACON = 9
	H.STAWIL = 12
	H.STAPER = 12
	H.STAINT = 13
	head = /obj/item/clothing/neck/roguetown/coif/heavypadding/black
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	mask = /obj/item/clothing/head/roguetown/roguehood/black
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/dark
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/black
	pants = /obj/item/clothing/under/roguetown/brigandinelegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	switch(rand(1,4))
		if(1)
			cloak = /obj/item/clothing/cloak/raincloak/mortus
		if(2)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/black
		if(3)
			cloak = /obj/item/clothing/cloak/half
		if(4)
			cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
	//Weapons
	switch(rand(1, 4))
		if(1)
			r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/kris
			l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/kris
		if(2)
			r_hand = /obj/item/rogueweapon/sword/falx
			l_hand = /obj/item/rogueweapon/sword/falx
		if(3)
			r_hand = /obj/item/rogueweapon/sword/sabre
			l_hand = /obj/item/rogueweapon/sword/sabre
		if(4)
			r_hand = /obj/item/rogueweapon/mace/warhammer/steel
			l_hand = /obj/item/rogueweapon/mace/warhammer/steel

//Bullshit powerful legendary skill cultists with blacksteel armor.
//Keep in mind they don't have nodrop and thus are blacksteel loot pinatas for people who can kill them.
/mob/living/carbon/human/species/human/northern/infernal_cultist/legendary
	setparrytime = 9
	infernal_cultist_outfit = /datum/outfit/job/roguetown/human/northern/infernal_cult_legendary

/mob/living/carbon/human/species/human/northern/infernal_cultist/legendary/after_creation()
	..()
	job = "Vheslyn Cult Champion"
	ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BLOOD_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HARDDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	for(var/obj/item/gear in get_equipped_items() + held_items)
		lock_gear_piece(gear, "legendary_cultist_gear")

/mob/living/carbon/human/species/human/northern/infernal_cultist/legendary/death(gibbed, nocutscene = FALSE)
	. = ..()
	for(var/obj/item/gear in get_equipped_items() + held_items)
		REMOVE_TRAIT(gear, TRAIT_NODROP, "legendary_cultist_gear")
//They will drop their helmet, gloves, boots, and held items when they detonate providing 4-5 blacksteel on death.

/datum/outfit/job/roguetown/human/northern/infernal_cult_legendary/pre_equip(mob/living/carbon/human/H)
	..()
	//Skills
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_LEGENDARY, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_LEGENDARY, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_LEGENDARY, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_LEGENDARY, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_LEGENDARY, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_LEGENDARY, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_LEGENDARY, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_LEGENDARY, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
	//Stats
	H.STASTR = 20
	H.STASPD = 20
	H.STACON = 20
	H.STAWIL = 20
	H.STAPER = 20
	H.STAINT = 20
	head = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern
	neck = /obj/item/clothing/neck/roguetown/bevor/blacksteel/modern
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/modern
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/blacksteel/modern
	gloves = /obj/item/clothing/gloves/roguetown/plate/blacksteel/modern
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/black
	pants = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/modern
	cloak = /obj/item/clothing/cloak/half
	//Weapons
	switch(rand(1, 6))
		if(1)
			r_hand = /obj/item/rogueweapon/flail/blacksteel
			l_hand = /obj/item/rogueweapon/shield/tower/metal/blacksteel
		if(2)
			r_hand = /obj/item/rogueweapon/sword/short/messer/blacksteel
			l_hand = /obj/item/rogueweapon/shield/tower/metal/blacksteel
		if(3)
			r_hand = /obj/item/rogueweapon/sword/rapier/blacksteel
			l_hand = /obj/item/rogueweapon/shield/tower/metal/blacksteel
		if(4)
			r_hand = /obj/item/rogueweapon/halberd/blacksteel
		if(5)
			r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel
		if(6)
			r_hand = /obj/item/rogueweapon/eaglebeak/blacksteel
