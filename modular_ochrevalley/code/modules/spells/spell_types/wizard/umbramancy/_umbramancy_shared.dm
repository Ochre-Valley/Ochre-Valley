//Using this so we don't need to touch upstream defines.
#define ASPECT_NAME_UMBRAMANCY "Darkness"
#define GLOW_COLOR_DARK "#A050A0"
#define DARKNESS_OVERLAY_COLOR rgb(176, 80, 176)
#define SHADOW_BURN_COOLDOWN (2 SECONDS)
#define SHADOW_BURN_KEY "shadow_burn"
#define SHADOW_GRACE_KEY "shadow_grace"
/datum/magic_aspect/umbramancy
	name = "Umbramancy"
	latin_name = "Maior Aspectus Umbrae"
	desc = "A first-order school focused on wielding the air itself as a weapon. \
			Utilizing arcyne force, Magi practicing Aeromancy conjure and shape vicious vicious winds to lacerate and devastate their foes. \
			Historically, Aeromancy has its roots spread far across the eastern reaches of Psydonia, from the deserts of Raneshen to the grass sea of Lingyue — now mainland Kazengun."
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_UMBRAMANCY
	school_color = GLOW_COLOR_DARK
	class_locked = TRUE
	binding_chants = list(
		"Invoco aeternos ventos!",
		"I call upon the winds from on high, descend!",
		"Aero, in me ligare!"
	)
	unbinding_chants = list(
		"Solvo ventos vinctam!",
		"I release the winds that ravage without, be calm.",
		"Aero, a me discede!"
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/shadow_bolt,
		/datum/action/cooldown/spell/projectile/shadowcrash,
		/datum/action/cooldown/spell/shadowbreach,
		/datum/action/cooldown/spell/living_shadow,
		/datum/action/cooldown/spell/darkvision,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE = /datum/action/cooldown/spell/nitefall,
		),
		"gefechtsgelehrter" = list(
			VARIANT_ADDITIVE = /datum/action/cooldown/spell/nocfall,
		),
	)

/proc/apply_darkness_stack(mob/living/target, stacks = 1, zone_override = null)
	if(!isliving(target))
		return
	if(target.has_status_effect(/datum/status_effect/debuff/darkness3)) //Max stacks, can't do anything more, sire
		return
	//new /obj/effect/temp_visual/scorch_flash(get_turf(target))
	var/final_tier = 0
	for(var/i in 1 to stacks)
		if(target.has_status_effect(/datum/status_effect/debuff/darkness2))
			target.remove_status_effect(/datum/status_effect/debuff/darkness2)
			target.apply_status_effect(/datum/status_effect/debuff/darkness3)
			final_tier = 3
			continue
		if(target.has_status_effect(/datum/status_effect/debuff/darkness1))
			target.remove_status_effect(/datum/status_effect/debuff/darkness1)
			target.apply_status_effect(/datum/status_effect/debuff/darkness2)
			final_tier = 2
			continue
		target.apply_status_effect(/datum/status_effect/debuff/darkness1)
		final_tier = max(final_tier, 1)
	switch(final_tier)
		if(1)
			target.balloon_alert_to_viewers("<font color='#B050B0'>Shadowed I</font>")
		if(2)
			target.balloon_alert_to_viewers("<font color='#B050B0'>Shadowed II</font>")
		if(3)
			target.balloon_alert_to_viewers("<font color='#B050B0'>Shadowed III</font>")

/proc/remove_darkness_stack(mob/living/target)
	if(!isliving(target))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/debuff/darkness3))
		target.remove_status_effect(/datum/status_effect/debuff/darkness3)
		target.apply_status_effect(/datum/status_effect/debuff/darkness2)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/darkness2))
		target.remove_status_effect(/datum/status_effect/debuff/darkness2)
		target.apply_status_effect(/datum/status_effect/debuff/darkness1)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/darkness1))
		target.remove_status_effect(/datum/status_effect/debuff/darkness1)
		return TRUE
	return FALSE

/proc/has_darkness_stacks(mob/living/target)
	if(!isliving(target))
		return FALSE
	return get_darkness_stacks(target) > 0

/proc/get_darkness_stacks(mob/living/target)
	if(!isliving(target))
		return 0
	if(target.has_status_effect(/datum/status_effect/debuff/darkness3))
		return 3
	if(target.has_status_effect(/datum/status_effect/debuff/darkness2))
		return 2
	if(target.has_status_effect(/datum/status_effect/debuff/darkness1))
		return 1
	return 0

/proc/remove_all_darkness_stacks(mob/living/target)
	if(!isliving(target))
		return
	target.remove_status_effect(/datum/status_effect/debuff/darkness3)
	target.remove_status_effect(/datum/status_effect/debuff/darkness2)
	target.remove_status_effect(/datum/status_effect/debuff/darkness1)

/datum/status_effect/debuff/darkness1
	id = "darkness1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/darkness1
	duration = 15 SECONDS

/atom/movable/screen/alert/status_effect/debuff/darkness1
	name = "Pervasive Darkness"
	desc = "An umbral veil settles over me."
	icon_state = "debuff"

/datum/status_effect/debuff/darkness1/on_apply()
	. = ..()
	owner.add_atom_colour(DARKNESS_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/darkness1/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, DARKNESS_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/darkness2
	id = "darkness2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/darkness2
	duration = 15 SECONDS

/atom/movable/screen/alert/status_effect/debuff/darkness2
	name = "Pervasive Darkness II"
	desc = "Dread creeps into my heart as darkness overtakes me."
	icon_state = "debuff"

/datum/status_effect/debuff/darkness2/on_apply()
	. = ..()
	owner.add_atom_colour(DARKNESS_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/darkness2/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, DARKNESS_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/darkness3
	id = "darkness3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/darkness3
	duration = 15 SECONDS

/atom/movable/screen/alert/status_effect/debuff/darkness3
	name = "Pervasive Darkness III"
	desc = "The darkness weighs heavy on me like a sheet of mail."
	icon_state = "debuff"

/datum/status_effect/debuff/darkness3/on_apply()
	. = ..()
	owner.add_atom_colour(DARKNESS_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/darkness3/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, DARKNESS_OVERLAY_COLOR)
	. = ..()

/obj/effect/temp_visual/umbral
	name = "umbral cloud"
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	duration = 1 SECONDS

/obj/effect/temp_visual/umbral_explosion
	name = "umbral explosion"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "void_blink_in"
	pixel_x = -32
	pixel_y = -32
	duration = 10

/obj/effect/lingering_shadows
	name = "lingering shadow"
	desc = "A miasma of swirling darkness."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	color = GLOW_COLOR_DARK
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_outer_range = 2
	light_color = GLOW_COLOR_DARK
	ai_path_weight = 15
	var/lifetime = 4 SECONDS
	var/tick_damage = SPELL_DMG(20)
	var/shadow_cooldown = 1 SECONDS
	/// Scorched stacks applied per burn
	var/stacks = 1
	var/list/burn_times
	var/datum/weakref/caster_ref
	var/aim_zone

/obj/effect/lingering_shadows/Initialize(mapload, life, mob/living/new_caster, aimed_zone)
	. = ..()
	if(life)
		lifetime = life
	if(new_caster)
		caster_ref = WEAKREF(new_caster)
	aim_zone = aimed_zone
	START_PROCESSING(SSobj, src)
	QDEL_IN(src, lifetime)

/obj/effect/lingering_shadows/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/lingering_shadows/Crossed(atom/movable/AM, oldLoc)
	. = ..()
	if(isliving(AM))
		var/mob/living/L = AM
		burn_occupant(L, is_displaced(L))

/obj/effect/lingering_shadows/process(seconds_per_tick)
	var/turf/T = get_turf(src)
	if(!isturf(T))
		return
	for(var/mob/living/L in T)
		burn_occupant(L, is_displaced(L))

/obj/effect/lingering_shadows/proc/is_displaced(mob/living/L)
	return !!(L.throwing || L.pulledby)

/obj/effect/lingering_shadows/proc/burn_occupant(mob/living/L, involuntary = FALSE)
	var/mob_key = REF(L)
	if(L.mob_timers[SHADOW_GRACE_KEY] && world.time < L.mob_timers[SHADOW_GRACE_KEY])
		return
	if(involuntary && L.mob_timers[SHADOW_BURN_KEY] && world.time < L.mob_timers[SHADOW_BURN_KEY])
		return
	else if(LAZYACCESS(burn_times, mob_key) && world.time < burn_times[mob_key])
		return
	L.mob_timers[SHADOW_BURN_KEY] = world.time + SHADOW_BURN_COOLDOWN
	LAZYSET(burn_times, mob_key, world.time + shadow_cooldown)
	if(involuntary)
		L.mob_timers[SHADOW_GRACE_KEY] = world.time + SHADOW_BURN_COOLDOWN
	var/hit_zone = aim_zone || BODY_ZONE_CHEST
	var/mob/living/carbon/human/caster = caster_ref?.resolve()
	if(istype(caster) && !QDELETED(caster))
		if(arcyne_strike(caster, L, null, tick_damage, hit_zone, BCLASS_BURN, spell_name = "lingering shadow", damage_type = BURN, skip_animation = TRUE, skip_message = TRUE, exact_zone = TRUE, SPELL_STRIKE_SCALING) == ARCYNE_STRIKE_WARDED)
			return
	else
		var/fallback_zone = check_zone(hit_zone)
		var/armor_block = L.run_armor_check(fallback_zone, "fire", blade_dulling = BCLASS_BURN, damage = tick_damage, intdamfactor = SPELL_INTDAM(1), no_debuff = TRUE)
		L.apply_damage(SPELL_DMG_VS(L, tick_damage), BURN, fallback_zone, armor_block)
	if(stacks)
		apply_darkness_stack(L, stacks, hit_zone)
	L.emote("pain", forced = TRUE)

//May move this to a more generalized file in the future. Patron locked aspects go here, though!
/*
/datum/patron/on_gain(mob/living/pious)
	. = ..()
	if(istype(src, /datum/patron/divine/noc) || istype(src, /datum/patron/inhumen/zizo))
		if(pious.mind && LAZYLEN(pious.mind.mage_aspect_config))
			pious.mind.mage_aspect_config["unlocked_aspects"] += list(/datum/magic_aspect/umbramancy)

/datum/patron/on_loss(mob/living/pious)
	. = ..()
	if(istype(src, /datum/patron/divine/noc) || istype(src, /datum/patron/inhumen/zizo))
		if(pious.mind && LAZYLEN(pious.mind.mage_aspect_config))
			pious.mind.mage_aspect_config["unlocked_aspects"] -= list(/datum/magic_aspect/umbramancy)
*/
//Just manually inject it, I guess?
/datum/aspect_picker/New()
	..()
	if(istype(owner.patron, /datum/patron/divine/noc) || istype(owner.patron, /datum/patron/inhumen/zizo))
		unlocked_aspects += list(/datum/magic_aspect/umbramancy)
#undef SHADOW_BURN_COOLDOWN
#undef SHADOW_BURN_KEY
#undef SHADOW_GRACE_KEY
