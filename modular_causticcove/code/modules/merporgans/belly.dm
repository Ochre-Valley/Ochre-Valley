/obj/item/organ/belly
	name = "belly"
	icon_state = "belly"
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_STOMACH
	slot = ORGAN_SLOT_BELLY
	organ_dna_type = /datum/organ_dna/belly
	accessory_type = /datum/sprite_accessory/belly
	var/belly_size = DEFAULT_BELLY_SIZE

/obj/item/organ/belly/get_cache_key()
	return "[..()]-[belly_size]"

/datum/organ_dna/belly
	var/belly_size = DEFAULT_BELLY_SIZE

/datum/organ_dna/belly/imprint_organ(obj/item/organ/organ)
	..()
	var/obj/item/organ/belly/belly_organ = organ
	belly_organ.belly_size = belly_size

GLOBAL_LIST_INIT(named_belly_sizes, list(
	"flat" = 0,
	"small" = 1,
	"medium" = 2,
	"large" = 3,
	"enormous" = 5,
	"towering" = 6,
	"gigantic" = 7,
	"gargantuan" = 8,
	"colossal" = 9,
	"ungodly big" = 10,
))

/datum/sprite_accessory/belly
	icon = 'modular_causticcove/icons/mob/merp_organs/belly.dmi'
	color_key_name = "Belly"

/datum/sprite_accessory/belly/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/belly/belleh = organ
	return "belly_[icon_state]_[belleh.belly_size]"

/datum/sprite_accessory/belly/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELT, OFFSET_BELT_F)

/datum/sprite_accessory/belly/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEBOOB|HIDEJUMPSUIT)

/datum/sprite_accessory/belly
	icon_state = "pair"
	name = "Belly"
	color_key_defaults = list(KEY_CHEST_COLOR)
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONTER_LAYER)
