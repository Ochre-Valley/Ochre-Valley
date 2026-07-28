/obj/item/organ/butt
	name = "butt"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "butt"
	dropshrink = 0.5
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_STOMACH
	slot = ORGAN_SLOT_BUTT
	organ_dna_type = /datum/organ_dna/butt
	accessory_type = /datum/sprite_accessory/butt/pair
	var/organ_size = DEFAULT_BUTT_SIZE

/obj/item/organ/butt/get_cache_key()
	return "[..()]-[organ_size]"

/datum/organ_dna/butt
	var/organ_size = DEFAULT_BUTT_SIZE

/datum/organ_dna/butt/imprint_organ(obj/item/organ/organ)
	..()
	var/obj/item/organ/butt/butt_organ = organ
	butt_organ.organ_size = organ_size

GLOBAL_LIST_INIT(named_butt_sizes, list(
	"flat" = 0,
	"small" = 1,
	"medium" = 2,
	"large" = 3,
	"massive" = 4,
	"enormous" = 5,
))

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
	return is_human_part_visible(owner, HIDEJUMPSUIT|HIDEBUTT)

/datum/sprite_accessory/butt/pair
	name = "Pair"
	icon_state = "pair"
	color_key_defaults = list(KEY_SKIN_COLOR)
