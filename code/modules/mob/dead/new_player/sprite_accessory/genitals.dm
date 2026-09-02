/datum/sprite_accessory/penis
	icon = 'icons/mob/sprite_accessory/genitals/pintle.dmi'
//Caustic Edit, adds dynamic state changes -- Also upgrade to SPLURTS icons - Jon
	//color_keys = 2
	color_key_name = "Member"
	color_key_names = "Member" //list("Member", "Skin")
	relevant_layers = list(/*BODY_BEHIND_LAYER, */BODY_FRONT_LAYER) //Vrell - Yes I know this is hacky but it works for now

/datum/sprite_accessory/penis/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELT, OFFSET_BELT_F)

/datum/sprite_accessory/penis/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/penis/pp = organ
	if(pp.sheath_type != SHEATH_TYPE_NONE && pp.erect_state <= 1) //Do they have a sheath type and is the state less than 1? <-- This used to say 'greater than 1' in the comment for some reason -- Okay trying out with it set to <= 1
		switch(pp.sheath_type)
			if(SHEATH_TYPE_NORMAL)
				if(pp.erect_state == ERECT_STATE_NONE) //Okay. This code is a mess, I don't know who edited it before but uh. This doesn't make sense.
					return "sheath_0" //<-- It will ALWAYS land on this
				else
					return "sheath_1" //Because of the overall if statement this is contained in, it will NEVER not be 0 (or below but, I don't think it CAN go negative?)
			if(SHEATH_TYPE_SLIT) //This check is the same as above, just, different switch result. I don't know who edited this before :< - Jon
				if(pp.erect_state == ERECT_STATE_NONE)
					return "slit_0"
				else
					return "slit_1"

	if(pp.erect_state == ERECT_STATE_HARD)
		return "[icon_state]_[max(1, min(MAX_PENIS_SIZE, pp.penis_size))]_1"
	if(pp.erect_state == ERECT_STATE_STIFF)
		return "[icon_state]_[max(1, min(MAX_PENIS_SIZE, pp.penis_size))]_0"
	if(pp.erect_state == ERECT_STATE_PARTIAL) // Not revealed if they have a sheath, see above. <-- Not true anymore! Wait. Was the above supposed to be <= ???
		return "[icon_state]_[max(1, min(MAX_PENIS_SIZE, pp.penis_size-1))]_0"

	//Normal penis check for those without a sheath, just hang flaccid with -1 size.
	else if(pp.sheath_type == SHEATH_TYPE_NONE && pp.erect_state == ERECT_STATE_NONE)
		return "[icon_state]_[max(1, min(MAX_PENIS_SIZE, pp.penis_size-1))]_0"

	//Penis should no longer be aroused, and is hidden, transitions with sheath states as well.
	else
		return "blank"

/datum/sprite_accessory/penis/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.underwear)
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT|HIDECROTCH)

/datum/sprite_accessory/penis/human
	icon_state = "human"
	name = "Plain"
	color_key_defaults = list(KEY_CHEST_COLOR) //list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)

/datum/sprite_accessory/penis/knotted
	icon_state = "knotted"
	name = "Knotted"
	color_key_defaults = list(KEY_CHEST_COLOR) //list(null, KEY_CHEST_COLOR)
	//default_colors = list("C52828", null)

/*/datum/sprite_accessory/penis/knotted2
	name = "Knotted 2"
	icon_state = "knotted2"
	color_key_defaults = list(KEY_CHEST_COLOR) //list(null, KEY_CHEST_COLOR)
	//default_colors = list("C52828", null)
*/
/datum/sprite_accessory/penis/flared
	icon_state = "flared"
	name = "Flared"
	color_key_defaults = list(KEY_CHEST_COLOR) //list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)

/datum/sprite_accessory/penis/barbknot
	icon_state = "barbknot"
	name = "Barbed, Knotted"
	color_key_defaults = list(KEY_CHEST_COLOR) //list(null, KEY_CHEST_COLOR)
	//default_colors = list("C52828", null)

/datum/sprite_accessory/penis/tapered
	icon_state = "tapered"
	name = "Tapered"
	default_colors = list("C52828") //list("C52828", "C52828")

/datum/sprite_accessory/penis/tapered_mammal
	icon_state = "tapered"
	name = "Tapered"
	color_key_defaults = list(KEY_CHEST_COLOR) //list(null, KEY_CHEST_COLOR)
	//default_colors = list("C52828", null)

/datum/sprite_accessory/penis/tentacle
	icon_state = "tentacle"
	name = "Tentacled"
	default_colors = list("C52828") //list("C52828", "C52828")

/datum/sprite_accessory/penis/hemi
	icon_state = "hemi"
	name = "Hemi"
	default_colors = list("C52828") //list("C52828", "C52828")

/datum/sprite_accessory/penis/hemiknot
	icon_state = "hemiknot"
	name = "Knotted Hemi"
	default_colors = list("C52828") //list("C52828", "C52828")

/datum/sprite_accessory/penis/nondescript
	icon_state = "nondescript"
	name = "Nondescript"
	color_key_defaults = list(KEY_CHEST_COLOR) //list("C52828", "C52828")
//Caustic edit end

/datum/sprite_accessory/testicles
	icon = 'icons/mob/sprite_accessory/genitals/gonads.dmi'
	color_key_name = "Sack"
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_NOTSOFRONT_LAYER)

/datum/sprite_accessory/testicles/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELT, OFFSET_BELT_F)

/datum/sprite_accessory/testicles/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/testicles/testes = organ
	return "[icon_state]_[testes.ball_size]"

/datum/sprite_accessory/testicles/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.underwear)
		return FALSE
	//Caustic Edit - Allow visible balls even with a slit!
	//var/obj/item/organ/penis/pp = owner.getorganslot(ORGAN_SLOT_PENIS)
	//if(pp && pp.sheath_type == SHEATH_TYPE_SLIT)
		//return FALSE
	//Caustic Edit End
	return is_human_part_visible(owner, HIDEJUMPSUIT|HIDECROTCH)

/datum/sprite_accessory/testicles/pair
	name = "Pair"
	icon_state = "pair"
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/testicles/sheath
	name = "Sheath"
	icon_state = "sheath"
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/sprite_accessory/breasts
	icon = 'icons/mob/sprite_accessory/genitals/breasts.dmi'
	//Caustic Edit, our chests run off different layers than default
	//color_key_name = "Breasts"
	color_keys = 2
	color_key_names = list("Breasts", "Nipples")
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONTEST_LAYER)
	//Caustic Edit end

/datum/sprite_accessory/breasts/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/breasts/badonkers = organ
	return "[icon_state]_[badonkers.breast_size]"

/datum/sprite_accessory/breasts/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_ID, OFFSET_ID_F)

/datum/sprite_accessory/breasts/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.underwear && owner.underwear.covers_breasts)
		return FALSE
	return is_human_part_visible(owner, HIDEBOOB|HIDEJUMPSUIT)

/datum/sprite_accessory/breasts/pair
	icon_state = "pair"
	name = "Pair"
	color_key_defaults = list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)

/datum/sprite_accessory/breasts/quad
	icon_state = "quad"
	name = "Quad"
	color_key_defaults = list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)

/datum/sprite_accessory/breasts/sextuple
	icon_state = "sextuple"
	name = "Sextuple"
	color_key_defaults = list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)

/datum/sprite_accessory/vagina
	icon = 'icons/mob/sprite_accessory/genitals/nethers.dmi'
	color_key_name = "Nethers"
	relevant_layers = list(BODY_FRONT_LAYER)

/datum/sprite_accessory/vagina/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELT, OFFSET_BELT_F)

/datum/sprite_accessory/vagina/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.underwear)
		return FALSE
	return is_human_part_visible(owner, HIDECROTCH|HIDEJUMPSUIT)

/datum/sprite_accessory/vagina/human
	icon_state = "human"
	name = "Plain"
	default_colors = list("ea6767")

/datum/sprite_accessory/vagina/hairy
	icon_state = "hairy"
	name = "Hairy"
	color_key_defaults = list(KEY_HAIR_COLOR)

/datum/sprite_accessory/vagina/spade
	icon_state = "spade"
	name = "Spade"
	default_colors = list("C52828")

/datum/sprite_accessory/vagina/furred
	icon_state = "furred"
	name = "Furred"
	color_key_defaults = list(KEY_MUT_COLOR_ONE)

/datum/sprite_accessory/vagina/gaping
	icon_state = "gaping"
	name = "Gaping"
	default_colors = list("f99696")

/datum/sprite_accessory/vagina/cloaca
	icon_state = "cloaca"
	name = "Cloaca"
	default_colors = list("f99696")
