#define SENTINEL_LEGGY_TYPE "legs"

/obj/item/taur_potion
	name = "crurahol potion"
	desc = "A bottle with a snake motif. It seems to slowly refill itself."
	icon = 'modular_ochrevalley/icons/roguetown/items/taur_potion.dmi'
	icon_state = "bottle"
	drop_sound = 'sound/foley/dropsound/glass_drop.ogg'
	possible_item_intents = list(INTENT_POUR)
	w_class = WEIGHT_CLASS_SMALL

	interaction_flags_atom = INTERACT_ATOM_UI_INTERACT

	var/drinksounds = list('sound/items/drink_bottle (1).ogg','sound/items/drink_bottle (2).ogg')

	var/taur_type = /obj/item/bodypart/taur/lamia
	var/taur_color = "#703200"

	COOLDOWN_DECLARE(drink_cooldown)

// Base Code
/obj/item/taur_potion/Initialize(mapload)
	. = ..()
	vand_update_appearance(UPDATE_ICON)
	RegisterSignal(src, COMSIG_CD_STOP("drink_cooldown"), PROC_REF(cooldown_ends))

/obj/item/taur_potion/proc/cooldown_ends()
	vand_update_appearance(UPDATE_ICON)

/obj/item/taur_potion/proc/set_taur_color(new_color)
	taur_color = new_color
	vand_update_appearance(UPDATE_ICON)

/obj/item/taur_potion/update_overlays()
	. = ..()

	underlays.Cut()

	if(TIMER_COOLDOWN_FINISHED(src, "drink_cooldown"))
		var/mutable_appearance/fluid_overlay = mutable_appearance(icon, "underlay")
		fluid_overlay.appearance_flags = RESET_COLOR
		fluid_overlay.color = taur_color
		underlays += fluid_overlay

// UI
/obj/item/taur_potion/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TaurPotion", "[name]")
		ui.open()

/obj/item/taur_potion/ui_data(mob/user)
	var/list/data = ..()

	data["taur_type"] = taur_type
	data["taur_color"] = taur_color

	return data

/obj/item/taur_potion/ui_static_data(mob/user)
	var/list/data = ..()

	var/list/taurs = list()
	for(var/path in GLOB.taur_types)
		var/obj/item/bodypart/taur/T = path
		UNTYPED_LIST_ADD(taurs, list(
			"name" = T::name,
			"path" = T,
			"icon" = REF(T::icon),
			"icon_state" = T::taur_icon_state,
			// WARNING: Assumption made here is that taur.has_taur_color and taur.color_blend_mode are always TRUE/BLEND_ADD 
			// because this is currently true, if they change this at some point then add support for it!
		))
	data["taurs"] = taurs

	return data

/obj/item/taur_potion/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("change_taur_color")
			var/color = input(ui.user, "Please select taur color.", "Taur Color", taur_color) as color|null
			if(color)
				if(color[1] != "#")
					color = "#[color]"
				set_taur_color(color)
			. = TRUE
		if("change_taur_type_legs")
			taur_type = SENTINEL_LEGGY_TYPE
			. = TRUE
		if("change_taur_type")
			var/type = text2path(params["type"])
			if(!(type in GLOB.taur_types)) // assumption: all taur types are fair game
				return
			taur_type = type
			. = TRUE

// Transformation
/obj/item/taur_potion/attack(mob/M, mob/user, obj/target)
	if(!TIMER_COOLDOWN_FINISHED(src, "drink_cooldown"))
		var/timeleft = S_TIMER_COOLDOWN_TIMELEFT(src, "drink_cooldown")
		to_chat(user, span_warning("[src] can't be drunk again for another [round(timeleft / 10)] seconds."))
		return

	if(!iscarbon(M))
		to_chat(user, span_warning("[src] will not work on [M]."))
		return

	if(M != user)
		M.visible_message(span_danger("[user] attempts to feed [M] [src]."), \
					span_danger("[user] attempts to feed you [src]."))
		if(!do_mob(user, M, double_progress = TRUE, can_move = FALSE))
			return

	if(tgui_alert(user, "Are you okay with [M] transforming you with [src]?", "Transformation Consent", list("No", "Yes")) != "Yes")
		log_combat(user, M, "fed", "taur potion - [taur_type] (CONSENT DENIED)")
		message_admins("[key_name_admin(user)] attempted to feed [key_name_admin(M)] with [src] but consent was denied!")
		return

	S_TIMER_COOLDOWN_START(src, "drink_cooldown", 1 MINUTES)
	log_combat(user, M, "fed", "taur potion - [taur_type] (CONSENT ACCEPTED)")
	vand_update_appearance(UPDATE_ICON)

	if(M != user)
		M.visible_message(span_danger("[user] feeds [M] [src]."), \
					span_danger("[user] feeds you [src]."))
	else
		to_chat(user, span_notice("I swallow a gulp of [src]."))

	playsound(M, pick(drinksounds), 100, TRUE)

	INVOKE_ASYNC(src, PROC_REF(transform_target), M)

/obj/item/taur_potion/proc/transform_target(mob/living/carbon/target)
	// Lock the settings into local variables so they can't change
	var/obj/item/bodypart/taur/local_taur_type = taur_type
	var/local_taur_color = taur_color

	// Case 1: We want to UNtaur them
	if(local_taur_type == SENTINEL_LEGGY_TYPE)
		target.ensure_not_taur()
		announce_transform(target, "set of regular legs")
		return

	// Case 2: Has same taur type so we must only update color
	for(var/obj/item/bodypart/taur/part in target.bodyparts)
		if(part.type == local_taur_type)
			part.taur_color = local_taur_color
			target.regenerate_icons()
			announce_transform(target, local_taur_type::name)
			return

	// Case 3: Has different taur type or leggies, either way Taurize will work
	target.Taurize(local_taur_type, local_taur_color)
	announce_transform(target, local_taur_type::name)

/obj/item/taur_potion/proc/announce_transform(mob/living/carbon/target, taur_name)
	target.Knockdown(2 SECONDS)
	target.visible_message("[target] morphs and grows a [lowertext(taur_name)]!", \
		"You morph and grow a [lowertext(taur_name)]!", \
		"[target] makes horrible squelching noises.")

// Add to loadout
/datum/loadout_item/taur_potion
	name = "Crurahol (Taur) Potion"
	path = /obj/item/taur_potion
