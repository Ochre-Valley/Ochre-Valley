/datum/customizer/organ/eyes/generic
	customizer_choices = list(/datum/customizer_choice/organ/eyes/generic)
	default_choice = /datum/customizer_choice/organ/eyes

/datum/customizer_choice/organ/eyes/generic
	name = "Eyes"
	sprite_accessories = list(
	/datum/sprite_accessory/eyes/humanoid,
	/datum/sprite_accessory/eyes/humanoid_glow,
	/datum/sprite_accessory/eyes/vertical,
	/datum/sprite_accessory/eyes/horizontal,
	/datum/sprite_accessory/eyes/triangle,
	/datum/sprite_accessory/eyes/spider,
	/datum/sprite_accessory/eyes/big,
	/datum/sprite_accessory/eyes/massive,
	/datum/sprite_accessory/eyes/moth,
	)


/datum/customizer/organ/eyes/generic/moth
	customizer_choices = list(/datum/customizer_choice/organ/eyes/generic/moth)
	default_choice = /datum/customizer_choice/organ/eyes/moth

/datum/customizer_choice/organ/eyes/generic/moth
	name = "Fluvian Eyes"
	organ_type = /obj/item/organ/eyes/moth
