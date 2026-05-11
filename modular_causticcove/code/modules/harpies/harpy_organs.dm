/obj/item/organ/vocal_cords/harpy
	name = "harpy's song"
	icon_state = "voice_of_god" //OV Add - CC Upstream Sync
	desc = "The blessed essence of harpysong. How did you get this... you monster!"
	actions_types = list(/datum/action/item_action/organ_action/use/harpy_sing)

/obj/item/organ/vocal_cords/harpy/Initialize()
	. = ..()

/obj/item/organ/vocal_cords/harpy/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	M.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)

/obj/item/organ/vocal_cords/harpy/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	M.adjust_skillrank(/datum/skill/misc/music, -1, TRUE)

/datum/action/item_action/organ_action/use/harpy_sing
	name = "Harpy's song"
	desc = "Project your voice through song."
	/*icon = 'icons/mob/actions/bardsongs.dmi' //OV Edit - Commented out
	icon_state = "melody_t1_base"*/

/datum/action/item_action/organ_action/use/harpy_sing/Trigger()
	if(do_after(owner, 2 SECONDS, owner))
		owner.put_in_hands(new /obj/item/rogue/instrument/vocals/harpy_song(owner))
	return

/obj/item/rogue/instrument/vocals/harpy_song
	name = "Harpy's song"
	desc = "Project your voice through song."
	icon = 'icons/mob/actions/bardsongs.dmi'
	icon_state = "melody_t1_base"
	experimental_inhand = FALSE //OV Add - CC sync
	
	item_flags = ABSTRACT | DROPDEL
	slot_flags = null
	can_parry = FALSE
	force = 0
	throwforce = 0

 // --

/datum/customizer/organ/wings/harpy
	customizer_choices = list(/datum/customizer_choice/organ/wings/harpy)
	allows_disabling = FALSE

/datum/customizer_choice/organ/wings/harpy
	name = "Wings"
	organ_type = /obj/item/organ/wings/flight/harpy
	sprite_accessories = list(
		/datum/sprite_accessory/wings/wide/harpywings,
		/datum/sprite_accessory/wings/wide/harpywingsalt1,
		/datum/sprite_accessory/wings/wide/harpywingsalt2, //OV Add
		/datum/sprite_accessory/wings/wide/harpywings_top,
		/datum/sprite_accessory/wings/wide/harpywingsalt1_top,
		/datum/sprite_accessory/wings/wide/harpywingsalt2_top, //OV Add
		/datum/sprite_accessory/wings/large/harpyswept,
		/datum/sprite_accessory/wings/large/harpyswept_alt,
		/datum/sprite_accessory/wings/large/harpyfluff,
		/datum/sprite_accessory/wings/large/harpyfolded,
		/datum/sprite_accessory/wings/large/harpyowl,
		/datum/sprite_accessory/wings/large/harpybat_alt, //OV Add
		/datum/sprite_accessory/wings/ochre/wingarms_speckles, //OV Add
		/datum/sprite_accessory/wings/ochre/wingarms_2tone, //OV Add
		)

/datum/customizer/organ/tail/harpy
	customizer_choices = list(/datum/customizer_choice/organ/tail/harpy)
	allows_disabling = TRUE

/datum/customizer_choice/organ/tail/harpy
	name = "Harpy Plumage"
	organ_type = /obj/item/organ/tail
	generic_random_pick = TRUE
	allows_accessory_color_customization = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/tail/hawk,
		/datum/sprite_accessory/tail/corvid,
		/datum/sprite_accessory/tail/owl,
		/datum/sprite_accessory/tail/forked_long,
		/datum/sprite_accessory/tail/haven,
		/datum/sprite_accessory/tail/swallow,
		/datum/sprite_accessory/tail/ochre/narrowtail_2color, //OV Add
	)

//OV Add - CC Upstream Sync
/datum/customizer/organ/snout/harpy
	name = "Beak"
	allows_disabling = TRUE
	default_disabled = TRUE
	customizer_choices = list(/datum/customizer_choice/organ/snout/harpy)

/datum/customizer_choice/organ/snout/harpy
	name = "Harpy Beak"
	organ_type = /obj/item/organ/snout/beak
	sprite_accessories = list(
		/datum/sprite_accessory/snout/bird,
		/datum/sprite_accessory/snout/bigbeak,
		/datum/sprite_accessory/snout/bigbeakshort,
		/datum/sprite_accessory/snout/slimbeak,
		/datum/sprite_accessory/snout/slimbeakshort,
		/datum/sprite_accessory/snout/slimbeakalt,
		/datum/sprite_accessory/snout/hookbeak,
		/datum/sprite_accessory/snout/hookbeakbig,
		/datum/sprite_accessory/snout/toucan,
		/datum/sprite_accessory/snout/sbeak,
		/datum/sprite_accessory/snout/front/bird,
		/datum/sprite_accessory/snout/front/bigbeak,
		/datum/sprite_accessory/snout/front/toucan,
		/datum/sprite_accessory/snout/ochre/short_beak,
		/datum/sprite_accessory/snout/ochre/parrot_beak,
		/datum/sprite_accessory/snout/ochre/thin_beak,
		/datum/sprite_accessory/snout/ochre/finch_beak,
		/datum/sprite_accessory/snout/ochre/pelican_beak,
		/datum/sprite_accessory/snout/ochre/toucan_beak_alt,
		/datum/sprite_accessory/snout/ochre/raptor_beak_small,
		/datum/sprite_accessory/snout/ochre/raptor_beak_large,
		)
//OV Add End
