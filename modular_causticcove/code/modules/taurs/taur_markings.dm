/datum/customizer_choice/organ/tail_feature/taur_markings
	name = "Tail Markings"
	organ_type = /obj/item/organ/tail_feature/taur_markings
	sprite_accessories =  list(
		/datum/sprite_accessory/tail_feature/taur/lamia,
		/datum/sprite_accessory/tail_feature/taur/horse,
		/datum/sprite_accessory/tail_feature/taur/lizard,
		/datum/sprite_accessory/tail_feature/taur/feline,
		/datum/sprite_accessory/tail_feature/taur/drake,
		/datum/sprite_accessory/tail_feature/taur/otie,
		/datum/sprite_accessory/tail_feature/taur/wolf,
		/datum/sprite_accessory/tail_feature/taur/deer,
		/datum/sprite_accessory/tail_feature/taur/fatwolf,
		/datum/sprite_accessory/tail_feature/taur/fatfeline,
		/datum/sprite_accessory/tail_feature/taur/altnaga,
		/datum/sprite_accessory/tail_feature/taur/altnagatailmaw,
		/datum/sprite_accessory/tail_feature/taur/fatnaga,
		/datum/sprite_accessory/tail_feature/taur/caustic/bunny,
		/datum/sprite_accessory/tail_feature/taur/caustic/deerbelly,
		/datum/sprite_accessory/tail_feature/taur/biglegs,
		/datum/sprite_accessory/tail_feature/taur/biglegsstanced,
	)

/obj/item/organ/tail_feature/taur_markings
	name = "taur marking"


//Taur markings
/datum/sprite_accessory/tail_feature/taur
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/tail_feature/taur/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
    generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_TAUR, OFFSET_TAUR_F)

/datum/sprite_accessory/tail_feature/taur/lamia
	name = "Lamia Taur Markings"	
	icon = 'modular_causticcove/icons/mob/taurs/naga_markings.dmi'
	icon_state = "naga_markings"

/datum/sprite_accessory/tail_feature/taur/horse
	name = "Horse Taur Markings"
	icon = 'modular_causticcove/icons/mob/taurs/horse_markings.dmi'
	icon_state = "horse_markings"

/datum/sprite_accessory/tail_feature/taur/lizard
	name = "Lizard Taur Markings"
	icon = 'modular_causticcove/icons/mob/taurs/lizard_markings.dmi'
	icon_state = "lizard_markings"


/datum/sprite_accessory/tail_feature/taur/feline
	name = "Feline Taur Markings"
	icon = 'modular_causticcove/icons/mob/taurs/feline_markings.dmi'
	icon_state = "feline_markings"

/datum/sprite_accessory/tail_feature/taur/drake
	name = "Drake Taur Markings"
	icon = 'modular_causticcove/icons/mob/taurs/drake_markings.dmi'
	icon_state = "drake_markings"

/datum/sprite_accessory/tail_feature/taur/otie
	name = "Large Hound Markings"
	icon = 'modular_causticcove/icons/mob/taurs/otie_markings.dmi'
	icon_state = "otie_markings"

/datum/sprite_accessory/tail_feature/taur/wolf
	name = "Wolf Taur Markings"
	icon = 'modular_causticcove/icons/mob/taurs/wolf_markings.dmi'
	icon_state = "wolf_markings"

/datum/sprite_accessory/tail_feature/taur/deer
	name = "Deer Taur Markings"
	icon = 'modular_causticcove/icons/mob/taurs/deer_markings.dmi'
	icon_state = "deer_markings"

/datum/sprite_accessory/tail_feature/taur/fatwolf
	name = "Fat Wolf Taur Markings"
	icon = 'modular_causticcove/icons/mob/taurs/fatwolf_markings.dmi'
	icon_state = "fatwolf_markings"

/datum/sprite_accessory/tail_feature/taur/fatfeline
	name = "Fat Feline Taur Markings"
	icon = 'modular_causticcove/icons/mob/taurs/fatfeline_markings.dmi'
	icon_state = "fatfeline_markings"


/datum/sprite_accessory/tail_feature/taur/altnaga
	name = "AltNaga Taur Markings"
	icon = 'modular_causticcove/icons/mob/taurs/altnaga_markings.dmi'
	icon_state = "altnaga_markings"

/datum/sprite_accessory/tail_feature/taur/altnagatailmaw
	name = "AltNaga Tail Maw Taur Markings"
	icon = 'modular_causticcove/icons/mob/taurs/altnagatailmaw_markings.dmi'
	icon_state = "altnagatailmaw_markings"

/datum/sprite_accessory/tail_feature/taur/fatnaga
	name = "Fat Naga Taur Markings"
	icon = 'modular_causticcove/icons/mob/taurs/fatnaga_markings.dmi'
	icon_state = "fatnaga_markings"

/datum/sprite_accessory/tail_feature/taur/alrauneflower
	name = "Alraune Flower"
	icon = 'modular_causticcove/icons/mob/taurs/alraune_markings.dmi'
	icon_state = "alraune_markings"



/datum/sprite_accessory/tail_feature/taur/caustic

/datum/sprite_accessory/tail_feature/taur/caustic/bunny
	name = "Bunny Taur Markings"
	icon = 'modular_causticcove/icons/mob/taurs/bunnytaur_markings.dmi'
	icon_state = "bigbunny_s"

/datum/sprite_accessory/tail_feature/taur/caustic/deerbelly
	name = "Deer Taur Belly Markings"
	icon = 'modular_causticcove/icons/mob/taurs/taurdeer_belly.dmi'
	icon_state = "taurdeer_belly_s"


/datum/sprite_accessory/tail_feature/large_snake
	icon = 'modular_causticcove/icons/mob/taurs/large_snake_markings.dmi'
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/tail_feature/taur/biglegs
	name = "Big Legs Marking"
	icon = 'modular_causticcove/icons/mob/taurs/biglegs_markings.dmi'
	icon_state = "biglegs_norm"

/datum/sprite_accessory/tail_feature/taur/biglegsstanced
	name = "Big Legs, Stanced Marking"
	icon = 'modular_causticcove/icons/mob/taurs/biglegsstanced_markings.dmi'
	icon_state = "biglegs_stanced"
