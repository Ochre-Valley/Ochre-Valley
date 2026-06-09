// OV FILE
#define PETRIFICATION_TRAIT_SOURCE "petrification"
#define PETRIFICATION_MATERIAL_STONE "Stone"
#define PETRIFICATION_MATERIAL_BRONZE "Bronze"
#define PETRIFICATION_MATERIAL_SILVER "Silver"
#define PETRIFICATION_MATERIAL_GOLD "Gold"
#define PETRIFICATION_DEFAULT_COLOR "#8a8f8d"
#define PETRIFICATION_COLOUR_PRIORITY TEMPORARY_COLOUR_PRIORITY
#define PETRIFICATION_COLOUR_FILTER "petrification_colour"
#define PETRIFICATION_CAST_TIME (5 SECONDS)
#define PETRIFICATION_PERMANENT_WARNING "This petrification cannot be undone by any normal means during the round."
#define PETRIFICATION_PERMANENT_HELP "Permanent means this petrification cannot be reversed for the duration of the round by any normal means."
#define PETRIFICATION_SENSITIVE_HELP "Sensitive means ERP panel actions may be performed on the petrified target, allowing them to feel pleasure and pain."
#define PETRIFICATION_PRESET_NAME_MAX 32
#define PETRIFICATION_TEXT_MAX 240
#define PETRIFICATION_TEXT_CAST_PUBLIC "cast_public"
#define PETRIFICATION_TEXT_CAST_SELF "cast_self"
#define PETRIFICATION_TEXT_CAST_TARGET "cast_target"
#define PETRIFICATION_TEXT_SELF_CAST_PUBLIC "self_cast_public"
#define PETRIFICATION_TEXT_SELF_CAST_SELF "self_cast_self"
#define PETRIFICATION_TEXT_CAST_BREAK_SELF "cast_break_self"
#define PETRIFICATION_TEXT_CAST_BREAK_TARGET "cast_break_target"
#define PETRIFICATION_TEXT_SELF_CAST_BREAK_SELF "self_cast_break_self"
#define PETRIFICATION_TEXT_APPLY_PUBLIC "apply_public"
#define PETRIFICATION_TEXT_APPLY_PUBLIC_PETRIFIER "apply_public_petrifier"
#define PETRIFICATION_TEXT_APPLY_SELF "apply_self"
#define PETRIFICATION_TEXT_SELF_APPLY_PUBLIC "self_apply_public"
#define PETRIFICATION_TEXT_SELF_APPLY_SELF "self_apply_self"
#define PETRIFICATION_TEXT_EXAMINE "examine"
#define PETRIFICATION_TEXT_TOKEN_HELP "Available tokens: {caster}, {target}, {material}, {caster_they}, {caster_them}, {caster_their}, {target_they}, {target_them}, {target_their}. For self-petrification, caster and target are both you. Examine text may also use SUBJECTPRONOUN. Type !default while editing a text field to reset only that field."
// Replace this no-op body with log_world("PETRIFY-DEBUG: [debug_message]") to re-enable the temporary audit probes.

/mob/living
	var/petrification_material = PETRIFICATION_MATERIAL_STONE
	var/petrification_color = PETRIFICATION_DEFAULT_COLOR
	var/petrification_permanent = FALSE
	var/petrification_sensitive = FALSE
	var/list/petrification_texts
	var/tmp/datum/status_effect/petrified/petrified_status_effect

/datum/preferences
	var/list/petrification_presets
	var/petrification_selected_name = PETRIFICATION_MATERIAL_STONE
	var/petrification_selected_color = PETRIFICATION_DEFAULT_COLOR
	var/petrification_permanent = FALSE
	var/petrification_sensitive = FALSE

/proc/default_petrification_texts()
	return list(
		PETRIFICATION_TEXT_CAST_PUBLIC = "{caster} focuses a petrifying gaze on {target}...",
		PETRIFICATION_TEXT_CAST_SELF = "I focus my petrifying gaze on {target}...",
		PETRIFICATION_TEXT_CAST_TARGET = "{caster}'s petrifying gaze locks onto me!",
		PETRIFICATION_TEXT_SELF_CAST_PUBLIC = "{caster} begins transforming {caster_them}self into {material}.",
		PETRIFICATION_TEXT_SELF_CAST_SELF = "I begin transforming myself into {material}.",
		PETRIFICATION_TEXT_CAST_BREAK_SELF = "My petrifying focus breaks.",
		PETRIFICATION_TEXT_CAST_BREAK_TARGET = "The petrifying pressure fades.",
		PETRIFICATION_TEXT_SELF_CAST_BREAK_SELF = "My self-petrification falters before it can take hold.",
		PETRIFICATION_TEXT_APPLY_PUBLIC = "{target} appears to have been transformed into a statue made from {material}.",
		PETRIFICATION_TEXT_APPLY_PUBLIC_PETRIFIER = "{target} appears to have been transformed into a statue made from {material} under {caster}'s petrifying gaze.",
		PETRIFICATION_TEXT_APPLY_SELF = "My limbs suddenly feel heavy, I can't move! Oh no, I've been petrified! I've been transformed into {material}!",
		PETRIFICATION_TEXT_SELF_APPLY_PUBLIC = "{target} finishes transforming {target_them}self into a statue made from {material}.",
		PETRIFICATION_TEXT_SELF_APPLY_SELF = "My body turns rigid and still as I finish transforming myself into {material}.",
		PETRIFICATION_TEXT_EXAMINE = "SUBJECTPRONOUN appears to have been transformed into a statue made from {material}.",
	)

/proc/petrification_text_keys()
	return list(
		PETRIFICATION_TEXT_CAST_PUBLIC,
		PETRIFICATION_TEXT_CAST_SELF,
		PETRIFICATION_TEXT_CAST_TARGET,
		PETRIFICATION_TEXT_SELF_CAST_PUBLIC,
		PETRIFICATION_TEXT_SELF_CAST_SELF,
		PETRIFICATION_TEXT_CAST_BREAK_SELF,
		PETRIFICATION_TEXT_CAST_BREAK_TARGET,
		PETRIFICATION_TEXT_SELF_CAST_BREAK_SELF,
		PETRIFICATION_TEXT_APPLY_PUBLIC,
		PETRIFICATION_TEXT_APPLY_PUBLIC_PETRIFIER,
		PETRIFICATION_TEXT_APPLY_SELF,
		PETRIFICATION_TEXT_SELF_APPLY_PUBLIC,
		PETRIFICATION_TEXT_SELF_APPLY_SELF,
		PETRIFICATION_TEXT_EXAMINE,
	)

/proc/petrification_text_label(text_key)
	switch(text_key)
		if(PETRIFICATION_TEXT_CAST_PUBLIC)
			return "Cast start, seen by others"
		if(PETRIFICATION_TEXT_CAST_SELF)
			return "Cast start, seen by caster"
		if(PETRIFICATION_TEXT_CAST_TARGET)
			return "Cast start, seen by target"
		if(PETRIFICATION_TEXT_SELF_CAST_PUBLIC)
			return "Self-petrification start, seen by others"
		if(PETRIFICATION_TEXT_SELF_CAST_SELF)
			return "Self-petrification start, seen by self"
		if(PETRIFICATION_TEXT_CAST_BREAK_SELF)
			return "Cast interrupted, seen by caster"
		if(PETRIFICATION_TEXT_CAST_BREAK_TARGET)
			return "Cast interrupted, seen by target"
		if(PETRIFICATION_TEXT_SELF_CAST_BREAK_SELF)
			return "Self-petrification interrupted, seen by self"
		if(PETRIFICATION_TEXT_APPLY_PUBLIC)
			return "Petrified, seen by others"
		if(PETRIFICATION_TEXT_APPLY_PUBLIC_PETRIFIER)
			return "Petrified by caster, seen by others"
		if(PETRIFICATION_TEXT_APPLY_SELF)
			return "Petrified, seen by target"
		if(PETRIFICATION_TEXT_SELF_APPLY_PUBLIC)
			return "Self-petrification complete, seen by others"
		if(PETRIFICATION_TEXT_SELF_APPLY_SELF)
			return "Self-petrification complete, seen by self"
		if(PETRIFICATION_TEXT_EXAMINE)
			return "Examine text"
	return "[text_key]"

/proc/sanitize_petrification_text(text_value, default_value)
	if(!istext(text_value))
		text_value = default_value
	text_value = trim(strip_html_simple(text_value, PETRIFICATION_TEXT_MAX + 1))
	if(!length(text_value))
		return default_value
	return text_value

/proc/sanitize_petrification_texts(list/texts)
	var/list/defaults = default_petrification_texts()
	var/list/sanitized = list()
	for(var/text_key in petrification_text_keys())
		var/default_text = defaults[text_key]
		var/text_value = islist(texts) ? texts[text_key] : null
		sanitized[text_key] = sanitize_petrification_text(text_value, default_text)
	return sanitized

/proc/sanitize_petrification_preset(list/preset, fallback_name = PETRIFICATION_MATERIAL_STONE, fallback_color = PETRIFICATION_DEFAULT_COLOR)
	if(!islist(preset))
		preset = list()
	var/name = preset["name"]
	name = trim(strip_html_simple("[name]", PETRIFICATION_PRESET_NAME_MAX + 1))
	if(!length(name) || name == "null")
		name = fallback_name
	var/color = sanitize_hexcolor(preset["color"], 6, TRUE, fallback_color)
	preset["name"] = copytext(name, 1, PETRIFICATION_PRESET_NAME_MAX + 1)
	preset["color"] = color
	preset["texts"] = sanitize_petrification_texts(preset["texts"])
	return preset

/proc/default_petrification_presets()
	return list(
		sanitize_petrification_preset(list("name" = PETRIFICATION_MATERIAL_STONE, "color" = PETRIFICATION_DEFAULT_COLOR)),
		sanitize_petrification_preset(list("name" = PETRIFICATION_MATERIAL_BRONZE, "color" = "#b87333")),
		sanitize_petrification_preset(list("name" = PETRIFICATION_MATERIAL_SILVER, "color" = "#c0c0c0")),
		sanitize_petrification_preset(list("name" = PETRIFICATION_MATERIAL_GOLD, "color" = "#d4af37")),
	)

/datum/preferences/proc/sanitize_petrification_presets()
	var/list/sanitized = list()
	if(islist(petrification_presets))
		for(var/list/preset as anything in petrification_presets)
			if(!islist(preset))
				continue
			var/list/sanitized_preset = sanitize_petrification_preset(preset)
			if(!length(sanitized_preset["name"]))
				continue
			sanitized += list(sanitized_preset)
	if(!length(sanitized))
		sanitized = default_petrification_presets()
	petrification_presets = sanitized
	petrification_selected_name = trim(strip_html_simple("[petrification_selected_name]", PETRIFICATION_PRESET_NAME_MAX + 1))
	if(!length(petrification_selected_name))
		petrification_selected_name = sanitized[1]["name"]
	var/list/selected_preset
	for(var/list/preset as anything in sanitized)
		if(preset["name"] == petrification_selected_name)
			selected_preset = preset
			break
	if(!selected_preset)
		selected_preset = sanitized[1]
		petrification_selected_name = selected_preset["name"]
	petrification_selected_color = sanitize_hexcolor(selected_preset["color"], 6, TRUE, sanitized[1]["color"])

/datum/preferences/proc/get_selected_petrification_preset()
	sanitize_petrification_presets()
	for(var/list/preset as anything in petrification_presets)
		if(preset["name"] == petrification_selected_name)
			return preset
	return petrification_presets[1]

/datum/preferences/proc/get_selected_petrification_texts()
	var/list/preset = get_selected_petrification_preset()
	return petrification_copy_list(preset["texts"])

/datum/preferences/proc/get_petrification_presets()
	sanitize_petrification_presets()
	return petrification_presets

/mob/living/proc/load_petrification_selection_from_prefs()
	var/datum/preferences/prefs = client?.prefs
	if(!prefs)
		return
	prefs.sanitize_petrification_presets()
	petrification_material = prefs.petrification_selected_name
	petrification_color = prefs.petrification_selected_color
	petrification_permanent = prefs.petrification_permanent ? TRUE : FALSE
	petrification_sensitive = prefs.petrification_sensitive ? TRUE : FALSE
	petrification_texts = prefs.get_selected_petrification_texts()

/proc/petrification_format_message(message_template, mob/living/caster, mob/living/target, material)
	var/message = sanitize_petrification_text(message_template, "")
	if(!length(message))
		return ""
	message = replacetext(message, "{caster}", caster ? "[caster]" : "Someone")
	message = replacetext(message, "{target}", target ? "[target]" : "someone")
	message = replacetext(message, "{material}", material ? "[material]" : PETRIFICATION_MATERIAL_STONE)
	if(caster)
		message = replacetext(message, "{caster_they}", caster.p_they())
		message = replacetext(message, "{caster_them}", caster.p_them())
		message = replacetext(message, "{caster_their}", caster.p_their())
	if(target)
		message = replacetext(message, "{target_they}", target.p_they())
		message = replacetext(message, "{target_them}", target.p_them())
		message = replacetext(message, "{target_their}", target.p_their())
	return message

/mob/living/proc/get_petrification_render_color(include_hash = TRUE)
	var/default_color = include_hash ? "#8a8f8d" : "8a8f8d"
	var/render_color = petrification_color
	var/datum/status_effect/petrified/petrified = IsPetrified()
	if(petrified)
		render_color = petrified.material_color
	return sanitize_hexcolor(render_color, 6, include_hash, default_color)

/proc/petrification_material_color_matrix(material_color)
	var/render_color = sanitize_hexcolor(material_color, 6, TRUE, PETRIFICATION_DEFAULT_COLOR)
	var/red = hex2num(copytext(render_color, 2, 4)) / 255
	var/green = hex2num(copytext(render_color, 4, 6)) / 255
	var/blue = hex2num(copytext(render_color, 6, 8)) / 255
	if(!isnum(red) || !isnum(green) || !isnum(blue))
		return color_matrix_identity()
	return list(
		LUMA_R * red, LUMA_R * green, LUMA_R * blue, 0,
		LUMA_G * red, LUMA_G * green, LUMA_G * blue, 0,
		LUMA_B * red, LUMA_B * green, LUMA_B * blue, 0,
		0, 0, 0, 1,
		0, 0, 0, 0,
	)

/proc/petrification_apply_atom_material(atom/movable/target, list/material_matrix)
	if(!target || !islist(material_matrix))
		return
	target.add_atom_colour(material_matrix, PETRIFICATION_COLOUR_PRIORITY)
	target.remove_filter(PETRIFICATION_COLOUR_FILTER)
	target.add_filter(PETRIFICATION_COLOUR_FILTER, 50, color_matrix_filter(material_matrix))

/proc/petrification_remove_atom_material(atom/movable/target, list/material_matrix)
	if(!target)
		return
	if(material_matrix)
		target.remove_atom_colour(PETRIFICATION_COLOUR_PRIORITY, material_matrix)
	else
		target.remove_atom_colour(PETRIFICATION_COLOUR_PRIORITY)
	target.remove_filter(PETRIFICATION_COLOUR_FILTER)

/proc/petrification_debug(debug_message)
	return

/proc/petrification_debug_value(value)
	if(isnull(value))
		return "null"
	return "[value]"

/proc/petrification_debug_len(value)
	if(islist(value))
		return length(value)
	if(value)
		return 1
	return 0

/proc/petrification_debug_feature_value(mob/living/carbon/human/human_owner, feature_key)
	if(!human_owner?.dna || !human_owner.dna.features)
		return "null"
	return petrification_debug_value(human_owner.dna.features[feature_key])

/proc/petrification_debug_feature_summary(datum/bodypart_feature/feature)
	if(!feature)
		return "none"
	var/summary = "[feature.type] accessory=[petrification_debug_value(feature.accessory_colors)]"
	if(istype(feature, /datum/bodypart_feature/hair))
		var/datum/bodypart_feature/hair/hair_feature = feature
		summary += " hair=[petrification_debug_value(hair_feature.hair_color)] natural=[petrification_debug_value(hair_feature.natural_color)] dye=[petrification_debug_value(hair_feature.hair_dye_color)]"
	return summary

/proc/petrification_debug_organ_summary(obj/item/organ/organ)
	if(!organ)
		return "none"
	var/summary = "[organ.type] slot=[petrification_debug_value(organ.slot)] zone=[petrification_debug_value(organ.zone)] accessory=[petrification_debug_value(organ.accessory_colors)]"
	if(istype(organ, /obj/item/organ/eyes))
		var/obj/item/organ/eyes/current_eyes = organ
		summary += " eye=[petrification_debug_value(current_eyes.eye_color)] second=[petrification_debug_value(current_eyes.second_color)]"
	return summary

/proc/petrification_debug_bodypart_summary(obj/item/bodypart/bodypart)
	if(!bodypart)
		return "none"
	var/first_feature = "none"
	for(var/datum/bodypart_feature/feature as anything in bodypart.bodypart_features)
		first_feature = petrification_debug_feature_summary(feature)
		break
	var/head_summary = ""
	if(istype(bodypart, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/head = bodypart
		head_summary = " head_hair=[petrification_debug_value(head.hair_color)] head_facial=[petrification_debug_value(head.facial_hair_color)] lip=[petrification_debug_value(head.lip_color)] head_eyes=([petrification_debug_organ_summary(head.eyes)])"
	var/taur_summary = ""
	if(istype(bodypart, /obj/item/bodypart/taur))
		var/obj/item/bodypart/taur/taur = bodypart
		taur_summary = " taur_color=[petrification_debug_value(taur.taur_color)] has_taur_color=[taur.has_taur_color] taur_state=[petrification_debug_value(taur.taur_icon_state)]"
	return "[bodypart.type] zone=[bodypart.body_zone] status=[bodypart.status] petrify_render=[petrification_debug_value(bodypart.petrification_render_color)] skin=[petrification_debug_value(bodypart.skin_tone)] species=[petrification_debug_value(bodypart.species_color)] mutation=[petrification_debug_value(bodypart.mutation_color)] grey=[bodypart.should_draw_greyscale][head_summary][taur_summary] features=[petrification_debug_len(bodypart.bodypart_features)] first_feature=([first_feature])"

/proc/petrification_debug_human_state(stage, mob/living/carbon/human/human_owner)
	if(!human_owner)
		petrification_debug("[stage]: no human owner")
		return
	var/obj/item/organ/eyes/current_eyes = human_owner.getorganslot(ORGAN_SLOT_EYES)
	petrification_debug("[stage]: human=[key_name(human_owner)] type=[human_owner.type] petrified=[human_owner.IsPetrified()] material=[petrification_debug_value(human_owner.petrification_material)] render=[human_owner.get_petrification_render_color(TRUE)] color=[petrification_debug_value(human_owner.color)] atom_colours=[petrification_debug_len(human_owner.atom_colours)] filters=[petrification_debug_len(human_owner.filters)] icon_key=[petrification_debug_value(human_owner.icon_render_key)] hair=[petrification_debug_value(human_owner.hair_color)] facial=[petrification_debug_value(human_owner.facial_hair_color)] eye=[petrification_debug_value(human_owner.eye_color)] skin=[petrification_debug_value(human_owner.skin_tone)] lip=[petrification_debug_value(human_owner.lip_color)] dna_mcolor=[petrification_debug_feature_value(human_owner, "mcolor")] dna_mcolor2=[petrification_debug_feature_value(human_owner, "mcolor2")] dna_mcolor3=[petrification_debug_feature_value(human_owner, "mcolor3")] dna_eye=[petrification_debug_feature_value(human_owner, "eye_color")] getter_hair=[petrification_debug_value(human_owner.get_hair_color())] getter_facial=[petrification_debug_value(human_owner.get_facial_hair_color())] getter_eye=[petrification_debug_value(human_owner.get_eye_color())] eyes=([petrification_debug_organ_summary(current_eyes)]) bodyparts=[petrification_debug_len(human_owner.bodyparts)] organs=[petrification_debug_len(human_owner.internal_organs)] visible_organs=[petrification_debug_len(human_owner.visible_organs)]")

/mob/living/verb/vore_player()
	set name = "Vore Player"
	set desc = "Attempt to eat an adjacent player."
	set category = "Vore"

	if(stat)
		to_chat(src,span_warning("You can't do that right now."))
		return
	if(IsPetrified())
		to_chat(src, span_warning("I can't do that while petrified."))
		return
	if(restrained(FALSE))
		to_chat(src,span_warning("You can't do that while restrained."))
		return
	if(IsSleeping())
		to_chat(src,span_warning("You can't do that while sleeping."))
		return
	if(!isturf(loc))
		to_chat(src,span_warning("You need to be on the open ground to do that."))
		return
	
	var/list/potential_targets = list()

	for(var/mob/living/L in view(1))
		if(L == src)	//Don't eat yourself
			continue
		if(!isliving(L))	//Only target living
			continue
		if(!vore_pref_compat(src,L))
			continue
		potential_targets |= L
	
	for(var/thing in contents)
		if(!istype(thing,/obj/item/holder/micro))	//U can also eat players in your hand
			continue
		var/obj/item/holder/micro/M = thing
		if(M.held_mob == src)
			continue
		if(!vore_pref_compat(src,M.held_mob))
			continue
	
		potential_targets |= M.held_mob
		
	if(potential_targets.len <= 0)
		to_chat(src, span_warning("There are no valid targets in range."))
		return
	
	var/mob/living/choice = tgui_input_list(src,"Who would you like to eat?","Vore Target",potential_targets)

	if(!choice)
		return
	if(get_dist(get_turf(src),get_turf(choice)) > 1)
		to_chat(src, span_warn("\The [choice] is too far away."))
		return

	return feed_grabbed_to_self(src,choice)

/proc/vore_pref_compat(var/mob/living/pred,var/mob/living/prey,var/reject_combat = TRUE)	//The other vore check sends an admin log to complain about you eating people against their prefs, so I made this one quieter since it only happens when gathering a list of compatible targets
	if(!pred || !prey)
		return FALSE
	if(reject_combat)	//We probably shouldn't target people who are trying to fight you unless you want that.
		if(prey.cmode)
			return FALSE

	if(!prey.devourable)
		return FALSE
	
	return TRUE

/mob/living/verb/petrification()
	set name = "Petrification"
	set desc = "Petrify yourself or a nearby player."
	set category = "Vore"

	if(stat)
		to_chat(src, span_warning("You can't do that right now."))
		return
	if(cmode)
		to_chat(src, span_warning("I can't use petrification while in combat mode."))
		return
	if(IsPetrified())
		petrification_self_menu()
		return
	if(restrained(FALSE))
		to_chat(src, span_warning("You can't do that while restrained."))
		return
	if(IsSleeping())
		to_chat(src, span_warning("You can't do that while sleeping."))
		return
	if(!isturf(loc))
		to_chat(src, span_warning("You need to be on the open ground to do that."))
		return

	load_petrification_selection_from_prefs()
	while(TRUE)
		var/list/choices = list("Petrify", "Customize")
		if(length(get_petrification_reversal_targets()))
			choices += "Reverse"
		choices += "Cancel"
		var/petrification_prompt = "Petrify yourself or a nearby player using your current petrification options?"
		if(petrification_permanent)
			petrification_prompt += "\n\nWarning: " + PETRIFICATION_PERMANENT_WARNING
		var/choice = tgui_alert(src, petrification_prompt, "Petrification", choices)
		if(choice == "Customize")
			if(!configure_petrification())
				return
			continue
		if(choice == "Reverse")
			reverse_nearby_petrification()
			return
		if(choice == "Cancel" || !choice)
			return
		break

	var/list/potential_targets = get_petrification_targets()
	if(!length(potential_targets))
		to_chat(src, span_warning("There are no valid petrification targets in range."))
		return

	var/list/target_choices = list()
	var/list/target_by_choice = list()
	var/target_number = 1
	for(var/mob/living/carbon/human/potential_target as anything in potential_targets)
		var/target_label = "[target_number]. [potential_target][potential_target == src ? " (YOU)" : ""]"
		target_choices += target_label
		target_by_choice[target_label] = potential_target
		target_number++
	var/target_choice = tgui_input_list(src, "Who would you like to petrify?", "Petrification Target", target_choices)
	var/mob/living/carbon/human/target = target_by_choice[target_choice]
	if(!target)
		return
	if(!can_petrify_target(target, TRUE))
		return
	if(target == src && petrification_permanent)
		var/self_confirm = tgui_alert(src, "WARNING: This is permanent self-petrification. You will not be able to turn yourself back with Reverse.\n\nContinue?", "Permanent Self-Petrification", list("Continue", "Cancel"))
		if(self_confirm != "Continue")
			return
	if(!request_petrification_consent(target))
		return

	var/cast_material = petrification_material
	var/cast_color = petrification_color
	var/cast_permanent = petrification_permanent
	var/cast_sensitive = petrification_sensitive
	var/list/cast_texts = sanitize_petrification_texts(petrification_texts)
	var/self_petrification = (target == src)

	if(self_petrification)
		visible_message(span_warning(petrification_format_message(cast_texts[PETRIFICATION_TEXT_SELF_CAST_PUBLIC], src, target, cast_material)), span_warning(petrification_format_message(cast_texts[PETRIFICATION_TEXT_SELF_CAST_SELF], src, target, cast_material)))
	else
		visible_message(span_warning(petrification_format_message(cast_texts[PETRIFICATION_TEXT_CAST_PUBLIC], src, target, cast_material)), span_warning(petrification_format_message(cast_texts[PETRIFICATION_TEXT_CAST_SELF], src, target, cast_material)))
		to_chat(target, span_userdanger(petrification_format_message(cast_texts[PETRIFICATION_TEXT_CAST_TARGET], src, target, cast_material)))
	if(!do_after(src, PETRIFICATION_CAST_TIME, needhand = FALSE, target = target, progress = TRUE, extra_checks = CALLBACK(src, PROC_REF(can_continue_petrification_cast), target)))
		if(self_petrification)
			to_chat(src, span_warning(petrification_format_message(cast_texts[PETRIFICATION_TEXT_SELF_CAST_BREAK_SELF], src, target, cast_material)))
		else
			to_chat(src, span_warning(petrification_format_message(cast_texts[PETRIFICATION_TEXT_CAST_BREAK_SELF], src, target, cast_material)))
		if(!self_petrification && !QDELETED(target))
			to_chat(target, span_notice(petrification_format_message(cast_texts[PETRIFICATION_TEXT_CAST_BREAK_TARGET], src, target, cast_material)))
		return
	if(!can_petrify_target(target, TRUE))
		return

	var/datum/status_effect/petrified/effect = target.apply_status_effect(STATUS_EFFECT_PETRIFIED, cast_material, cast_color, cast_permanent, cast_sensitive, cast_texts, src)
	if(!effect)
		to_chat(src, span_warning("[target] is already petrified."))
		return
	play_petrification_cast_finish_effect(target, cast_color)
	log_game("[key_name(src)] petrified [key_name(target)] as [cast_material].")
	message_admins("[key_name_admin(src)] petrified [key_name_admin(target)] as [cast_material].")

/mob/living/proc/can_continue_petrification_cast(mob/living/carbon/human/target)
	if(QDELETED(target))
		return FALSE
	if(stat || cmode || IsPetrified() || restrained(FALSE) || IsSleeping() || !isturf(loc))
		return FALSE
	return can_petrify_target(target, FALSE)

/mob/living/proc/play_petrification_cast_finish_effect(mob/living/carbon/human/target, material_color)
	if(QDELETED(target))
		return
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return
	new /obj/effect/temp_visual/spell_impact(target_turf, material_color, SPELL_IMPACT_MEDIUM)
	playsound(target_turf, 'sound/magic/fleshtostone.ogg', 70, TRUE)

/mob/living/proc/petrification_self_menu()
	var/datum/status_effect/petrified/petrified = IsPetrified()
	if(!petrified)
		return
	var/list/choices = list()
	var/can_reverse_self = can_reverse_petrification(src, FALSE)
	if(can_reverse_self)
		choices += "Reverse"
	choices += list("Surrender", "Cancel")
	var/prompt = "You are petrified."
	if(can_reverse_self)
		prompt += " Reverse will restore your body."
	prompt += " Surrender will separate your spirit from your petrified body. You may use Afterlife to return to the lobby; if you return as this character, the abandoned statue will dissolve."
	var/choice = tgui_alert(src, prompt, "Petrification", choices)
	if(choice == "Reverse")
		if(!can_reverse_petrification(src, TRUE))
			return
		var/confirm_reverse = tgui_alert(src, "Reverse your petrification?", "Reverse Petrification", list("Yes", "No"))
		if(confirm_reverse != "Yes")
			return
		remove_status_effect(STATUS_EFFECT_PETRIFIED)
		visible_message(span_notice("[src]'s petrified body softens back into living flesh."), span_notice("My petrified body softens back into living flesh."))
		log_game("[key_name(src)] reversed their own petrification.")
		message_admins("[key_name_admin(src)] reversed their own petrification.")
	else if(choice == "Surrender")
		var/confirm = tgui_alert(src, "Are you sure you want to surrender your petrified body and become a ghost?", "Confirm Surrender", list("Yes", "No"))
		if(confirm != "Yes")
			return
		petrification_surrender()

/mob/living/proc/request_petrification_consent(mob/living/carbon/human/target)
	if(target == src)
		return TRUE
	if(!target?.client)
		to_chat(src, span_warning("[target] is not able to consent right now."))
		return FALSE
	var/consent_prompt = "[src] wants to petrify you. Do you consent to this?"
	if(petrification_permanent)
		consent_prompt += "\n\nWarning: " + PETRIFICATION_PERMANENT_WARNING
	var/choice = tgui_alert(target, consent_prompt, "Petrification Consent", list("Yes", "No"))
	if(choice != "Yes")
		to_chat(src, span_warning("[target] declines petrification."))
		if(target)
			to_chat(target, span_notice("You decline [src]'s petrification."))
		return FALSE
	if(!can_petrify_target(target, TRUE))
		return FALSE
	return TRUE

/mob/living/proc/configure_petrification()
	var/datum/preferences/prefs = client?.prefs
	while(TRUE)
		var/material_choice = "Preset: [petrification_material]"
		var/permanent_choice = "Permanent: [petrification_permanent ? "Yes" : "No"] (?)"
		var/sensitive_choice = "Sensitive: [petrification_sensitive ? "Yes" : "No"] (?)"
		var/list/descriptions = list()
		descriptions[permanent_choice] = PETRIFICATION_PERMANENT_HELP
		descriptions[sensitive_choice] = PETRIFICATION_SENSITIVE_HELP
		var/choice = tgui_input_list(src, "Customize petrification options.", "Petrification", list(material_choice, permanent_choice, sensitive_choice, "Done", "Cancel"), descriptions = descriptions)
		if(!choice || choice == "Cancel")
			return FALSE
		if(choice == material_choice)
			configure_petrification_material()
		else if(choice == permanent_choice)
			petrification_permanent = !petrification_permanent
			if(prefs)
				prefs.petrification_permanent = petrification_permanent
				prefs.save_character()
		else if(choice == sensitive_choice)
			petrification_sensitive = !petrification_sensitive
			if(prefs)
				prefs.petrification_sensitive = petrification_sensitive
				prefs.save_character()
		else if(choice == "Done")
			return TRUE

/mob/living/proc/configure_petrification_material()
	var/datum/preferences/prefs = client?.prefs
	if(!prefs)
		return configure_petrification_material_legacy()
	while(TRUE)
		var/list/presets = prefs.get_petrification_presets()
		var/list/choices = list()
		var/list/preset_by_choice = list()
		var/preset_number = 1
		for(var/list/preset as anything in presets)
			var/preset_name = preset["name"]
			var/preset_color = preset["color"]
			var/label = "[preset_number]. [preset_name] ([preset_color])"
			preset_number++
			choices += label
			preset_by_choice[label] = preset
		choices += list("Add Preset", "Edit Preset", "Remove Preset", "Back")
		var/choice = tgui_input_list(src, "Choose or manage a petrification preset.", "Petrification Preset", choices)
		if(!choice || choice == "Back")
			return
		if(preset_by_choice[choice])
			var/list/preset = preset_by_choice[choice]
			apply_petrification_preset_selection(prefs, preset)
			prefs.save_character()
			return
		if(choice == "Add Preset")
			var/list/new_preset = create_petrification_preset(prefs)
			if(new_preset)
				prefs.petrification_presets += list(new_preset)
				apply_petrification_preset_selection(prefs, new_preset)
				edit_petrification_preset(prefs, new_preset)
				prefs.save_character()
		else if(choice == "Edit Preset")
			var/list/preset = choose_petrification_preset(prefs, "Edit which preset?")
			if(!preset)
				continue
			edit_petrification_preset(prefs, preset)
		else if(choice == "Remove Preset")
			if(length(presets) <= 1)
				to_chat(src, span_warning("You need at least one petrification preset."))
				continue
			var/list/preset = choose_petrification_preset(prefs, "Remove which preset?")
			if(!preset)
				continue
			var/removed_selected = (prefs.petrification_selected_name == preset["name"])
			var/preset_index = prefs.petrification_presets.Find(preset)
			if(preset_index)
				prefs.petrification_presets.Cut(preset_index, preset_index + 1)
			prefs.sanitize_petrification_presets()
			if(removed_selected)
				apply_petrification_preset_selection(prefs, prefs.petrification_presets[1])
			prefs.save_character()

/mob/living/proc/configure_petrification_material_legacy()
	var/list/preset = input_petrification_preset(list("name" = petrification_material, "color" = petrification_color))
	if(!preset)
		return
	petrification_material = preset["name"]
	petrification_color = preset["color"]
	petrification_texts = preset["texts"]

/mob/living/proc/choose_petrification_preset(datum/preferences/prefs, prompt)
	var/list/presets = prefs.get_petrification_presets()
	var/list/choices = list()
	var/list/preset_by_choice = list()
	var/preset_number = 1
	for(var/list/preset as anything in presets)
		var/preset_name = preset["name"]
		var/preset_color = preset["color"]
		var/label = "[preset_number]. [preset_name] ([preset_color])"
		preset_number++
		choices += label
		preset_by_choice[label] = preset
	var/choice = tgui_input_list(src, prompt, "Petrification Preset", choices)
	return preset_by_choice[choice]

/mob/living/proc/apply_petrification_preset_selection(datum/preferences/prefs, list/preset)
	if(!prefs || !islist(preset))
		return
	sanitize_petrification_preset(preset)
	petrification_material = preset["name"]
	petrification_color = sanitize_hexcolor(preset["color"], 6, TRUE, PETRIFICATION_DEFAULT_COLOR)
	petrification_texts = petrification_copy_list(preset["texts"])
	prefs.petrification_selected_name = petrification_material
	prefs.petrification_selected_color = petrification_color

/mob/living/proc/create_petrification_preset(datum/preferences/prefs)
	var/base_name = "New Preset"
	var/new_name = base_name
	var/suffix = 2
	while(TRUE)
		var/name_taken = FALSE
		for(var/list/preset as anything in prefs.get_petrification_presets())
			if(preset["name"] == new_name)
				name_taken = TRUE
				break
		if(!name_taken)
			break
		new_name = "[base_name] [suffix]"
		suffix++
	var/new_color = petrification_color ? petrification_color : PETRIFICATION_DEFAULT_COLOR
	return sanitize_petrification_preset(list("name" = new_name, "color" = new_color, "texts" = default_petrification_texts()))

/mob/living/proc/edit_petrification_preset(datum/preferences/prefs, list/preset)
	if(!prefs || !islist(preset))
		return
	var/was_selected = (prefs.petrification_selected_name == preset["name"])
	sanitize_petrification_preset(preset)
	while(TRUE)
		var/preset_name = preset["name"]
		var/preset_color = preset["color"]
		var/help_choice = "Show Help"
		var/name_choice = "Name: [preset_name]"
		var/color_choice = "Colour: [preset_color]"
		var/reset_text_choice = "Reset All Text To Defaults"
		var/list/choices = list(help_choice, name_choice, color_choice)
		var/list/descriptions = list()
		descriptions[help_choice] = "Show available text tokens and reset shortcut."
		for(var/text_key in petrification_text_keys())
			var/label = "Text: [petrification_text_label(text_key)]"
			choices += label
			descriptions[label] = preset["texts"][text_key]
		choices += list(reset_text_choice, "Done")
		var/choice = tgui_input_list(src, "Edit [preset_name].", "Petrification Preset", choices, descriptions = descriptions)
		if(!choice || choice == "Done")
			break
		if(choice == help_choice)
			tgui_alert(src, PETRIFICATION_TEXT_TOKEN_HELP, "Petrification Text Help", list("Okay"))
		else if(choice == name_choice)
			var/new_name = tgui_input_text(src, "Preset name.", "Petrification Preset", preset_name, PETRIFICATION_PRESET_NAME_MAX, encode = FALSE, prevent_enter = TRUE)
			if(new_name)
				new_name = trim(strip_html_simple(new_name, PETRIFICATION_PRESET_NAME_MAX + 1))
				if(length(new_name))
					preset["name"] = new_name
		else if(choice == color_choice)
			var/new_color = tgui_color_picker(src, "Choose a colour for [preset_name].", "Petrification Colour", preset_color)
			if(new_color)
				preset["color"] = sanitize_hexcolor(new_color, 6, TRUE, PETRIFICATION_DEFAULT_COLOR)
		else if(choice == reset_text_choice)
			preset["texts"] = default_petrification_texts()
		else
			for(var/text_key in petrification_text_keys())
				if(choice == "Text: [petrification_text_label(text_key)]")
					edit_petrification_preset_text(preset, text_key)
					break
		sanitize_petrification_preset(preset)
		if(was_selected)
			apply_petrification_preset_selection(prefs, preset)
		prefs.save_character()
	if(was_selected)
		apply_petrification_preset_selection(prefs, preset)
	prefs.save_character()

/mob/living/proc/edit_petrification_preset_text(list/preset, text_key)
	var/list/defaults = default_petrification_texts()
	var/list/texts = sanitize_petrification_texts(preset["texts"])
	preset["texts"] = texts
	var/current_text = texts[text_key]
	var/default_text = defaults[text_key]
	var/new_text = tgui_input_text(src, "Enter text. Type !default to reset this field.", petrification_text_label(text_key), current_text, PETRIFICATION_TEXT_MAX, encode = FALSE, prevent_enter = TRUE)
	if(isnull(new_text))
		return
	new_text = trim(new_text)
	if(new_text == "!default")
		texts[text_key] = default_text
		return
	texts[text_key] = sanitize_petrification_text(new_text, default_text)

/mob/living/proc/input_petrification_preset(list/existing)
	var/current_name = existing ? existing["name"] : petrification_material
	var/current_color = existing ? existing["color"] : petrification_color
	var/new_name = tgui_input_text(src, "Preset name.", "Petrification Preset", current_name, PETRIFICATION_PRESET_NAME_MAX, encode = FALSE, prevent_enter = TRUE)
	if(!new_name)
		return null
	new_name = trim(strip_html_simple(new_name, PETRIFICATION_PRESET_NAME_MAX + 1))
	if(!length(new_name))
		return null
	var/new_color = tgui_color_picker(src, "Choose a colour for [new_name].", "Petrification Colour", current_color)
	if(!new_color)
		return null
	return sanitize_petrification_preset(list("name" = new_name, "color" = sanitize_hexcolor(new_color, 6, TRUE, PETRIFICATION_DEFAULT_COLOR), "texts" = existing ? existing["texts"] : petrification_texts))

/mob/living/proc/get_petrification_targets()
	var/list/potential_targets = list()
	var/mob/living/carbon/human/self_target
	if(istype(src, /mob/living/carbon/human))
		self_target = src
	if(self_target && can_petrify_target(self_target, FALSE))
		potential_targets |= self_target
	for(var/mob/living/carbon/human/H in view(1, src))
		if(can_petrify_target(H, FALSE))
			potential_targets |= H
	return potential_targets

/mob/living/proc/get_petrification_reversal_targets()
	var/list/potential_targets = list()
	for(var/mob/living/carbon/human/H in view(1, src))
		if(can_reverse_petrification(H, FALSE))
			potential_targets |= H
	return potential_targets

/mob/living/proc/get_grabbed_petrified_posture_grab(mob/living/carbon/human/target)
	for(var/obj/item/held_item as anything in held_items)
		if(!istype(held_item, /obj/item/grabbing))
			continue
		var/obj/item/grabbing/held_grab = held_item
		if(target && held_grab.grabbed != target)
			continue
		if(can_use_petrified_posture_grab(held_grab))
			return held_grab
	if(target?.grabbedby)
		for(var/obj/item/grabbing/target_grab as anything in target.grabbedby)
			if(target_grab.grabbee != src)
				continue
			if(can_use_petrified_posture_grab(target_grab))
				return target_grab

/mob/living/proc/can_use_petrified_posture_grab(obj/item/grabbing/grab, notify = FALSE)
	if(!grab || QDELETED(grab) || grab.grabbee != src)
		return FALSE
	var/mob/living/carbon/human/target = grab.grabbed
	if(!istype(target) || QDELETED(target))
		return FALSE
	if(!target.IsPetrified())
		if(notify)
			to_chat(src, span_warning("[target] is not petrified."))
		return FALSE
	if(target.stat == DEAD)
		if(notify)
			to_chat(src, span_warning("[target] is already dead."))
		return FALSE
	if(!target.grabbedby || !(grab in target.grabbedby))
		if(notify)
			to_chat(src, span_warning("I need to keep hold of [target]."))
		return FALSE
	var/turf/source_turf = get_turf(src)
	var/turf/target_turf = get_turf(target)
	if(!source_turf || !target_turf || get_dist(source_turf, target_turf) > 1)
		if(notify)
			to_chat(src, span_warning("\The [target] is too far away."))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/can_stash_petrified_torso()
	if(!IsPetrified())
		return FALSE
	if(!get_bodypart_shallow(BODY_ZONE_CHEST))
		return FALSE
	var/static/list/blocking_bodyparts = list(BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	for(var/body_zone in blocking_bodyparts)
		if(get_bodypart_shallow(body_zone))
			return FALSE
	return TRUE

/mob/living/get_pushed_pulled_atom()
	var/mob/living/carbon/human/target = pulling
	if(!istype(target) || QDELETED(target) || !target.IsPetrified())
		return ..()
	if(target.pulledby != src)
		return ..()
	var/has_grab = FALSE
	for(var/obj/item/held_item as anything in held_items)
		if(!istype(held_item, /obj/item/grabbing))
			continue
		var/obj/item/grabbing/held_grab = held_item
		if(held_grab.grabbed != target || held_grab.grabbee != src)
			continue
		if(target.grabbedby && (held_grab in target.grabbedby))
			has_grab = TRUE
			break
	if(!has_grab)
		return ..()
	return target

/mob/living/proc/set_grabbed_petrified_posture(obj/item/grabbing/grab, stand_target)
	if(!can_use_petrified_posture_grab(grab, TRUE))
		return
	var/mob/living/carbon/human/target = grab.grabbed
	if(stand_target)
		if(target.mobility_flags & MOBILITY_STAND)
			to_chat(src, span_notice("[target] is already upright."))
			return
		if(target.get_num_legs(TRUE) < 2)
			to_chat(src, span_warning("[target] needs both legs to be stood upright."))
			return
		target.set_resting(FALSE, TRUE)
		if(!(target.mobility_flags & MOBILITY_STAND))
			to_chat(src, span_warning("[target] cannot be stood upright right now."))
			return
		target.refresh_petrified_visual_state()
		playsound(target, 'sound/foley/toggleup.ogg', 100, FALSE)
		target.visible_message(span_notice("[src] stands [target]'s petrified body upright."), span_notice("[src] stands my petrified body upright."))
		return
	if(!(target.mobility_flags & MOBILITY_STAND))
		to_chat(src, span_notice("[target] is already lying down."))
		return
	target.set_resting(TRUE, TRUE)
	if(target.mobility_flags & MOBILITY_STAND)
		to_chat(src, span_warning("[target] cannot be laid down right now."))
		return
	target.refresh_petrified_visual_state()
	playsound(target, 'sound/foley/toggledown.ogg', 100, FALSE)
	target.visible_message(span_notice("[src] lays [target]'s petrified body down."), span_notice("[src] lays my petrified body down."))

/mob/living/proc/can_petrify_target(mob/living/carbon/human/target, notify = FALSE)
	if(!target)
		return FALSE
	if(!istype(target, /mob/living/carbon/human))
		return FALSE
	if(!target.client)
		return FALSE
	if(target.stat == DEAD)
		if(notify)
			to_chat(src, span_warning("[target] is already dead."))
		return FALSE
	if(target.IsPetrified())
		if(notify)
			to_chat(src, span_warning("[target] is already petrified."))
		return FALSE
	if(target.cmode)
		if(notify)
			to_chat(src, span_warning("[target] is in combat mode."))
		return FALSE
	var/turf/source_turf = get_turf(src)
	var/turf/target_turf = get_turf(target)
	if(!source_turf || !target_turf || get_dist(source_turf, target_turf) > 1)
		if(notify)
			to_chat(src, span_warning("\The [target] is too far away."))
		return FALSE
	return TRUE

/mob/living/proc/can_reverse_petrification(mob/living/carbon/human/target, notify = FALSE)
	if(!target)
		return FALSE
	var/datum/status_effect/petrified/petrified = target.IsPetrified()
	if(!petrified)
		return FALSE
	if(petrified.petrifier != src)
		if(notify)
			to_chat(src, span_warning("I did not petrify [target]."))
		return FALSE
	if(petrified.permanent)
		if(notify)
			to_chat(src, span_warning("[target]'s petrification is permanent."))
		return FALSE
	var/turf/source_turf = get_turf(src)
	var/turf/target_turf = get_turf(target)
	if(!source_turf || !target_turf || get_dist(source_turf, target_turf) > 1)
		if(notify)
			to_chat(src, span_warning("\The [target] is too far away."))
		return FALSE
	return TRUE

/mob/living/proc/reverse_nearby_petrification()
	var/list/potential_targets = get_petrification_reversal_targets()
	if(!length(potential_targets))
		to_chat(src, span_warning("There are no reversible petrified victims nearby."))
		return
	var/mob/living/carbon/human/target = tgui_input_list(src, "Whose petrification would you like to reverse?", "Reverse Petrification", potential_targets)
	if(!target)
		return
	if(!can_reverse_petrification(target, TRUE))
		return
	var/confirm = tgui_alert(src, "Reverse [target]'s petrification?", "Reverse Petrification", list("Yes", "No"))
	if(confirm != "Yes")
		return
	target.remove_status_effect(STATUS_EFFECT_PETRIFIED)
	target.visible_message(span_notice("[target]'s petrified body softens back into living flesh."), span_notice("My petrified body softens back into living flesh."))
	log_game("[key_name(src)] reversed [key_name(target)]'s petrification.")
	message_admins("[key_name_admin(src)] reversed [key_name_admin(target)]'s petrification.")

/mob/living/proc/admin_remove_petrification()
	var/datum/status_effect/petrified/petrified = IsPetrified()
	if(!petrified)
		return FALSE
	petrified.permanent = FALSE
	remove_status_effect(STATUS_EFFECT_PETRIFIED)
	return !IsPetrified()

/mob/living/proc/is_petrified_sensitive()
	var/datum/status_effect/petrified/petrified = IsPetrified()
	return petrified?.sensitive

/mob/living/proc/petrification_statue_death(cause = "destroyed", mob/living/killer)
	var/datum/status_effect/petrified/petrified = IsPetrified()
	if(!petrified || stat == DEAD)
		return FALSE
	visible_message(span_danger("[src]'s petrified body is [cause]!"), span_userdanger("My petrified body is [cause]."))
	if(killer)
		log_game("[key_name(src)]'s petrified body was [cause] by [key_name(killer)].")
		message_admins("[key_name_admin(src)]'s petrified body was [cause] by [key_name_admin(killer)].")
	else
		log_game("[key_name(src)]'s petrified body was [cause].")
		message_admins("[key_name_admin(src)]'s petrified body was [cause].")
	death(FALSE)
	return TRUE

/mob/living/proc/petrification_leave_body()
	var/datum/status_effect/petrified/petrified = IsPetrified()
	if(!petrified || petrified.soul_departed)
		return
	if(!key)
		return
	petrified.soul_departed = TRUE
	visible_message(span_warning("[src]'s petrified body becomes cold and empty."), span_warning("I let go of my petrified body."))
	message_admins("[key_name_admin(src)] abandoned their petrified body.")
	log_game("[key_name(src)] abandoned their petrified body.")
	var/mob/dead/observer/ghost = ghostize(FALSE, ignore_zombie = TRUE)
	if(ghost)
		ghost.can_reenter_corpse = FALSE
	return ghost

/mob/living/proc/petrification_surrender()
	var/datum/status_effect/petrified/petrified = IsPetrified()
	if(!petrified)
		return
	if(!key)
		return
	petrified.surrendered_ckey = ckey(ckey)
	petrified.surrendered_character_name = real_name
	petrified.surrendered_base_character_name = client?.prefs?.real_name
	visible_message(span_warning("[src]'s spirit slips free of [p_their()] petrified body."), span_warning("I surrender my petrified body and drift free."))
	message_admins("[key_name_admin(src)] surrendered their petrified body.")
	log_game("[key_name(src)] surrendered their petrified body.")
	var/mob/dead/observer/ghost = ghostize(TRUE, ignore_zombie = TRUE)
	if(ghost)
		ghost.can_reenter_corpse = TRUE
	return ghost

/proc/petrification_names_match(round_name, base_name)
	round_name = trim("[round_name]")
	base_name = trim("[base_name]")
	if(!length(round_name) || !length(base_name))
		return FALSE
	if(round_name == base_name)
		return TRUE
	if(length(round_name) <= length(base_name))
		return FALSE
	return findtextEx(round_name, " [base_name]", length(round_name) - length(base_name))

/proc/find_surrendered_petrified_body(rejoining_ckey, character_name)
	rejoining_ckey = ckey(rejoining_ckey)
	character_name = trim("[character_name]")
	if(!rejoining_ckey || !length(character_name))
		return null
	for(var/mob/living/carbon/human/body as anything in GLOB.mob_list)
		if(QDELETED(body) || body.stat == DEAD || body.key)
			continue
		var/datum/status_effect/petrified/petrified = body.IsPetrified()
		if(!petrified)
			continue
		if(petrified.surrendered_ckey != rejoining_ckey)
			continue
		if(petrified.surrendered_base_character_name && petrified.surrendered_base_character_name == character_name)
			return body
		if(!petrification_names_match(petrified.surrendered_character_name, character_name))
			continue
		return body
	return null

/proc/release_kink_death_role(mob/dead/observer/ghost)
	if(!ghost?.mind?.assigned_role)
		return FALSE
	var/mob/living/body = ghost.mind.current
	var/datum/status_effect/petrified/petrified
	if(istype(body))
		petrified = body.IsPetrified()
	var/surrendered_petrification = petrified?.surrendered_ckey && petrified.surrendered_ckey == ckey(ghost.ckey)
	if(!ghost.vore_death && !surrendered_petrification)
		return FALSE
	if(petrified?.role_released)
		return FALSE
	var/datum/job/old_job = SSjob.GetJob(ghost.mind.assigned_role)
	if(!old_job)
		return FALSE
	old_job.current_positions = max(0, old_job.current_positions - 1)
	if(petrified)
		petrified.role_released = TRUE
	message_admins("[key_name_admin(ghost)] left after a kink death, freeing [old_job.title].")
	log_game("[key_name(ghost)] left after a kink death, freeing [old_job.title].")
	return TRUE

/proc/cleanup_surrendered_petrified_body(rejoining_ckey, character_name, mob/living/new_character)
	var/mob/living/carbon/human/body = find_surrendered_petrified_body(rejoining_ckey, character_name)
	if(!body)
		return FALSE
	if(body == new_character)
		return FALSE
	var/turf/body_turf = get_turf(body)
	body.visible_message(span_notice("[body]'s abandoned statue abruptly dissolves away in a fine mist of glittering magical particles."))
	if(body_turf)
		new /obj/effect/temp_visual/spell_impact(body_turf, body.get_petrification_render_color(), SPELL_IMPACT_MEDIUM)
	message_admins("[key_name_admin(new_character)] returned as [character_name]; removing surrendered petrified body [body] belonging to [rejoining_ckey].")
	log_game("[key_name(new_character)] returned as [character_name]; removing surrendered petrified body [body] belonging to [rejoining_ckey].")
	qdel(body)
	return TRUE

/mob/living/proc/stabilize_petrified_body()
	bleed_rate = 0
	if(HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		for(var/datum/wound/wound as anything in simple_wounds)
			wound.set_bleed_rate(0)
		simple_bleeding = 0
	if(iscarbon(src))
		var/mob/living/carbon/carbon_owner = src
		carbon_owner.blood_volume = max(carbon_owner.blood_volume, BLOOD_VOLUME_NORMAL)
		carbon_owner.setOxyLoss(0, FALSE, TRUE)
		carbon_owner.setToxLoss(0, FALSE, TRUE)
		for(var/obj/item/bodypart/bodypart as anything in carbon_owner.bodyparts)
			for(var/datum/wound/wound as anything in bodypart.wounds)
				wound.set_bleed_rate(0)
			bodypart.bleeding = 0
	updatehealth()

/mob/living/proc/hide_petrified_action_buttons()
	if(!hud_used || !actions)
		return
	for(var/datum/action/action as anything in actions)
		var/atom/movable/screen/movable/action_button/button = action.viewers[hud_used]
		if(button)
			qdel(button)
			action.viewers -= hud_used
	update_action_buttons()

/mob/living/proc/clear_petrified_active_ability()
	if(!click_intercept)
		return
	if(istype(click_intercept, /datum/action/cooldown))
		var/datum/action/cooldown/active_ability = click_intercept
		active_ability.unset_click_ability(src, refund_cooldown = FALSE)
	else if(istype(click_intercept, /obj/effect/proc_holder/spell/invoked))
		var/obj/effect/proc_holder/spell/invoked/old_spell = click_intercept
		old_spell.deactivate(src)
	else if(istype(click_intercept, /obj/effect/proc_holder))
		var/obj/effect/proc_holder/old_proc = click_intercept
		old_proc.remove_ranged_ability()
	else
		click_intercept = null
	update_mouse_pointer()

/mob/living/proc/show_unpetrified_action_buttons()
	if(!hud_used || !actions)
		return
	for(var/datum/action/action as anything in actions)
		if(!action.viewers[hud_used])
			action.ShowTo(src)
	update_action_buttons()

/datum/petrification_appearance_state
	var/hair_color
	var/facial_hair_color
	var/eye_color
	var/skin_tone
	var/lip_color
	var/list/dna_features
	var/list/body_markings
	var/list/bodypart_feature_colors
	var/list/bodypart_render_values
	var/list/head_render_values
	var/list/organ_colors
	var/list/bodypart_statuses
	var/eye_organ_color
	var/eye_organ_second_color
	var/list/eye_organ_colors
	var/construct
	var/dullahan_viewing_head
	var/list/petrification_atom_colours

/proc/petrification_copy_list(list/source)
	if(!islist(source))
		return null
	var/list/copy = list()
	for(var/key in source)
		var/value = source[key]
		if(islist(value))
			value = petrification_copy_list(value)
		copy[key] = value
	return copy

/proc/petrification_recolor_markings(list/source, color)
	var/list/recolored = petrification_copy_list(source)
	if(!islist(recolored))
		return null
	for(var/zone in recolored)
		if(!islist(recolored[zone]))
			continue
		for(var/marking in recolored[zone])
			recolored[zone][marking] = color
	return recolored

/proc/petrification_recolor_color_string(color_string, color)
	var/list/colors = color_string_to_list(color_string)
	if(!length(colors))
		return color_string
	for(var/index in 1 to length(colors))
		colors[index] = color
	return color_list_to_string(colors)

/proc/petrification_get_bodyparts(mob/living/carbon/human/human_owner)
	var/list/affected_bodyparts = list()
	for(var/obj/item/bodypart/bodypart as anything in human_owner.bodyparts)
		affected_bodyparts |= bodypart
	if(isdullahan(human_owner))
		var/datum/species/dullahan/dullahan = human_owner.dna.species
		if(dullahan.my_head && !QDELETED(dullahan.my_head))
			affected_bodyparts |= dullahan.my_head
	return affected_bodyparts

/proc/petrification_get_organs(mob/living/carbon/human/human_owner, list/affected_bodyparts)
	var/list/affected_organs = list()
	for(var/obj/item/organ/organ as anything in human_owner.internal_organs)
		affected_organs |= organ
	for(var/obj/item/bodypart/bodypart as anything in affected_bodyparts)
		for(var/obj/item/organ/organ as anything in bodypart)
			affected_organs |= organ
		if(istype(bodypart, /obj/item/bodypart/head))
			var/obj/item/bodypart/head/head = bodypart
			if(head.eyes)
				affected_organs |= head.eyes
			if(head.eyesl)
				affected_organs |= head.eyesl
			if(head.ears)
				affected_organs |= head.ears
			if(head.tongue)
				affected_organs |= head.tongue
			if(head.brain)
				affected_organs |= head.brain
	return affected_organs

/proc/petrification_should_recolor_organ(obj/item/organ/organ)
	if(istype(organ, /obj/item/organ/soul))
		return FALSE
	return TRUE

/datum/status_effect/petrified/proc/store_petrified_bodypart_appearance(obj/item/bodypart/bodypart)
	if(!bodypart)
		return
	appearance_state.bodypart_statuses[bodypart] = bodypart.status
	appearance_state.bodypart_render_values[bodypart] = list(
		"petrification_render_color" = bodypart.petrification_render_color,
		"skin_tone" = bodypart.skin_tone,
		"species_color" = bodypart.species_color,
		"mutation_color" = bodypart.mutation_color,
	)
	if(istype(bodypart, /obj/item/bodypart/taur))
		var/obj/item/bodypart/taur/taur = bodypart
		var/list/render_values = appearance_state.bodypart_render_values[bodypart]
		render_values["taur_color"] = taur.taur_color
		render_values["has_taur_color"] = taur.has_taur_color
	if(istype(bodypart, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/head = bodypart
		appearance_state.head_render_values[head] = list(
			"hair_color" = head.hair_color,
			"facial_hair_color" = head.facial_hair_color,
			"lip_color" = head.lip_color,
		)
	if(!bodypart.bodypart_features)
		return
	for(var/datum/bodypart_feature/feature as anything in bodypart.bodypart_features)
		var/list/feature_colors = list("accessory_colors" = feature.accessory_colors)
		if(istype(feature, /datum/bodypart_feature/hair))
			var/datum/bodypart_feature/hair/hair_feature = feature
			feature_colors["hair_color"] = hair_feature.hair_color
			feature_colors["natural_color"] = hair_feature.natural_color
			feature_colors["hair_dye_color"] = hair_feature.hair_dye_color
		appearance_state.bodypart_feature_colors[feature] = feature_colors

/datum/status_effect/petrified/proc/recolor_petrified_bodypart(obj/item/bodypart/bodypart, material_color_with_hash, material_color_no_hash)
	if(!bodypart)
		petrification_debug("recolor_bodypart: skipped null bodypart color=[material_color_with_hash]")
		return
	petrification_debug("recolor_bodypart before: color=[material_color_with_hash] [petrification_debug_bodypart_summary(bodypart)]")
	bodypart.petrification_render_color = null
	bodypart.skin_tone = material_color_no_hash
	bodypart.species_color = material_color_no_hash
	bodypart.mutation_color = material_color_no_hash
	if(istype(bodypart, /obj/item/bodypart/taur))
		var/obj/item/bodypart/taur/taur = bodypart
		taur.has_taur_color = TRUE
		taur.taur_color = material_color_with_hash
	if(istype(bodypart, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/head = bodypart
		head.hair_color = material_color_with_hash
		head.facial_hair_color = material_color_with_hash
		head.lip_color = material_color_with_hash
		if(head.eyes)
			head.eyes.eye_color = material_color_with_hash
			head.eyes.second_color = material_color_with_hash
			head.eyes.update_accessory_colors()
	if(!bodypart.bodypart_features)
		petrification_debug("recolor_bodypart after-no-features: [petrification_debug_bodypart_summary(bodypart)]")
		return
	for(var/datum/bodypart_feature/feature as anything in bodypart.bodypart_features)
		petrification_debug("recolor_bodypart feature-before: bodypart=[bodypart.body_zone] [petrification_debug_feature_summary(feature)]")
		feature.accessory_colors = petrification_recolor_color_string(feature.accessory_colors, material_color_with_hash)
		if(istype(feature, /datum/bodypart_feature/hair))
			var/datum/bodypart_feature/hair/hair_feature = feature
			hair_feature.hair_color = material_color_with_hash
			hair_feature.natural_color = material_color_with_hash
			hair_feature.hair_dye_color = material_color_with_hash
		petrification_debug("recolor_bodypart feature-after: bodypart=[bodypart.body_zone] [petrification_debug_feature_summary(feature)]")
	petrification_debug("recolor_bodypart after: [petrification_debug_bodypart_summary(bodypart)]")

/datum/status_effect/petrified/proc/apply_petrification_atom_colour(atom/movable/target, material_color_with_hash)
	if(!target || !appearance_state)
		petrification_debug("atom_colour skipped: target=[petrification_debug_value(target)] appearance_state=[!!appearance_state] color=[material_color_with_hash]")
		return
	if(!appearance_state.petrification_atom_colours)
		appearance_state.petrification_atom_colours = list()
	var/list/previous_matrix = appearance_state.petrification_atom_colours[target]
	if(previous_matrix)
		petrification_remove_atom_material(target, previous_matrix)
	appearance_state.petrification_atom_colours -= target
	petrification_debug("atom_colour bypassed: target=[target] type=[target.type] source_color=[material_color_with_hash] removed_previous_matrix=[petrification_debug_len(previous_matrix)] target_color=[petrification_debug_value(target.color)] atom_colours=[petrification_debug_len(target.atom_colours)] filters=[petrification_debug_len(target.filters)] tracked_targets=[petrification_debug_len(appearance_state.petrification_atom_colours)]")

/mob/living/carbon/human/proc/get_petrified_view_head()
	var/datum/status_effect/petrified/petrified = IsPetrified()
	if(!petrified)
		return null
	var/obj/item/bodypart/head/view_head = petrified.petrified_view_head
	if(view_head && !QDELETED(view_head) && view_head.original_owner == src && view_head.owner != src)
		return view_head
	if(isdullahan(src))
		var/datum/species/dullahan/dullahan = dna?.species
		if(dullahan?.headless && dullahan.my_head && !QDELETED(dullahan.my_head))
			return dullahan.my_head
	return null

/mob/living/carbon/human/proc/get_petrified_head_view_target(obj/item/bodypart/head/view_head)
	if(!view_head || QDELETED(view_head))
		return null
	if(ishuman(view_head.loc) && view_head.loc != src)
		return view_head.loc
	return view_head

/mob/living/carbon/human/refresh_hearing_atom_override()
	var/atom/movable/hearing_atom
	var/datum/status_effect/petrified/petrified = IsPetrified()
	if(petrified)
		var/obj/item/bodypart/head/view_head = petrified.petrified_view_head
		if(view_head && !QDELETED(view_head) && view_head.original_owner == src && view_head.owner != src)
			hearing_atom = view_head
	if(!hearing_atom && isdullahan(src))
		var/datum/species/dullahan/dullahan = dna?.species
		if(dullahan?.headless && dullahan.my_head && !QDELETED(dullahan.my_head))
			hearing_atom = dullahan.my_head
	set_hearing_atom_override(hearing_atom)

/mob/living/carbon/human/get_message_origin()
	var/obj/item/bodypart/head/view_head = get_petrified_view_head()
	if(view_head)
		return get_petrified_head_view_target(view_head)
	return ..()

/obj/item/bodypart/head/proc/get_petrified_message_owner()
	var/mob/living/carbon/human/human_owner = ishuman(original_owner) ? original_owner : null
	if(human_owner?.get_petrified_view_head() == src)
		return human_owner
	return null

/obj/item/bodypart/head/is_character_message_origin()
	return !!get_petrified_message_owner()

/mob/living/carbon/human/reset_perspective(atom/A)
	var/obj/item/bodypart/head/view_head = get_petrified_view_head()
	if(view_head && (!A || A == src || A == loc))
		A = get_petrified_head_view_target(view_head)
	return ..(A)

/mob/living/carbon/human/get_remote_view_fullscreens(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/obj/item/bodypart/head/view_head = human_user.get_petrified_view_head()
		if(view_head?.loc == src)
			view_head.get_remote_view_fullscreens(user)
			return
	return ..()

/mob/living/carbon/human/proc/refresh_petrified_head_vision()
	var/datum/status_effect/petrified/petrified = IsPetrified()
	if(!petrified)
		refresh_hearing_atom_override()
		return FALSE
	var/obj/item/bodypart/head/view_head = get_petrified_view_head()
	if(!view_head)
		if(isdullahan(src))
			var/obj/item/organ/dullahan_vision/vision = getorganslot(ORGAN_SLOT_HUD)
			if(vision)
				vision.viewing_head = FALSE
		refresh_hearing_atom_override()
		reset_perspective()
		return FALSE
	petrified.petrified_view_head = view_head
	refresh_hearing_atom_override()
	if(isdullahan(src))
		var/obj/item/organ/dullahan_vision/vision = getorganslot(ORGAN_SLOT_HUD)
		if(vision)
			vision.viewing_head = TRUE
	var/atom/view_target = get_petrified_head_view_target(view_head)
	reset_perspective(view_target)
	petrification_debug("head_vision forced: owner=[key_name(src)] head=[view_head] head_loc=[petrification_debug_value(view_head.loc)] target=[petrification_debug_value(view_target)]")
	return TRUE

/mob/living/carbon/human/proc/force_petrified_head_vision(obj/item/bodypart/head/view_head)
	var/datum/status_effect/petrified/petrified = IsPetrified()
	if(!petrified || !view_head || QDELETED(view_head) || view_head.original_owner != src)
		return FALSE
	petrified.petrified_view_head = view_head
	return refresh_petrified_head_vision()

/mob/living/carbon/human/proc/clear_petrified_head_vision(obj/item/bodypart/head/view_head)
	var/datum/status_effect/petrified/petrified = IsPetrified()
	if(petrified && (!view_head || petrified.petrified_view_head == view_head))
		petrified.petrified_view_head = null
	if(isdullahan(src))
		var/obj/item/organ/dullahan_vision/vision = getorganslot(ORGAN_SLOT_HUD)
		if(vision)
			vision.viewing_head = FALSE
	refresh_hearing_atom_override()
	reset_perspective()

/datum/status_effect/petrified
	id = "petrified"
	duration = -1
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/petrified
	examine_text = "SUBJECTPRONOUN is petrified."
	var/material = PETRIFICATION_MATERIAL_STONE
	var/material_color = PETRIFICATION_DEFAULT_COLOR
	var/permanent = FALSE
	var/sensitive = FALSE
	var/soul_departed = FALSE
	var/list/flavour_texts
	var/mob/living/petrifier
	var/datum/petrification_appearance_state/appearance_state
	var/obj/item/bodypart/head/petrified_view_head
	var/surrendered_ckey
	var/surrendered_character_name
	var/surrendered_base_character_name
	var/role_released = FALSE

/datum/status_effect/petrified/on_creation(mob/living/new_owner, new_material, new_color, new_permanent, new_sensitive, list/new_flavour_texts, mob/living/new_petrifier)
	if(new_material)
		material = new_material
	material_color = sanitize_hexcolor(new_color, 6, TRUE, PETRIFICATION_DEFAULT_COLOR)
	permanent = new_permanent ? TRUE : FALSE
	sensitive = new_sensitive ? TRUE : FALSE
	flavour_texts = sanitize_petrification_texts(new_flavour_texts)
	petrifier = new_petrifier
	examine_text = petrification_format_message(flavour_texts[PETRIFICATION_TEXT_EXAMINE], new_petrifier, new_owner, material)
	petrification_debug("on_creation: owner=[petrification_debug_value(new_owner)] owner_type=[new_owner?.type] material=[material] color=[material_color] permanent=[permanent] sensitive=[sensitive] petrifier=[petrification_debug_value(new_petrifier)]")
	return ..()

/datum/status_effect/petrified/on_apply()
	. = ..()
	if(!.)
		petrification_debug("on_apply aborted by parent: owner=[petrification_debug_value(owner)]")
		return
	owner.petrified_status_effect = src
	petrification_debug("on_apply start: owner=[petrification_debug_value(owner)] type=[owner?.type] material=[material] color=[material_color]")
	if(ishuman(owner))
		petrification_debug_human_state("on_apply-before", owner)
	ADD_TRAIT(owner, TRAIT_NOPAIN, PETRIFICATION_TRAIT_SOURCE)
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, PETRIFICATION_TRAIT_SOURCE)
	ADD_TRAIT(owner, TRAIT_NODEATH, PETRIFICATION_TRAIT_SOURCE)
	ADD_TRAIT(owner, TRAIT_NOHARDCRIT, PETRIFICATION_TRAIT_SOURCE)
	ADD_TRAIT(owner, TRAIT_NOSOFTCRIT, PETRIFICATION_TRAIT_SOURCE)
	ADD_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, PETRIFICATION_TRAIT_SOURCE)
	ADD_TRAIT(owner, TRAIT_NOBREATH, PETRIFICATION_TRAIT_SOURCE)
	ADD_TRAIT(owner, TRAIT_TOXIMMUNE, PETRIFICATION_TRAIT_SOURCE)
	ADD_TRAIT(owner, TRAIT_STUNIMMUNE, PETRIFICATION_TRAIT_SOURCE)
	ADD_TRAIT(owner, TRAIT_NOHUNGER, PETRIFICATION_TRAIT_SOURCE)
	ADD_TRAIT(owner, TRAIT_INFINITE_ENERGY, PETRIFICATION_TRAIT_SOURCE)
	ADD_TRAIT(owner, TRAIT_EASYDISMEMBER, PETRIFICATION_TRAIT_SOURCE)
	owner.petrification_material = material
	owner.petrification_color = material_color
	apply_petrified_appearance()
	if(ishuman(owner))
		petrification_debug_human_state("on_apply-after-appearance", owner)
	owner.shifting = FALSE
	owner.unpixel_shift()
	owner.stabilize_petrified_body()
	owner.update_mobility()
	owner.clear_petrified_active_ability()
	owner.hide_petrified_action_buttons()
	var/self_petrification = (petrifier == owner)
	var/self_message_template = flavour_texts[PETRIFICATION_TEXT_APPLY_SELF]
	if(self_petrification)
		self_message_template = flavour_texts[PETRIFICATION_TEXT_SELF_APPLY_SELF]
	var/self_message = petrification_format_message(self_message_template, petrifier, owner, material)
	if(self_petrification)
		owner.visible_message(span_warning(petrification_format_message(flavour_texts[PETRIFICATION_TEXT_SELF_APPLY_PUBLIC], petrifier, owner, material)), span_userdanger(self_message))
	else if(petrifier)
		owner.visible_message(span_warning(petrification_format_message(flavour_texts[PETRIFICATION_TEXT_APPLY_PUBLIC_PETRIFIER], petrifier, owner, material)), span_userdanger(self_message))
	else
		owner.visible_message(span_warning(petrification_format_message(flavour_texts[PETRIFICATION_TEXT_APPLY_PUBLIC], petrifier, owner, material)), span_userdanger(self_message))
	var/petrified_notice = "You have been petrified and will no longer be able to move, speak, or take any meaningful actions until you have been restored to your former self."
	if(permanent)
		petrified_notice = "You have been permanently petrified and will no longer be able to move, speak, or take any meaningful actions. " + PETRIFICATION_PERMANENT_WARNING
	if(self_petrification && !permanent)
		petrified_notice += " You may click Petrification in the Vore panel and choose Reverse to restore yourself, or choose Surrender to leave your body behind and become a ghost."
	else
		petrified_notice += " You may choose to 'Surrender' by clicking the Petrification option in the Vore panel to leave your body behind and become a ghost."
	to_chat(owner, span_notice(petrified_notice))

/datum/status_effect/petrified/tick()
	owner?.stabilize_petrified_body()

/datum/status_effect/petrified/on_remove()
	var/mob/living/former_owner = owner
	var/missing_head = FALSE
	if(owner)
		owner.stabilize_petrified_body()
		if(iscarbon(owner))
			var/mob/living/carbon/carbon_owner = owner
			missing_head = !isdullahan(carbon_owner) && !carbon_owner.get_bodypart(BODY_ZONE_HEAD)
		REMOVE_TRAIT(owner, TRAIT_NOPAIN, PETRIFICATION_TRAIT_SOURCE)
		REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, PETRIFICATION_TRAIT_SOURCE)
		REMOVE_TRAIT(owner, TRAIT_NODEATH, PETRIFICATION_TRAIT_SOURCE)
		REMOVE_TRAIT(owner, TRAIT_NOHARDCRIT, PETRIFICATION_TRAIT_SOURCE)
		REMOVE_TRAIT(owner, TRAIT_NOSOFTCRIT, PETRIFICATION_TRAIT_SOURCE)
		REMOVE_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, PETRIFICATION_TRAIT_SOURCE)
		REMOVE_TRAIT(owner, TRAIT_NOBREATH, PETRIFICATION_TRAIT_SOURCE)
		REMOVE_TRAIT(owner, TRAIT_TOXIMMUNE, PETRIFICATION_TRAIT_SOURCE)
		REMOVE_TRAIT(owner, TRAIT_STUNIMMUNE, PETRIFICATION_TRAIT_SOURCE)
		REMOVE_TRAIT(owner, TRAIT_NOHUNGER, PETRIFICATION_TRAIT_SOURCE)
		REMOVE_TRAIT(owner, TRAIT_INFINITE_ENERGY, PETRIFICATION_TRAIT_SOURCE)
		REMOVE_TRAIT(owner, TRAIT_EASYDISMEMBER, PETRIFICATION_TRAIT_SOURCE)
		restore_petrified_appearance()
		owner.update_mobility()
	petrifier = null
	. = ..()
	if(former_owner)
		if(former_owner.petrified_status_effect == src)
			former_owner.petrified_status_effect = null
		if(ishuman(former_owner))
			var/mob/living/carbon/human/former_human = former_owner
			former_human.refresh_hearing_atom_override()
		former_owner.show_unpetrified_action_buttons()
		if(missing_head && former_owner.stat != DEAD)
			former_owner.visible_message(span_danger("[former_owner]'s restored body collapses without its head."), span_userdanger("The petrification reverses, but my head is gone!"))
			former_owner.death()
	return .

/datum/status_effect/petrified/proc/refresh_petrified_body_icons(mob/living/carbon/human/human_owner, petrified_color_override = null)
	if(!human_owner)
		petrification_debug("refresh_icons skipped: no human owner override=[petrification_debug_value(petrified_color_override)]")
		return
	petrification_debug("refresh_icons start: owner=[key_name(human_owner)] override=[petrification_debug_value(petrified_color_override)] old_key=[petrification_debug_value(human_owner.icon_render_key)] body_overlay_len=[petrification_debug_len(human_owner.overlays_standing[BODYPARTS_LAYER])]")
	petrification_debug_human_state("refresh-before", human_owner)
	human_owner.icon_render_key = null
	human_owner.update_body()
	human_owner.update_hair()
	human_owner.rebuild_obscured_flags()
	human_owner.update_body_parts(TRUE, petrified_color_override)
	human_owner.update_damage_overlays()
	human_owner.update_transform()
	petrification_debug("refresh_icons end: owner=[key_name(human_owner)] new_key=[petrification_debug_value(human_owner.icon_render_key)] body_overlay_len=[petrification_debug_len(human_owner.overlays_standing[BODYPARTS_LAYER])]")
	petrification_debug_human_state("refresh-after", human_owner)

/mob/living/carbon/human/proc/refresh_petrified_visual_state()
	var/datum/status_effect/petrified/petrified = IsPetrified()
	if(!petrified)
		return
	var/petrified_color_override = sanitize_hexcolor(petrified.material_color, 6, TRUE, PETRIFICATION_DEFAULT_COLOR)
	icon_render_key = null
	update_body()
	update_hair()
	rebuild_obscured_flags()
	update_inv_wear_id()
	update_inv_gloves()
	update_inv_shoes()
	update_inv_wear_mask()
	update_inv_head()
	update_inv_belt()
	update_inv_back()
	update_inv_pants()
	update_inv_armor()
	update_inv_pockets()
	update_inv_neck()
	update_inv_cloak()
	update_inv_shirt()
	update_inv_mouth()
	update_inv_wrists()
	update_inv_ears()
	update_inv_s_store()
	update_inv_hands()
	update_inv_handcuffed()
	update_inv_legcuffed()
	update_inv_glasses()
	update_body_parts(TRUE, petrified_color_override)
	update_damage_overlays()
	update_transform()
	if(loc)
		// Same-location movement invalidates the client appearance cache without visibly dragging the statue.
		doMove(loc)

/datum/status_effect/petrified/proc/deferred_petrified_appearance_refresh()
	if(!owner || QDELETED(owner) || owner.petrified_status_effect != src)
		var/qdeleted_state = owner ? QDELETED(owner) : "no-owner"
		petrification_debug("deferred_refresh aborted: owner=[petrification_debug_value(owner)] qdeleted=[qdeleted_state] current_status=[petrification_debug_value(owner?.petrified_status_effect)]")
		return
	petrification_debug("deferred_refresh running: owner=[petrification_debug_value(owner)]")
	apply_petrified_appearance(FALSE)

/datum/status_effect/petrified/proc/apply_petrified_appearance(schedule_deferred_refresh = TRUE)
	if(!ishuman(owner))
		petrification_debug("apply_appearance skipped: owner=[petrification_debug_value(owner)] type=[owner?.type] ishuman=FALSE")
		return
	var/mob/living/carbon/human/human_owner = owner
	var/material_color_with_hash = sanitize_hexcolor(material_color, 6, TRUE, PETRIFICATION_DEFAULT_COLOR)
	var/material_color_no_hash = sanitize_hexcolor(material_color, 6, FALSE, copytext(PETRIFICATION_DEFAULT_COLOR, 2))
	var/list/affected_bodyparts = petrification_get_bodyparts(human_owner)
	var/list/affected_organs = petrification_get_organs(human_owner, affected_bodyparts)
	petrification_debug("apply_appearance start: owner=[key_name(human_owner)] schedule_deferred=[schedule_deferred_refresh] material=[material] color_hash=[material_color_with_hash] color_no_hash=[material_color_no_hash] appearance_state=[!!appearance_state] bodyparts=[petrification_debug_len(affected_bodyparts)] organs=[petrification_debug_len(affected_organs)]")
	petrification_debug_human_state("apply-before", human_owner)

	if(!appearance_state)
		appearance_state = new()
		//appearance_state.construct = human_owner.construct //OV EDIT - No longer a thing?
		appearance_state.hair_color = human_owner.hair_color
		appearance_state.facial_hair_color = human_owner.facial_hair_color
		appearance_state.eye_color = human_owner.eye_color
		appearance_state.skin_tone = human_owner.skin_tone
		appearance_state.lip_color = human_owner.lip_color
		appearance_state.dna_features = petrification_copy_list(human_owner.dna?.features)
		appearance_state.body_markings = petrification_copy_list(human_owner.dna?.body_markings)
		appearance_state.bodypart_feature_colors = list()
		appearance_state.bodypart_render_values = list()
		appearance_state.head_render_values = list()
		appearance_state.bodypart_statuses = list()
		for(var/obj/item/bodypart/bodypart as anything in affected_bodyparts)
			store_petrified_bodypart_appearance(bodypart)
		appearance_state.organ_colors = list()
		for(var/obj/item/organ/organ as anything in affected_organs)
			appearance_state.organ_colors[organ] = organ.accessory_colors
		appearance_state.eye_organ_colors = list()
		for(var/obj/item/organ/organ as anything in affected_organs)
			if(!istype(organ, /obj/item/organ/eyes))
				continue
			var/obj/item/organ/eyes/stored_eyes = organ
			appearance_state.eye_organ_colors[stored_eyes] = list("eye_color" = stored_eyes.eye_color, "second_color" = stored_eyes.second_color)
		var/obj/item/organ/eyes/eyes = human_owner.getorganslot(ORGAN_SLOT_EYES)
		if(eyes)
			appearance_state.eye_organ_color = eyes.eye_color
			appearance_state.eye_organ_second_color = eyes.second_color
		if(isdullahan(human_owner))
			var/obj/item/organ/dullahan_vision/vision = human_owner.getorganslot(ORGAN_SLOT_HUD)
			appearance_state.dullahan_viewing_head = vision?.viewing_head
		petrification_debug("apply_appearance stored_originals: owner=[key_name(human_owner)] bodypart_states=[petrification_debug_len(appearance_state.bodypart_statuses)] feature_colors=[petrification_debug_len(appearance_state.bodypart_feature_colors)] organ_colors=[petrification_debug_len(appearance_state.organ_colors)] eye_organ_colors=[petrification_debug_len(appearance_state.eye_organ_colors)]")

	apply_petrification_atom_colour(human_owner, material_color_with_hash)
	for(var/obj/item/bodypart/bodypart as anything in affected_bodyparts)
		apply_petrification_atom_colour(bodypart, material_color_with_hash)
		recolor_petrified_bodypart(bodypart, material_color_with_hash, material_color_no_hash)
	human_owner.hair_color = material_color_with_hash
	human_owner.facial_hair_color = material_color_with_hash
	human_owner.eye_color = material_color_with_hash
	human_owner.skin_tone = material_color_no_hash
	human_owner.lip_color = material_color_with_hash
	if(human_owner.dna)
		human_owner.dna.features["mcolor"] = material_color_no_hash
		human_owner.dna.features["mcolor2"] = material_color_no_hash
		human_owner.dna.features["mcolor3"] = material_color_no_hash
		human_owner.dna.features["eye_color"] = material_color_with_hash
		if(human_owner.dna.body_markings)
			human_owner.dna.body_markings = petrification_recolor_markings(human_owner.dna.body_markings, material_color_no_hash)
			apply_markings_to_body_parts(human_owner.dna.body_markings, human_owner)
		human_owner.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
		human_owner.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
		human_owner.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
	petrification_debug_human_state("apply-after-human-dna", human_owner)

	for(var/obj/item/organ/organ as anything in affected_organs)
		petrification_debug("apply_appearance organ-before: should_recolor=[petrification_should_recolor_organ(organ)] [petrification_debug_organ_summary(organ)]")
		if(!petrification_should_recolor_organ(organ))
			continue
		organ.accessory_colors = petrification_recolor_color_string(organ.accessory_colors, material_color_with_hash)
		petrification_debug("apply_appearance organ-after: [petrification_debug_organ_summary(organ)]")
	for(var/obj/item/organ/organ as anything in affected_organs)
		if(!istype(organ, /obj/item/organ/eyes))
			continue
		var/obj/item/organ/eyes/current_eyes = organ
		petrification_debug("apply_appearance eyes-before: [petrification_debug_organ_summary(current_eyes)]")
		current_eyes.eye_color = material_color_with_hash
		current_eyes.second_color = material_color_with_hash
		current_eyes.update_accessory_colors()
		petrification_debug("apply_appearance eyes-after: [petrification_debug_organ_summary(current_eyes)]")
	if(isdullahan(human_owner))
		var/datum/species/dullahan/dullahan = human_owner.dna.species
		if(dullahan.my_head)
			dullahan.my_head.update_icon_dropped()
	human_owner.refresh_petrified_head_vision()

	petrification_debug_human_state("apply-before-refresh", human_owner)
	refresh_petrified_body_icons(human_owner, material_color_with_hash)
	petrification_debug_human_state("apply-after-refresh", human_owner)
	if(schedule_deferred_refresh)
		petrification_debug("apply_appearance scheduling deferred refresh: owner=[key_name(human_owner)]")
		addtimer(CALLBACK(src, PROC_REF(deferred_petrified_appearance_refresh)), 1, TIMER_DELETE_ME)

/datum/status_effect/petrified/proc/restore_petrified_appearance()
	if(!appearance_state || !ishuman(owner))
		appearance_state = null
		return
	var/mob/living/carbon/human/human_owner = owner
	if(appearance_state.petrification_atom_colours)
		for(var/atom/movable/target as anything in appearance_state.petrification_atom_colours)
			if(QDELETED(target))
				continue
			petrification_remove_atom_material(target, appearance_state.petrification_atom_colours[target])
	//human_owner.construct = appearance_state.construct //No longer a thing?
	human_owner.hair_color = appearance_state.hair_color
	human_owner.facial_hair_color = appearance_state.facial_hair_color
	human_owner.eye_color = appearance_state.eye_color
	human_owner.skin_tone = appearance_state.skin_tone
	human_owner.lip_color = appearance_state.lip_color
	if(human_owner.dna)
		if(appearance_state.dna_features)
			human_owner.dna.features = petrification_copy_list(appearance_state.dna_features)
		if(appearance_state.body_markings)
			human_owner.dna.body_markings = petrification_copy_list(appearance_state.body_markings)
			apply_markings_to_body_parts(human_owner.dna.body_markings, human_owner)
		human_owner.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
		human_owner.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
		human_owner.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
	if(appearance_state.bodypart_feature_colors)
		for(var/datum/bodypart_feature/feature as anything in appearance_state.bodypart_feature_colors)
			var/list/feature_colors = appearance_state.bodypart_feature_colors[feature]
			feature.accessory_colors = feature_colors["accessory_colors"]
			if(istype(feature, /datum/bodypart_feature/hair))
				var/datum/bodypart_feature/hair/hair_feature = feature
				hair_feature.hair_color = feature_colors["hair_color"]
				hair_feature.natural_color = feature_colors["natural_color"]
				hair_feature.hair_dye_color = feature_colors["hair_dye_color"]
	if(appearance_state.bodypart_render_values)
		for(var/obj/item/bodypart/bodypart as anything in appearance_state.bodypart_render_values)
			if(QDELETED(bodypart))
				continue
			var/list/render_values = appearance_state.bodypart_render_values[bodypart]
			bodypart.petrification_render_color = render_values["petrification_render_color"]
			bodypart.skin_tone = render_values["skin_tone"]
			bodypart.species_color = render_values["species_color"]
			bodypart.mutation_color = render_values["mutation_color"]
			if(istype(bodypart, /obj/item/bodypart/taur))
				var/obj/item/bodypart/taur/taur = bodypart
				taur.taur_color = render_values["taur_color"]
				taur.has_taur_color = render_values["has_taur_color"]
	if(appearance_state.head_render_values)
		for(var/obj/item/bodypart/head/head as anything in appearance_state.head_render_values)
			if(QDELETED(head))
				continue
			var/list/head_values = appearance_state.head_render_values[head]
			head.hair_color = head_values["hair_color"]
			head.facial_hair_color = head_values["facial_hair_color"]
			head.lip_color = head_values["lip_color"]
	if(appearance_state.bodypart_statuses)
		for(var/obj/item/bodypart/bodypart as anything in appearance_state.bodypart_statuses)
			if(QDELETED(bodypart))
				continue
			bodypart.change_bodypart_status(appearance_state.bodypart_statuses[bodypart], FALSE, FALSE)
	if(appearance_state.organ_colors)
		for(var/obj/item/organ/organ as anything in appearance_state.organ_colors)
			organ.accessory_colors = appearance_state.organ_colors[organ]
	if(appearance_state.eye_organ_colors)
		for(var/obj/item/organ/eyes/stored_eyes as anything in appearance_state.eye_organ_colors)
			var/list/eye_colors = appearance_state.eye_organ_colors[stored_eyes]
			stored_eyes.eye_color = eye_colors["eye_color"]
			stored_eyes.second_color = eye_colors["second_color"]
			stored_eyes.update_accessory_colors()
	var/obj/item/organ/eyes/eyes = human_owner.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.eye_color = appearance_state.eye_organ_color
		eyes.second_color = appearance_state.eye_organ_second_color
		eyes.update_accessory_colors()
	if(isdullahan(human_owner))
		var/datum/species/dullahan/dullahan = human_owner.dna.species
		if(dullahan.my_head)
			dullahan.my_head.update_icon_dropped()
		var/obj/item/organ/dullahan_vision/vision = human_owner.getorganslot(ORGAN_SLOT_HUD)
		if(vision)
			vision.viewing_head = dullahan.headless && appearance_state.dullahan_viewing_head
			if(vision.viewing_head && dullahan.my_head)
				human_owner.reset_perspective(dullahan.my_head)
			else
				human_owner.reset_perspective()
	else
		human_owner.clear_petrified_head_vision()
	petrified_view_head = null
	human_owner.dna?.species.handle_body(human_owner)
	human_owner.update_body()
	human_owner.update_hair()
	human_owner.update_body_parts(TRUE)
	appearance_state = null

/datum/status_effect/petrified/can_remove_status_effect()
	return !permanent

/atom/movable/screen/alert/status_effect/petrified
	name = "Petrified"
	desc = "Your body has been turned to inert material. You can emote, but speech is only silence."
	icon_state = "paralyze"

#undef PETRIFICATION_TRAIT_SOURCE
#undef PETRIFICATION_MATERIAL_STONE
#undef PETRIFICATION_MATERIAL_BRONZE
#undef PETRIFICATION_MATERIAL_SILVER
#undef PETRIFICATION_MATERIAL_GOLD
#undef PETRIFICATION_DEFAULT_COLOR
#undef PETRIFICATION_COLOUR_PRIORITY
#undef PETRIFICATION_COLOUR_FILTER
#undef PETRIFICATION_CAST_TIME
#undef PETRIFICATION_PERMANENT_HELP
#undef PETRIFICATION_SENSITIVE_HELP
#undef PETRIFICATION_PRESET_NAME_MAX
#undef PETRIFICATION_TEXT_MAX
#undef PETRIFICATION_TEXT_CAST_PUBLIC
#undef PETRIFICATION_TEXT_CAST_SELF
#undef PETRIFICATION_TEXT_CAST_TARGET
#undef PETRIFICATION_TEXT_CAST_BREAK_SELF
#undef PETRIFICATION_TEXT_CAST_BREAK_TARGET
#undef PETRIFICATION_TEXT_APPLY_PUBLIC
#undef PETRIFICATION_TEXT_APPLY_PUBLIC_PETRIFIER
#undef PETRIFICATION_TEXT_APPLY_SELF
#undef PETRIFICATION_TEXT_EXAMINE
#undef PETRIFICATION_TEXT_TOKEN_HELP
