/datum/species/familiar/infernal
	inherent_traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_TINYPAWS,
		TRAIT_INFINITE_STAMINA,
		TRAIT_NOMOOD,
		TRAIT_NOHUNGER,
		TRAIT_NOPAIN,
		TRAIT_TECHNOPHOBE,
		TRAIT_NODISMEMBER, //Decapping Volfs causes them to bug out, badly, and need admin intervention to fix. Bandaid fix.
		TRAIT_CRITICAL_WEAKNESS, // ...this should prevent them from being literally unkillable, though
		TRAIT_PIERCEIMMUNE, //Prevents weapon dusting and caltrop effects due to them transforming when killed/stepping on shards.
		TRAIT_NOMETABOLISM, // partly to avoid potion jank, mostly because fae need to store reagents inside themselves
		TRAIT_NOFIRE,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_SILVER_WEAK,
		TRAIT_NOWW, // no antag familiars pls
		TRAIT_UNLYCKERABLE,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_UNCONVERTIBLE,
		TRAIT_NASTY_EATER,
	)
