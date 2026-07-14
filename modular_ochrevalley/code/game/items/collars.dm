//File for armored collars, should be identical in stats and cost to proper gorgets.


//Hardened leather, inherits from hardened leather gorget
/obj/item/clothing/neck/roguetown/leather/collar
	name = "hardened leather collar"
	desc = "Sturdy and affordable. Will protect your neck from some good lumbering."
	icon_state = "collar"
	item_state = "collar"
	leashable = TRUE
	dropshrink = 0.5

/obj/item/clothing/neck/roguetown/leather/collar/bell
	name = "hardened leather bell collar"
	desc = "Sturdy and affordable. Will protect your neck from some good lumbering. Comes with a bell."
	icon_state = "bell_collar"

/obj/item/clothing/neck/roguetown/leather/collar/bell/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS)

/obj/item/clothing/neck/roguetown/leather/collar/bell/cow
	name = "hardened leather cowbell collar"
	desc = "A tough band of leather with a simple cowbell affixed."
	icon = 'modular_ochrevalley/icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'modular_ochrevalley/icons/roguetown/clothing/onmob/neck.dmi'
	icon_state = "cowbell_collar"



//Iron, inherits from iron gorget
/obj/item/clothing/neck/roguetown/gorget/collar
	name = "iron collar"
	desc = "A durable collar fortified with iron."
	icon_state = "collar"
	item_state = "collar"
	leashable = TRUE
	dropshrink = 0.5

/obj/item/clothing/neck/roguetown/gorget/collar/bell
	name = "iron bell collar"
	desc = "A durable collar fortified with iron. Comes with a sturdy bell."
	icon_state = "bell_collar"

/obj/item/clothing/neck/roguetown/gorget/collar/bell/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/neck/roguetown/gorget/collar/bell/cow
	name = "iron cowbell collar"
	desc = "A durable collar fortified with iron. Comes with a simple blacksmithed cowbell."
	icon = 'modular_ochrevalley/icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'modular_ochrevalley/icons/roguetown/clothing/onmob/neck.dmi'
	icon_state = "cowbell_collar"


//Bronze, ingerits from bronze gorget
/obj/item/clothing/neck/roguetown/gorget/bronze/collar
	name = "bronze collar"
	desc = "An interlinked collar of bronze plates, shielding the throat from terrible wounds since the dawn of tyme."
	icon_state = "collar"
	item_state = "collar"
	leashable = TRUE
	dropshrink = 0.5

/obj/item/clothing/neck/roguetown/gorget/bronze/collar/bell
	name = "bronze bell collar"
	desc = "An interlinked collar of bronze plates, shielding the throat from terrible wounds since the dawn of tyme. This one comes with an elegant antique bell."
	icon_state = "bell_collar"

/obj/item/clothing/neck/roguetown/gorget/bronze/collar/bell/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/neck/roguetown/gorget/bronze/collar/bell/cow
	name = "bronze cowbell collar"
	desc = "An interlinked collar of bronze plates, shielding the throat from terrible wounds since the dawn of tyme. This one comes with an well-worn cowbell."
	icon = 'modular_ochrevalley/icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'modular_ochrevalley/icons/roguetown/clothing/onmob/neck.dmi'
	icon_state = "cowbell_collar"



//Steel, inherits from steel gorget
/obj/item/clothing/neck/roguetown/gorget/steel/collar
	name = "steel collar"
	desc = "A sturdy steel collar designed to protect the neck."
	icon_state = "collar"
	item_state = "collar"
	leashable = TRUE
	dropshrink = 0.5

/obj/item/clothing/neck/roguetown/gorget/steel/collar/bell
	name = "steel bell collar"
	desc = "A sturdy steel collar designed to protect the neck. Comes with a durable bell."
	icon_state = "bell_collar"

/obj/item/clothing/neck/roguetown/gorget/steel/collar/bell/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/neck/roguetown/gorget/steel/collar/bell/cow
	name = "steel cowbell collar"
	desc = "A sturdy steel collar designed to protect the neck. Comes with a well-crafted cowbell."
	icon = 'modular_ochrevalley/icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'modular_ochrevalley/icons/roguetown/clothing/onmob/neck.dmi'
	icon_state = "cowbell_collar"




/obj/item/enchantingkit/triumph_transmutekit_armorcollar
	name = "Armored Collar transmutation elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to turn a gorget of leather, iron, bronze, or steel into its collar equivalent"
	target_items = list(
		/obj/item/clothing/neck/roguetown/leather						= /obj/item/clothing/neck/roguetown/leather/collar,
		/obj/item/clothing/neck/roguetown/gorget/steel					= /obj/item/clothing/neck/roguetown/gorget/steel/collar,
		/obj/item/clothing/neck/roguetown/gorget/bronze					= /obj/item/clothing/neck/roguetown/gorget/bronze/collar,
		/obj/item/clothing/neck/roguetown/gorget						= /obj/item/clothing/neck/roguetown/gorget/collar,
		)
	result_item = null

/obj/item/enchantingkit/triumph_transmutekit_armorcollarbell
	name = "Armored Bell Collar transmutation elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to turn a gorget of leather, iron, bronze, or steel into its bell collar equivalent"
	target_items = list(
		/obj/item/clothing/neck/roguetown/leather						= /obj/item/clothing/neck/roguetown/leather/collar/bell,
		/obj/item/clothing/neck/roguetown/gorget/steel					= /obj/item/clothing/neck/roguetown/gorget/steel/collar/bell,
		/obj/item/clothing/neck/roguetown/gorget/bronze					= /obj/item/clothing/neck/roguetown/gorget/bronze/collar/bell,
		/obj/item/clothing/neck/roguetown/gorget						= /obj/item/clothing/neck/roguetown/gorget/collar/bell,
		)
	result_item = null

/obj/item/enchantingkit/triumph_transmutekit_armorcollarcowbell
	name = "Armored Cow Bell Collar transmutation elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to turn a gorget of leather, iron, bronze, or steel into its bell collar equivalent"
	target_items = list(
		/obj/item/clothing/neck/roguetown/leather							= /obj/item/clothing/neck/roguetown/leather/collar/bell/cow,
		/obj/item/clothing/neck/roguetown/gorget/steel						= /obj/item/clothing/neck/roguetown/gorget/steel/collar/bell/cow,
		/obj/item/clothing/neck/roguetown/gorget/bronze						= /obj/item/clothing/neck/roguetown/gorget/bronze/collar/bell/cow,
		/obj/item/clothing/neck/roguetown/gorget							= /obj/item/clothing/neck/roguetown/gorget/collar/bell/cow,
		)
	result_item = null

/datum/crafting_recipe/roguetown/leather/armor/lgorget
	name = "hardened leather gorget"
	display_category = ITEM_CAT_ARMOR_NECK
	result = /obj/item/clothing/neck/roguetown/leather
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
