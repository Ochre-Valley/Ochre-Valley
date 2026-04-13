/datum/customizer/organ/tail_feature
	abstract_type = /datum/customizer/organ/tail_feature
	name = "Tail Feature"

/datum/customizer_choice/organ/tail_feature
	abstract_type = /datum/customizer_choice/organ/tail_feature
	name = "Tail Feature"
	organ_type = /obj/item/organ/tail_feature
	organ_slot = ORGAN_SLOT_TAIL_FEATURE

/datum/customizer/organ/tail_feature/lizard_spines
	customizer_choices = list(/datum/customizer_choice/organ/tail_feature/lizard_spines)
	allows_disabling = TRUE

/datum/customizer_choice/organ/tail_feature/lizard_spines
	name = "Tail Spines"
	organ_type = /obj/item/organ/tail_feature/lizard_spines
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/tail_feature/spines/short,
		/datum/sprite_accessory/tail_feature/spines/shortmeme,
		/datum/sprite_accessory/tail_feature/spines/long,
		/datum/sprite_accessory/tail_feature/spines/longmeme,
		/datum/sprite_accessory/tail_feature/spines/aquatic,
		/// CAUSTIC EDIT
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
		/datum/sprite_accessory/tail_feature/taur/alrauneflower,
		/datum/sprite_accessory/tail_feature/taur/biglegs,
		/datum/sprite_accessory/tail_feature/taur/biglegsstanced,
		/// CAUSTIC EDIT END
		)

/datum/customizer/organ/tail_feature/vox_markings
	customizer_choices = list(/datum/customizer_choice/organ/tail_feature/vox_markings)

/datum/customizer_choice/organ/tail_feature/vox_markings
	name = "Tail Markings"
	organ_type = /obj/item/organ/tail_feature/vox_marking
	sprite_accessories = list(
	/datum/sprite_accessory/tail_feature/vox_marking/bands,
	/datum/sprite_accessory/tail_feature/vox_marking/tip,
	/datum/sprite_accessory/tail_feature/vox_marking/stripe,
	)

/datum/customizer/organ/tail_feature/anthro
	allows_disabling = TRUE
	default_disabled = TRUE
	customizer_choices = list(/datum/customizer_choice/organ/tail_feature/lizard_spines)
