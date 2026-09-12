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

/datum/sprite_accessory/butt
	icon = 'modular_causticcove/icons/mob/merp_organs/butt.dmi'
	color_key_name = "Butt"
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/butt/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!isdwarf(owner) && !isgoblinp(owner) && !iskobold(owner) && !isvermin(owner))
		generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_PANTS, OFFSET_PANTS_F)
	else
		generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BUTT, OFFSET_BUTT)
/datum/sprite_accessory/butt/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/butt/buttie = organ
	return "butt_[icon_state]_[buttie.organ_size]"

/datum/sprite_accessory/butt/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/butt/buttie = organ
	if(owner.underwear)
		return FALSE
	if(!buttie.visible_organ)
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT|HIDECROTCH)

/datum/sprite_accessory/butt/pair
	name = "Pair"
	icon_state = "pair"
	color_key_defaults = list(KEY_SKIN_COLOR)
