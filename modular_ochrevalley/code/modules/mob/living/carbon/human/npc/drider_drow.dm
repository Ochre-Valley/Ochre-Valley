/obj/item/bodypart/taur/spider/drider_only //STRONGER VARIANT, should only be on drider drow
	name = "Spider Body"
	max_damage = 400 //Double, harder to bisect them
	max_stamina_damage = 150

/mob/living/carbon/human/species/elf/dark/drowraider/drider_drow
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_DROW)
	ambushable = FALSE
	dodgetime = 30
	d_intent = INTENT_DODGE
	blood_toll_bucket = STATS_KILLED_DROWS
	outfit = /datum/outfit/job/roguetown/human/species/elf/dark/drowraider/drider_drow

/mob/living/carbon/human/species/elf/dark/drowraider/drider_drow/ambush
	threat_point = THREAT_ELITE
	ambush_faction = "underdark"

/mob/living/carbon/human/species/elf/dark/drowraider/drider_drow/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	resize(1.3)

/datum/outfit/job/roguetown/human/species/elf/dark/drowraider/drider_drow/pre_equip(mob/living/carbon/human/H)
	var/taur_colour = pick("#0f0463", "#1a1540", "#271633", "#212021", "#361213", "#540305")
	H.Taurize(/obj/item/bodypart/taur/spider/drider_only, taur_colour)

	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/drowraider
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest/drowraider
	shirt = /obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock/drowraider
	gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/facemask/shadowfacemask
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	// Stopgap: archer roll removed because the ranged NPC AI is unreliable.
	if(prob(45)) // whip
		r_hand = /obj/item/rogueweapon/whip/spiderwhip
	else if(prob(50)) // dual falx
		r_hand = /obj/item/rogueweapon/sword/sabre/stalker
		l_hand = /obj/item/rogueweapon/sword/sabre/stalker
	else // dual dirk
		r_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish/drow
		l_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish/drow

	H.STASTR = 13 
	H.STASPD = 14 // 3 points
	H.STACON = 15 //Legs will be exposed, they need this, lmao
	H.STAWIL = 9
	H.STAPER = 10
	H.STAINT = 10
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)


//LEGENDARY VARIANT FOR GM SPAWN ONLY
/mob/living/carbon/human/species/elf/dark/drowraider/drider_drow/monstrous
	outfit = /datum/outfit/job/roguetown/human/species/elf/dark/drowraider/drider_drow/monstrous
	d_intent = INTENT_PARRY

/mob/living/carbon/human/species/elf/dark/drowraider/drider_drow/monstrous/after_creation()
	..()
	resize(1.5)

/datum/outfit/job/roguetown/human/species/elf/dark/drowraider/drider_drow/monstrous/pre_equip(mob/living/carbon/human/H)
	var/taur_colour = pick("#0f0463", "#1a1540", "#271633", "#212021", "#361213", "#540305")
	H.Taurize(/obj/item/bodypart/taur/spider/drider_only, taur_colour)
	
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/drowraider
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate
	shirt = /obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock/drowraider
	gloves = /obj/item/clothing/gloves/roguetown/plate/shadowgauntlets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/facemask/shadowfacemask
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	r_hand = /obj/item/rogueweapon/whip/spiderwhip
	l_hand = /obj/item/rogueweapon/shield/tower/spidershield

	H.STASTR = 15 
	H.STASPD = 13 // 3 points
	H.STACON = 17 //Legs will be exposed, they need this, lmao
	H.STAWIL = 11
	H.STAPER = 10
	H.STAINT = 10
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)
