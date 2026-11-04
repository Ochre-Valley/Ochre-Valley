#define TEMPEST_MODE_TWISTER "twister"
#define TEMPEST_MODE_DOWNDRAFT "downdraft"

/datum/action/cooldown/spell/tempest
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	name = "Tempest"
	desc = "Conjure a swirling storm to lash out at a targeted area. \
			Twister: Lacerating winds will swirl around the specified location for 10 seconds, leaving a small patch of safety within the storm's eye. \
			Downburst: Direct a raging gust of air from above to crash down upon a designated location, doing a burst of damage in a 3x3 area after a short delay"
	button_icon_state = "blade_storm"
	sound = 'sound/magic/scrapeblade.ogg'
	spell_color = GLOW_COLOR_WIND
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_AEROMANCY

	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Vortix!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_swingdelay_type = SWINGDELAY_PENALTY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 18 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_SAME_Z // Projectile that spawns persistent AOE - same-Z to prevent cross-floor cheese

	var/tempest_mode = TEMPEST_MODE_TWISTER
	/// How long the tempest persists
	var/tempest_duration = 10 SECONDS
	/// Damage per tick
	var/tempest_damage = SPELL_DMG(20)
	/// Radius of the damage ring (center tile is safe)
	var/tempest_radius = 1
	var/static/list/mode_labels = list(TEMPEST_MODE_TWISTER = "TWST", TEMPEST_MODE_DOWNDRAFT = "DRFT")
	var/blast_delay = 2 SECONDS
	var/blast_damage = SPELL_DMG(60)

/datum/action/cooldown/spell/tempest/Grant(mob/grant_to)
	. = ..()
	update_mode_maptext()

/datum/action/cooldown/spell/tempest/toggle_alt_mode(mob/user)
	tempest_mode = (tempest_mode == TEMPEST_MODE_TWISTER) ? TEMPEST_MODE_DOWNDRAFT : TEMPEST_MODE_TWISTER
	cooldown_time = (tempest_mode == TEMPEST_MODE_TWISTER) ? 18 SECONDS : 12 SECONDS
	invocations = (tempest_mode == TEMPEST_MODE_TWISTER) ? list("Vortix!") : list("Venti Conterite!")
	to_chat(user, span_notice("Tempest set to: [tempest_mode]."))
	update_mode_maptext()
	return TRUE

/datum/action/cooldown/spell/tempest/proc/update_mode_maptext()
	var/label = mode_labels[tempest_mode]
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(label)
		holder.maptext_x = 5
		holder.color = GLOW_COLOR_WIND

/datum/action/cooldown/spell/tempest/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(tempest_mode == TEMPEST_MODE_DOWNDRAFT)
		var/turf/target = get_turf(cast_on)
		if(!target)
			return FALSE
		do_downdraft(H, target)
	else
		do_twister(H, cast_on)
	return TRUE

/datum/action/cooldown/spell/tempest/proc/do_twister(mob/living/carbon/human/H, atom/aim)
	var/turf/origin = get_turf(H)
	if(!origin || !aim)
		return
	playsound(origin, 'sound/combat/hits/onstone/stonedeath.ogg', 80, TRUE)
	var/obj/projectile/magic/tempest_seed/T = new(origin)
	if(istype(T))
		T.spell_ref = src
	T.preparePixelProjectile(aim, H)
	T.fire()

/datum/action/cooldown/spell/tempest/proc/do_downdraft(mob/living/carbon/human/H, turf/center)
	if(!center)
		return
	for(var/turf/T in range(tempest_radius, center))
		if(T.density)
			continue
		new /obj/effect/temp_visual/telegraph/pillar/fadein(T, blast_delay)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(downdraft_erupt), center, H, tempest_radius, blast_damage, src, "Downdraft"), blast_delay)

/proc/downdraft_erupt(turf/epicenter, mob/living/carbon/human/caster, radius = 1, damage = 50, datum/action/cooldown/spell/guard_source, spell_name = "Downdraft")
	if(!epicenter)
		return
	playsound(epicenter, 'sound/magic/repulse.ogg', 90, TRUE, 4)
	for(var/turf/T in range(radius, epicenter))
		if(!(T in get_hear(radius, epicenter)))
			continue
		new /obj/effect/temp_visual/tempest(T)
		for(var/obj/structure/S in T)
			S.take_damage(damage, BRUTE, "slash", FALSE)
		for(var/mob/living/L in T.contents)
			if(L.anti_magic_check())
				L.visible_message(span_warning("The winds dissipates around [L]!"))
				playsound(T, 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(guard_source && !QDELETED(guard_source) && guard_source.spell_guard_check(L, TRUE))
				L.visible_message(span_warning("[L] braces against the blast!"))
				continue
			if(istype(caster) && !QDELETED(caster) && ishuman(L))
				if(arcyne_strike(caster, L, null, damage, caster.zone_selected, \
					BCLASS_CUT, spell_name = spell_name, \
					damage_type = BRUTE, \
					skip_animation = TRUE, SPELL_STRIKE_SCALING) == ARCYNE_STRIKE_WARDED)
					continue
			else
				L.adjustBruteLoss(SPELL_DMG_VS(L, damage))
				SEND_SIGNAL(L, COMSIG_ATOM_WAS_ATTACKED, caster, damage)

// --- Seed projectile — detonates into the cloud on impact ---

/obj/projectile/magic/tempest_seed
	name = "condensed tempest"
	icon_state = "declone"
	damage = 0
	nodamage = TRUE
	arcshot = TRUE
	speed = 3
	range = 7
	guard_deflectable = TRUE
	hitsound = 'sound/combat/hits/bladed/genstab (1).ogg'
	var/datum/action/cooldown/spell/spell_ref

/obj/projectile/magic/tempest_seed/on_hit(atom/target)
	. = ..()
	var/turf/impact = get_turf(target)
	if(impact)
		new /obj/effect/tempest(impact, firer, spell_ref)
	qdel(src)
	return BULLET_ACT_HIT

/obj/projectile/magic/tempest_seed/Range()
	. = ..()
	if(QDELETED(src))
		return
	if(range <= 0)
		var/turf/T = get_turf(src)
		if(T)
			new /obj/effect/tempest(T, spell_ref.owner, spell_ref)
		qdel(src)

// --- The persistent cloud effect ---

/obj/effect/tempest
	name = "tempest"
	desc = "A whirling storm of slicing winds!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	anchored = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER
	light_outer_range = 2
	light_color = GLOW_COLOR_WIND
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/mob/living/caster
	var/datum/action/cooldown/spell/source_spell
	var/ticks_remaining
	var/tick_damage = SPELL_DMG(20)
	var/effect_radius = 1
	var/list/daggers = list()
	var/targeted_zone = BODY_ZONE_CHEST

/obj/effect/tempest/Initialize(mapload, mob/living/summoner, datum/action/cooldown/spell/spell_ref)
	. = ..()
	caster = summoner
	if(!istype(caster) && isliving(spell_ref.owner)) //Fallback if passed caster isn't right
		caster = spell_ref.owner
	if(istype(caster) && caster.zone_selected)
		targeted_zone = caster.zone_selected
	source_spell = spell_ref

	// Pull values from the spell if available
	var/tempest_duration = 10 SECONDS
	if(istype(spell_ref, /datum/action/cooldown/spell/tempest))
		var/datum/action/cooldown/spell/tempest/IT = spell_ref
		tempest_duration = IT.tempest_duration
		tick_damage = IT.tempest_damage
		effect_radius = IT.tempest_radius

	ticks_remaining = tempest_duration / (1 SECONDS)

	// Spawn daggers at center then burst outward to surrounding tiles
	var/turf/center = get_turf(src)
	for(var/turf/T in range(effect_radius, center))
		if(T == center)
			continue
		// Spawn on center tile
		var/obj/effect/temp_visual/tempest/D = new(center, tempest_duration + 2 SECONDS, FALSE)
		daggers += D
		// Calculate pixel offset to destination tile
		var/dx = (T.x - center.x) * 32
		var/dy = (T.y - center.y) * 32
		// Slide outward over 3 ticks then start spinning
		animate(D, pixel_x = dx, pixel_y = dy, time = 3, easing = EASE_OUT)
		addtimer(CALLBACK(D, TYPE_PROC_REF(/obj/effect/temp_visual/tempest, start_spinning)), 3)

	playsound(src, 'sound/magic/scrapeblade.ogg', 80, TRUE)
	START_PROCESSING(SSprocessing, src)
	QDEL_IN(src, tempest_duration + 1 SECONDS)

/obj/effect/tempest/Destroy()
	caster = null
	source_spell = null
	QDEL_LIST(daggers)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/tempest/process(delta_time)
	if(ticks_remaining <= 0)
		qdel(src)
		return

	ticks_remaining--
	playsound(src, pick('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg'), 60, TRUE)

	var/turf/center = get_turf(src)
	for(var/turf/T in range(effect_radius, center))
		if(T == center)
			continue
		for(var/obj/structure/S in T)
			S.take_damage(tick_damage, BRUTE, "slash", FALSE)
		for(var/mob/living/L in T)
			if(L.anti_magic_check())
				continue
			if(source_spell?.spell_guard_check(L))
				ticks_remaining = max(0, ticks_remaining - 1)
				continue
			if(istype(caster) && !QDELETED(caster))
				if(arcyne_strike(caster, L, null, tick_damage, targeted_zone, BCLASS_CUT, spell_name = "Twister", damage_type = BRUTE, skip_animation = TRUE, exact_zone = TRUE, SPELL_STRIKE_SCALING) == ARCYNE_STRIKE_WARDED)
					continue
			else
				var/fallback_zone = check_zone(targeted_zone)
				var/armor_block = L.run_armor_check(fallback_zone, "slash", blade_dulling = BCLASS_CUT, damage = tick_damage, intdamfactor = SPELL_INTDAM(1), no_debuff = TRUE)
				L.apply_damage(SPELL_DMG_VS(L, tick_damage), BRUTE, fallback_zone, armor_block)
			new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOW_COLOR_METAL, SPELL_IMPACT_MEDIUM)

// --- Spinning dagger visual effect ---

/obj/effect/temp_visual/tempest
	name = "tempestous air"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "kinetic_blast"
	color = "#8CDD8C"
	duration = 1 SECONDS
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	randomdir = FALSE

/obj/effect/temp_visual/tempest/Initialize(mapload, custom_duration, start_spin = TRUE)
	if(custom_duration)
		duration = custom_duration
	. = ..()
	if(start_spin)
		SpinAnimation(5, -1, pick(TRUE, FALSE))

/obj/effect/temp_visual/tempest/proc/start_spinning()
	SpinAnimation(5, -1, pick(TRUE, FALSE))
