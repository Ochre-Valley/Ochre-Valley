/datum/advclass/true_random
	name = "Fate's Fool"
	tutorial = "You are someone, from somewhere, with some skills, probably some equipment and some experiences. The ultimate true random experience, start with completely random and probably useless skills, stats and equipment."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/adventurer/true_random
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	traits_applied = list()
	class_select_category = CLASS_CAT_ROGUE
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
	subclass_stats = list(
	)
	subclass_skills = list(
	)

/datum/outfit/job/roguetown/adventurer/true_random/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Xylix laughs either at or with you, strange person with such unusual skills and tools."))
	to_chat(H, span_warningbig("Do not leave and respawn as this class to get better rolls, live with what you are given. Admins will be informed if you try."))
	log_and_message_admins("[H] has spawned as a Fate's Fool! Be aware of them leaving and rejoining.", H)
	
	var/list/possible_traits = list(
						TRAIT_DODGEEXPERT,
						TRAIT_OUTDOORSMAN,
						TRAIT_EXPERT_HUNTER,
						TRAIT_MEDICINE_EXPERT,
						TRAIT_ALCHEMY_EXPERT,
						TRAIT_SMITHING_EXPERT,
						TRAIT_SEWING_EXPERT,
						TRAIT_SURVIVAL_EXPERT,
						TRAIT_HOMESTEAD_EXPERT,
						TRAIT_SELF_SUSTENANCE,
						TRAIT_ENCHANTING_EXPERT,
						TRAIT_NOBLE,
						TRAIT_HEAVYARMOR,
						TRAIT_MEDIUMARMOR,
						TRAIT_STEELHEARTED,
						TRAIT_EXPLOSIVE_SUPPLY,
						TRAIT_BOMBER_EXPERT,
						TRAIT_EMPATH,
						TRAIT_GOODLOVER,
						TRAIT_BLOOD_RESISTANCE,
						TRAIT_FENCERDEXTERITY,
						TRAIT_INTELLECTUAL,
						TRAIT_NOPAINSTUN,
						TRAIT_WOODWALKER,
						TRAIT_CIVILIZEDBARBARIAN,
						TRAIT_GRAVEROBBER,
						TRAIT_SEEPRICES,
						TRAIT_SELF_SUSTENANCE,
						TRAIT_NASTY_EATER,
						TRAIT_WILD_EATER,
						TRAIT_INSPIRING_MUSICIAN,
						TRAIT_KNEESTINGER_IMMUNITY,
						TRAIT_DARKVISION,
						TRAIT_STRONGBITE,
						TRAIT_IGNOREDAMAGESLOWDOWN,
						TRAIT_NOSTINK,
						TRAIT_AZURENATIVE,
						TRAIT_GOODTRAINER,
	)

	var/trait_1 = pick(possible_traits)
	if(trait_1)
		ADD_TRAIT(H, trait_1, TRAIT_GENERIC)
		possible_traits -= trait_1	
	var/trait_2 = pick(possible_traits)
	if(trait_2)
		ADD_TRAIT(H, trait_2, TRAIT_GENERIC)
		possible_traits -= trait_2	
	var/trait_3 = pick(possible_traits)
	if(trait_3 && prob(80))
		ADD_TRAIT(H, trait_3, TRAIT_GENERIC)
		possible_traits -= trait_3	
	var/trait_4 = pick(possible_traits)
	if(trait_4 && prob(70))
		ADD_TRAIT(H, trait_4, TRAIT_GENERIC)
		possible_traits -= trait_4	
	var/trait_5 = pick(possible_traits)
	if(trait_5 && prob(50))
		ADD_TRAIT(H, trait_5, TRAIT_GENERIC)
		possible_traits -= trait_5	
	
	if(prob(20))
		ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
		H.adjust_skillrank(/datum/skill/magic/arcane, rand(1,6), TRUE)
		if(H.mind)
			H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = rand(0,1), "minor" = rand(0,2), "utilities" = rand(0,10), "ward" = rand(0,1)))

	if(prob(20))
		var/datum/devotion/D = new /datum/devotion/(H, H.patron)
		H.adjust_skillrank(/datum/skill/magic/holy, rand(1,6), TRUE)
		var/devotion_power = (rand(1,10)/10)
		D.grant_miracles(H, cleric_tier = rand(1,4), passive_gain = devotion_power, devotion_limit = rand(250,1000))

	//Weapon Skills
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/knives, rand(1,4), TRUE)
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/swords, rand(1,4), TRUE)
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/polearms, rand(1,4), TRUE)
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/maces, rand(1,4), TRUE)
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/axes, rand(1,4), TRUE)
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, rand(1,4), TRUE)
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/bows, rand(1,4), TRUE)
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, rand(1,4), TRUE)
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/firearms, rand(1,4), TRUE)
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, rand(1,4), TRUE)
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, rand(1,4), TRUE)
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/shields, rand(1,4), TRUE)
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/slings, rand(1,4), TRUE)
	if(prob(20))
		H.adjust_skillrank_up_to(/datum/skill/combat/staves, rand(1,4), TRUE)

	//Crafting
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/crafting, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/smelting, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/masonry, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/traps, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/engineering, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/cooking, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/sewing, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/tanning, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, rand(1,6), TRUE)
	
	//Labour skills
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/labor/farming, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/labor/mining, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/labor/fishing, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/labor/butchering, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/labor/lumberjacking, rand(1,6), TRUE)
	
	//Misc
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/misc/athletics, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/misc/climbing, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/misc/reading, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/misc/swimming, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/misc/stealing, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/misc/riding, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/misc/medicine, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/misc/tracking, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/misc/hunting, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/misc/music, rand(1,6), TRUE)
	if(prob(15))
		H.adjust_skillrank_up_to(/datum/skill/misc/music, rand(1,6), TRUE)

	if(H.mind)
		if(prob(10))
			H.STALUC = rand(1, 20)
		else
			H.STALUC = rand(5, 15)
		if(prob(10))
			H.STASTR = rand(1, 20)
		else
			H.STASTR = rand(5, 15)
		if(prob(10))
			H.STASPD = rand(1, 20)
		else
			H.STASPD = rand(5, 15)
		if(prob(10))
			H.STACON = rand(1, 20)
		else
			H.STACON = rand(5, 15)
		if(prob(10))
			H.STAWIL = rand(1, 20)
		else
			H.STAWIL = rand(5, 15)
		if(prob(10))
			H.STAPER = rand(1, 20)
		else
			H.STAPER = rand(5, 15)
		if(prob(10))
			H.STAINT = rand(1, 20)
		else
			H.STAINT = rand(5, 15)

	//EQUIPMENT TIME OH YEAH!!!!!
	if(prob(80))
		shirt = pick(/obj/item/clothing/suit/roguetown/armor/gambeson,
				/obj/item/clothing/suit/roguetown/shirt/tunic/random,
				/obj/item/clothing/suit/roguetown/shirt/undershirt/black,
				/obj/item/clothing/suit/roguetown/armor/chainmail,
				/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron,
				/obj/item/clothing/suit/roguetown/armor/gambeson/light,
				/obj/item/clothing/suit/roguetown/armor/chainmail/light,
				/obj/item/clothing/suit/roguetown/shirt/undershirt/green,
				/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1,
				/obj/item/clothing/suit/roguetown/armor/corset,
		)
	if(prob(60))
		armor = pick(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron,
				/obj/item/clothing/suit/roguetown/armor/leather,
				/obj/item/clothing/suit/roguetown/armor/leather/cuirass,
				/obj/item/clothing/suit/roguetown/armor/leather/hide,
				/obj/item/clothing/suit/roguetown/armor/leather/bikini,
				/obj/item/clothing/suit/roguetown/armor/plate/iron/banded,
				/obj/item/clothing/suit/roguetown/armor/basiceast,
				/obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe,
				/obj/item/clothing/suit/roguetown/shirt/robe/mage,
				/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat,
				/obj/item/clothing/suit/roguetown/shirt/robe/monk,
				/obj/item/clothing/suit/roguetown/shirt/dress/silkdress,
				/obj/item/clothing/suit/roguetown/armor/armordress,
		)
	if(prob(80))
		pants = pick(/obj/item/clothing/under/roguetown/tights/black,
				/obj/item/clothing/under/roguetown/chainlegs/iron,
				/obj/item/clothing/under/roguetown/chainlegs/iron/kilt,
				/obj/item/clothing/under/roguetown/splintlegs,
				/obj/item/clothing/under/roguetown/trou/leather,
				/obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt,
				/obj/item/clothing/under/roguetown/loincloth/deprived,
				/obj/item/clothing/under/roguetown/heavy_leather_pants,
				/obj/item/clothing/under/roguetown/skirt/red,
		)
	belt = pick(/obj/item/storage/belt/rogue/leather,
			/obj/item/storage/belt/rogue/leather/rope,
			/obj/item/storage/belt/rogue/leather/sash,
			/obj/item/storage/belt/rogue/leather/plaquesilver,
			/obj/item/storage/belt/rogue/leather/black,
			/obj/item/storage/belt/rogue/leather/cloth/lady,
	)
	beltl = pick(/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/storage/belt/rogue/pouch/coins/rich,
			/obj/item/storage/belt/rogue/pouch/coins/mid,
	)
	beltr = pick(/obj/item/rogueweapon/sword/short,
			/obj/item/rogueweapon/sword,
			/obj/item/rogueweapon/mace/steel,
			/obj/item/rogueweapon/flail/sflail,
			/obj/item/rogueweapon/mace/warhammer,
			/obj/item/rogueweapon/sword/short/iron/banded,
			/obj/item/rogueweapon/huntingknife/idagger/steel,
			/obj/item/rogueweapon/huntingknife,
			/obj/item/rogueweapon/sword/long,
			/obj/item/rogueweapon/sword/long/broadsword,
			/obj/item/rogueweapon/whip,
			/obj/item/rogueweapon/sword/short/messer/iron,
			/obj/item/rogueweapon/sword/sabre,
			/obj/item/rogueweapon/mace/cudgel,
			/obj/item/rogueweapon/stoneaxe/woodcut,
	)
	if(prob(40))
		cloak = pick(/obj/item/clothing/cloak/raincloak/furcloak,
				/obj/item/clothing/cloak/half,
				/obj/item/clothing/cloak/apron,
				/obj/item/clothing/cloak/bandolier,
				/obj/item/clothing/cloak/poncho,
				/obj/item/clothing/cloak/tabard,
				/obj/item/clothing/cloak/cape,
		)
	if(prob(90))
		shoes = pick(/obj/item/clothing/shoes/roguetown/boots,
				/obj/item/clothing/shoes/roguetown/boots/leather/reinforced,
				/obj/item/clothing/shoes/roguetown/boots/furlinedboots,
				/obj/item/clothing/shoes/roguetown/boots/armor/iron,
				/obj/item/clothing/shoes/roguetown/boots/armor,
				/obj/item/clothing/shoes/roguetown/sandals,
		)
	if(prob(50))
		wrists = pick(/obj/item/clothing/wrists/roguetown/bracers/iron,
				/obj/item/clothing/wrists/roguetown/bracers/splint,
				/obj/item/clothing/wrists/roguetown/bracers/leather,
				/obj/item/clothing/neck/roguetown/psicross/silver,
				/obj/item/clothing/neck/roguetown/psicross/naledi,
				/obj/item/clothing/wrists/roguetown/bracers/cloth/monk,
		)
	if(prob(50))
		gloves = pick(/obj/item/clothing/gloves/roguetown/angle,
				/obj/item/clothing/gloves/roguetown/chain/iron,
				/obj/item/clothing/gloves/roguetown/fingerless_leather,
				/obj/item/clothing/gloves/roguetown/leather,
				/obj/item/clothing/gloves/roguetown/bandages,
				/obj/item/clothing/gloves/roguetown/bandages/weighted,
				/obj/item/clothing/gloves/roguetown/knuckles/bronze,
		)
	if(prob(40))
		neck = pick(/obj/item/clothing/neck/roguetown/gorget,
				/obj/item/clothing/neck/roguetown/chaincoif/iron,
				/obj/item/clothing/neck/roguetown/coif/heavypadding,
				/obj/item/clothing/neck/roguetown/coif/padded,
				/obj/item/clothing/neck/roguetown/bevor/iron,
				/obj/item/clothing/neck/roguetown/psicross/silver,
				/obj/item/storage/belt/rogue/pouch/coins/poor,
		)
	backl = /obj/item/storage/backpack/rogue/satchel
	var/backpack_items = list(
		/obj/item/book/spellbook,
		/obj/item/flashlight/flare/torch/metal,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/rogueweapon/huntingknife,
		/obj/item/chalk,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/lockpickring/mundane,
		/obj/item/repair_kit/metal/bad,
		/obj/item/flint,
		/obj/item/lockpick,
		/obj/item/bomb,
		/obj/item/reagent_containers/glass/bottle/rogue/manapot,
		/obj/item/reagent_containers/glass/bottle/rogue/beer,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		/obj/item/rope/chain,
		/obj/item/rogueweapon/huntingknife/scissors,
		/obj/item/clothing/mask/cigarette/rollie/cannabis,
		/obj/item/capture_crystal,
	)
	backpack_contents = list(pick(backpack_items),pick(backpack_items),pick(backpack_items))
	if(prob(50))
		backr = pick(/obj/item/rogueweapon/shield/iron,
				/obj/item/rogueweapon/shield/wood,
				/obj/item/rogueweapon/sword/long,
				/obj/item/rogueweapon/sword/long/broadsword/steel,
				/obj/item/rogueweapon/scabbard/gwstrap,
				/obj/item/rogueweapon/sword/long/exe,
				/obj/item/rogueweapon/woodstaff,
				/obj/item/rogueweapon/shield/tower/metal,
				/obj/item/rogue/instrument/lute,
				/obj/item/rogueweapon/shield/bronze,
				/obj/item/rogueweapon/shovel,
				/obj/item/twstrap/bombstrap/firebomb,
				/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve,
				/obj/item/quiver/arrows,
				/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow,
				/obj/item/storage/backpack/rogue/satchel,
		)
	r_hand = pick(/obj/item/rogueweapon/greatsword/iron,
			/obj/item/rogueweapon/sword/short,
			/obj/item/rogueweapon/spear/billhook,
			/obj/item/rogueweapon/flail/peasantwarflail/iron,
			/obj/item/rogueweapon/huntingknife/idagger/steel/parrying,
			/obj/item/rogueweapon/sword/rapier,
			/obj/item/rogueweapon/sword/sabre,
			/obj/item/rogueweapon/huntingknife/idagger/steel,
			/obj/item/rogueweapon/katar/bronze,
			/obj/item/rogueweapon/whip/bronze,
			/obj/item/rogueweapon/eaglebeak/lucerne,
			/obj/item/rogueweapon/greataxe,
			/obj/item/rogueweapon/mace/steel/silver,
			/obj/item/rogueweapon/mace/woodclub/deprived,
			/obj/item/rogueweapon/stoneaxe/battle,
			/obj/item/rogueweapon/scabbard/sword/noble,
			/obj/item/rogueweapon/woodstaff/quarterstaff/iron,
	)
	if(prob(40))
		r_hand = pick(/obj/item/rogueweapon/greatsword/iron,
				/obj/item/rogueweapon/sword/short,
				/obj/item/rogueweapon/spear/billhook,
				/obj/item/rogueweapon/flail/peasantwarflail/iron,
				/obj/item/rogueweapon/huntingknife/idagger/steel/parrying,
				/obj/item/rogueweapon/sword/rapier,
				/obj/item/rogueweapon/sword/sabre,
				/obj/item/rogueweapon/huntingknife/idagger/steel,
				/obj/item/rogueweapon/katar/bronze,
				/obj/item/rogueweapon/whip/bronze,
				/obj/item/rogueweapon/eaglebeak/lucerne,
				/obj/item/rogueweapon/greataxe,
				/obj/item/rogueweapon/mace/steel/silver,
				/obj/item/rogueweapon/mace/woodclub/deprived,
				/obj/item/rogueweapon/stoneaxe/battle,
				/obj/item/rogueweapon/scabbard/sword/noble,
				/obj/item/rogueweapon/woodstaff/quarterstaff/iron,
				/obj/item/rogueweapon/shield/iron,
				/obj/item/rogueweapon/shield/wood,
				/obj/item/rogueweapon/shield/tower/metal,
				/obj/item/bomb,
				/obj/item/bouquet,
				/obj/item/cooking/pan,
		)
	if(prob(20))
		mask = pick(/obj/item/clothing/head/roguetown/roguehood/black,
			/obj/item/clothing/mask/rogue/duelmask,
			/obj/item/clothing/mask/rogue/facemask/steel,
			/obj/item/clothing/mask/rogue/eyepatch,
			/obj/item/clothing/mask/rogue/wildguard,
			/obj/item/clothing/head/roguetown/armingcap/padded,
			/obj/item/clothing/mask/rogue/spectacles,
		)
	if(prob(35))
		head = pick(/obj/item/clothing/head/roguetown/witchhat,
			/obj/item/clothing/head/roguetown/archercap,
			/obj/item/clothing/head/roguetown/headband/monk,
			/obj/item/clothing/head/roguetown/bardhat,
			/obj/item/clothing/head/roguetown/roguehood/shalal/purple,
			/obj/item/clothing/head/roguetown/helmet/bronzegladiator,
			/obj/item/clothing/head/roguetown/mentorhat,
			/obj/item/clothing/head/roguetown/helmet/leather/volfhelm,
			/obj/item/clothing/head/roguetown/fedora,
			/obj/item/clothing/head/roguetown/helmet/tricorn,
			/obj/item/clothing/head/roguetown/roguehood/shalal/hijab,
			/obj/item/clothing/head/roguetown/helmet/sallet/visored,
			/obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader,
			/obj/item/clothing/head/roguetown/helmet/heavy/barbute/great,
			/obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			/obj/item/clothing/head/roguetown/helmet/kettle/iron,
		)
	if(prob(5))
		mouth = pick(/obj/item/rogueweapon/huntingknife,
			/obj/item/clothing/mask/cigarette/pipe/westman,
			/obj/item/alch/rosa,
			/obj/item/rogueweapon/stoneaxe/hurlbat,
			/obj/item/needle,
			/obj/item/clothing/mask/cigarette/rollie,
		)
