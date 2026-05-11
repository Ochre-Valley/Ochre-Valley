/datum/advclass/warden/wildsoul
	name = "Domesticated Wildsoul"
	tutorial = "You were once upon a time part of the wild. Now you have taken up the duty to protecting it, whenever because of the safety and curiosity of the settlement that you now serve, longing for a purpose, or merely being part of something greater and a concentrated effort, the safety of the roads for these fragile towners and traders rest in your hands and claws. Keep your cradle safe and free of riff raffs, together with your more civilized allies."
	outfit = /datum/outfit/job/roguetown/warden/wildsoul
	category_tags = list(CTAG_WARDEN)
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_CIVILIZEDBARBARIAN, TRAIT_STRONGBITE, TRAIT_NATURAL_ARMOR) // Woodsman removed so it doesnt get applied twice. Feral removed, since theyre warden.
	subclass_stats = list(
		STATKEY_STR = 3,//7 points weighted, same as MAA. Direbear stats are kicked in the shins cause they get stat buffs in the woods instead of a debuff in the town.
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = -2
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT, // Keeping master since theyre now a professional grabber //OV Edit - Brought in line with Wrestle Changes IM SO SORRY
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE, // Domesticated, they learned their ABCs
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE, // This should let them fry meat on fires.
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE, //OV Add - Warden Update
	)

/datum/outfit/job/roguetown/warden/wildsoul

/datum/outfit/job/roguetown/warden/wildsoul/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets
	beltr = /obj/item/rogueweapon/huntingknife/stoneknife //OV Edit - Warden Sync
	H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/natural_armor/dense(H)
	gloves = /obj/item/clothing/gloves/roguetown/knuckles //OV Edit added steel knuckles
	//OV Add Start
	backpack_contents = list(
		/obj/item/storage/keyring/warden = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/signal_horn = 1
		)
	//OV Add End
	give_feral_eyes(H)
	if(H.mind)
		var/helmets = list(
			"Path of the Antelope" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/antler,
			"Path of the Volf"		= /obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf,
			"Path of the Ram"		= /obj/item/clothing/head/roguetown/helmet/sallet/warden/goat,
			"Path of the Bear"		= /obj/item/clothing/head/roguetown/helmet/sallet/warden/bear,
			"None"
		)
		var/helmchoice = input(H, "Choose your Path.", "HELMET SELECTION") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/hoods = list(
			"Common Shroud" 	= /obj/item/clothing/head/roguetown/roguehood/warden,
			"Antlered Shroud"		= /obj/item/clothing/head/roguetown/roguehood/warden/antler,
			"None"
		)
		var/hoodchoice = input(H, "Choose your Shroud.", "HOOD SELECTION") as anything in hoods
		if(helmchoice != "None")
			mask = hoods[hoodchoice]

	var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff") // cool wrestling moves
	var/technique_choice = input(H,"Choose your TECHNIQUE.", "TOSS THEM.") as anything in techniques
	switch(technique_choice)
		if("Dropkick - Pushback + Extra Damage")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
		if("Chokeslam - Stamina Damage")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
		if("Stunner - Dazed Debuff")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
		if("Headbutt - Vulnerable Debuff")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)


/datum/outfit/job/roguetown/warden/wildsoul/proc/give_feral_eyes(mob/living/carbon/human/man)
	var/obj/item/organ/eyes/eyes = man.getorganslot(ORGAN_SLOT_EYES)
	var/color_one
	var/color_two
	var/heterochromia
	if(eyes)
		color_one = eyes.eye_color
		color_two = eyes.second_color
		heterochromia = eyes.heterochromia
		eyes.Remove(man,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/feral
	if(color_one)
		eyes.eye_color = color_one
	if(color_two)
		eyes.second_color = color_two
	if(heterochromia)
		eyes.heterochromia = heterochromia
	eyes.Insert(man)
	man.dna.organ_dna["eyes"]:organ_type = /obj/item/organ/eyes/night_vision/feral
