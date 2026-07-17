// TAURS
/obj/item/bodypart/taur
	name = "taur"
	desc = ""
	///Caustic edit
	icon = 'modular_causticcove/icons/mob/taurs/taurs.dmi'
	icon_state = ""
	attack_verb = list("hit")
	max_damage = 200
	body_zone = BODY_ZONE_TAUR
	body_part = LEGS
	body_damage_coeff = 1
	px_x = -16
	px_y = 12
	max_stamina_damage = 50
	subtargets = list(BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT)
	grabtargets = list(BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT)
	dismember_wound = /datum/wound/dismemberment/taur
	unlimited_bleeding = TRUE

	// Taur stuff!
	// offset_x forces the limb_icon to be shifted on x relative to the human (since these are >32x32)
	var/offset_x = -16
	// taur_icon_state sets which icon to use from icons/mob/taurs.dmi to render
	// (we don't use icon_state to avoid duplicate rendering on dropped organs)
	var/taur_icon_state = "naga_s"

	//OV ADD - TAUR BARDING
	// Determines which set of taur barding sprites to use. Easiest way to do this, frankly... ough.
	// "m" = mammalian (canine, feline, tempest, kitsune, venard, skunk)
	// "r" = reptilian (drake, noodle, sloog)
	// "d" = deer
	// null = no taur-specific clothing support
	var/taur_clothing_category = null
	// Customizable colors for plate tasset overlays (like detail_color on clothing)
	var/tasset1_color = null
	var/tasset2_color = null
	//OV ADD END

	// We can Blend() a color with the base greyscale color, only some tails support this
	var/has_taur_color = FALSE
	var/color_blend_mode = BLEND_ADD
	var/taur_color = null

	// Clip Masks allow you to apply a clipping filter to some other parts of human rendering to avoid anything overlapping the tail.
	// Specifically: update_inv_cloak, update_inv_shirt, update_inv_armor, and update_inv_pants.
	///Caustic edit
	var/icon/clip_mask_icon = 'modular_causticcove/icons/mob/taurs/taurs.dmi'
	var/clip_mask_state = "taur_clip_mask_def"
	// Instantiated at runtime for speed
	var/tmp/icon/clip_mask

/obj/item/bodypart/taur/New()
	. = ..()

	if(clip_mask_state)
		clip_mask = icon(icon = (clip_mask_icon || icon), icon_state = clip_mask_state)

/obj/item/bodypart/taur/get_limb_icon(dropped, hideaux = FALSE)
	// List of overlays
	. = list()
	// OV Edit Start
	var/mob/living/bodypart_owner = owner || original_owner
	var/datum/status_effect/petrified/bodypart_owner_petrified = bodypart_owner?.IsPetrified()
	var/statue_color = petrification_render_color
	if(!statue_color && bodypart_owner_petrified)
		petrification_debug("taur_get_limb_icon renderer-fallback bypassed: [petrification_debug_bodypart_summary(src)] owner=[petrification_debug_value(bodypart_owner)] requested_color=[bodypart_owner.get_petrification_render_color(TRUE)]")
	var/list/petrified_color_matrix
	if(statue_color)
		petrified_color_matrix = petrification_material_color_matrix(statue_color)
	if(statue_color || bodypart_owner_petrified)
		petrification_debug("taur_get_limb_icon start: [petrification_debug_bodypart_summary(src)] dropped=[dropped] owner=[petrification_debug_value(bodypart_owner)] owner_petrified=[!!bodypart_owner_petrified] statue_color=[petrification_debug_value(statue_color)] taur_color=[petrification_debug_value(taur_color)] matrix_len=[petrification_debug_len(petrified_color_matrix)]")
	// OV Edit End

	var/image_dir = 0
	if(dropped)
		image_dir = SOUTH

	// This section is based on Virgo's human rendering, there may be better ways to do this now
	var/icon/tail_s = new/icon("icon" = icon, "icon_state" = taur_icon_state, "dir" = image_dir)
	if(has_taur_color)
		tail_s.Blend(taur_color, color_blend_mode)

	var/image/working = image(tail_s)
	// because these can overlap other organs, we need to layer slightly higher
	working.layer = -FRONT_MUTATIONS_LAYER
	working.pixel_x = offset_x
	// OV Edit Start
	if(petrified_color_matrix)
		working.color = petrified_color_matrix
		petrification_debug("taur_get_limb_icon color-applied: zone=[body_zone] icon_state=[taur_icon_state] working_color=[petrification_debug_value(working.color)]")

	. += working
	if(statue_color || bodypart_owner_petrified)
		petrification_debug("taur_get_limb_icon end: zone=[body_zone] overlays=[petrification_debug_len(.)] working_color=[petrification_debug_value(working.color)]")
	// OV Edit End

/*********************************/
/* TAUR TYPES                    */
/*********************************/
GLOBAL_LIST_INIT(taur_types, subtypesof(/obj/item/bodypart/taur))

/obj/item/bodypart/taur/lamia
	name = "Lamia Tail"

	offset_x = -16
	taur_icon_state = "naga_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/spider
	name = "Spider Body"

	offset_x = -16
	taur_icon_state = "spider_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/horse
	name = "Horse Body"

	offset_x = -16
	taur_icon_state = "horse_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/cow
	name = "Cow Body"

	offset_x = -16
	taur_icon_state = "cow_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/lizard
	name = "Lizard Body"

	offset_x = -16
	taur_icon_state = "lizard_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/tent
	name = "Tent Body (whatever the fuck that is)"

	offset_x = -16
	taur_icon_state = "tent_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/tentacle
	name = "Tentacle Body"

	offset_x = -16
	taur_icon_state = "tentacle_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/feline
	name = "Feline Body"

	offset_x = -16
	taur_clothing_category = "m" //OV ADD
	taur_icon_state = "feline_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/slug
	name = "Slug Body"

	offset_x = -16
	taur_icon_state = "slug_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/tempest
	name = "Tempest Body"

	offset_x = -16
	taur_clothing_category = "m" //OV ADD
	taur_icon_state = "tempest_s"

	has_taur_color = TRUE

	has_taur_color = TRUE

/obj/item/bodypart/taur/drake
	name = "Drake Body"

	offset_x = -16
	taur_clothing_category = "r" //OV ADD
	taur_icon_state = "drake_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/otie
	name = "Virgo shit dog"

	offset_x = -16
	taur_icon_state = "otie_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/wolf
	name = "Wolf Body"

	offset_x = -16
	taur_clothing_category = "m" //OV ADD
	taur_icon_state = "wolf_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/alraune
	name = "Alraune (take tail too)"

	offset_x = -16
	taur_icon_state = "alraune_s"

	has_taur_color = TRUE /// CAUSTIC EDIT

/obj/item/bodypart/taur/frog
	name = "Frog Body"

	offset_x = -16
	taur_icon_state = "frog_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/deer
	name = "Deer Body"

	offset_x = -16
	taur_clothing_category = "d" //OV ADD
	taur_icon_state = "deer_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/wasp
	name = "Wasp Body"

	offset_x = -16
	taur_icon_state = "wasp_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/fatwolf
	name = "Fat wolf Body"

	offset_x = -16
	taur_clothing_category = "m" //OV ADD
	taur_icon_state = "fatwolf_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/fatfeline
	name = "Fat feline Body"

	offset_x = -16
	taur_clothing_category = "m" //OV ADD
	taur_icon_state = "fatfeline_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/mermaid
	name = "Mermaid Body"

	offset_x = -16
	taur_icon_state = "mermaid_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/altnaga
	name = "Alt Naga Body"

	offset_x = -16
	taur_icon_state = "altnaga_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/altnagatailmaw
	name = "Alt Naga Tailmaw Body"

	offset_x = -16
	taur_icon_state = "altnagatailmaw_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/fatnaga
	name = "Fat Naga Body"

	offset_x = -16
	taur_icon_state = "fatnaga_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/mammoth
	name = "Mammoth Body"

	offset_x = -16
	taur_icon_state = "mammoth_s"

	has_taur_color = TRUE

/obj/item/bodypart/taur/goat
	name = "Goat Legs"

	offset_x = -16
	taur_icon_state = "goat_s"
	clip_mask_state = "clip_mask_goat"

	has_taur_color = TRUE

//OV edit
/obj/item/bodypart/taur/satyr
	name = "Satyr Legs"

	icon = 'modular_ochrevalley/icons/mob/taurs/taurs.dmi'
	offset_x = -16
	taur_icon_state = "satyr_s"

	has_taur_color = TRUE
//OV edit end
