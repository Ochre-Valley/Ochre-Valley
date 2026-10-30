/mob/living/carbon/human/species/familiar
	can_do_sex = TRUE //Fixing that for OV.

/datum/species/familiar
	inherent_traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_TINYPAWS,
		TRAIT_INFINITE_STAMINA,
		TRAIT_NOMOOD,
		TRAIT_NOHUNGER,
		TRAIT_NOPAIN,
		TRAIT_NOBREATH,
		TRAIT_TECHNOPHOBE,
		TRAIT_NODISMEMBER, //Decapping Volfs causes them to bug out, badly, and need admin intervention to fix. Bandaid fix.
		TRAIT_CRITICAL_WEAKNESS, // ...this should prevent them from being literally unkillable, though
		TRAIT_PIERCEIMMUNE, //Prevents weapon dusting and caltrop effects due to them transforming when killed/stepping on shards.
		TRAIT_NOMETABOLISM, // partly to avoid potion jank, mostly because fae need to store reagents inside themselves
		TRAIT_NOWW, // no antag familiars pls
		TRAIT_UNLYCKERABLE,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_UNCONVERTIBLE,
		TRAIT_NASTY_EATER,
		)
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		ORGAN_SLOT_BUTT = /obj/item/organ/butt,
		)
