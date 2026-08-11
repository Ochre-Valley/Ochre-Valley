/obj/item/clothing/neck/roguetown/collar/cow_collar
	name = "cowbell collar"
	desc = "A band of leather with a bell that alerts all around you to your movements."
	icon = 'modular_ochrevalley/icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'modular_ochrevalley/icons/roguetown/clothing/onmob/neck.dmi'
	icon_state = "cowbell_collar"
	leashable = TRUE

/obj/item/clothing/neck/roguetown/collar/cow_collar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS)

