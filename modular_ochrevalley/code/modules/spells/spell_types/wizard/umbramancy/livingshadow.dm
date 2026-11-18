/datum/action/cooldown/spell/living_shadow
	name = "Living Shadow"
	desc = "Conjure a copy of your shadow at a distant location. The shade is fragile, immobile, and doesn't do anything on its own. When destroyed or struck with either Umbral Resonance or Umbral Flow, it releases potent, delayed bursts of darkness. \
	Using this spell while a shadow is active allows you to teleport to your shadow's location, consuming it in the process. If the shadow is destroyed or expires, the spell goes on full cooldown."
	button_icon = 'icons/mob/actions/vheslynspells.dmi'
	button_icon_state = "phaseroll"
	sound = 'sound/misc/portalactivate.ogg'
	spell_color = GLOW_COLOR_DARK
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_UMBRAMANCY
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_MOBILITY

	invocations = list("Umbra Vivens!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/structure/living_shadow/active_portal
	var/max_range = 7
	var/teleport_delay = 5
	var/burst_damage = SPELL_DMG(50)

/datum/action/cooldown/spell/living_shadow/before_cast(atom/cast_on)
	. = ..()
	. |= SPELL_NO_IMMEDIATE_COOLDOWN

/datum/action/cooldown/spell/living_shadow/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	// Recast while tether active - recall
	if(active_portal && !QDELETED(active_portal))
		var/turf/portal_turf = get_turf(active_portal)
		if(!portal_turf)
			to_chat(H, span_warning("My shadow has been unanchored!"))
			clear_portal()
			return FALSE
		if(H.pulledby || H.restrained() || H.buckled)
			to_chat(H, span_warning("I can't recall while restrained!"))
			return FALSE
		var/turf/caster_turf = get_turf(H)
		if(caster_turf.z != portal_turf.z)
			to_chat(H, span_warning("My shadow is on a different level!"))
			return FALSE
		if(get_dist(caster_turf, portal_turf) > max_range)
			to_chat(H, span_warning("Too far from my shadow!"))
			return FALSE
		H.visible_message(span_warning("An umbral veil surrounds [H]!"))
		playsound(get_turf(H), 'sound/magic/shadowstep.ogg', 50, TRUE)
		addtimer(CALLBACK(src, PROC_REF(do_recall), H), teleport_delay)
		return TRUE

	// First cast - anchor tether
	var/turf/T = get_turf(cast_on)
	if(!T || T.density)
		to_chat(H, span_warning("I cannot anchor my shadow to the [T]!"))
	active_portal = new /obj/structure/living_shadow(T, src)
	invocations = "Gradus Umbratus!"
	to_chat(H, span_notice("I anchor my shadow to the [T]."))
	playsound(T, 'sound/misc/portalactivate.ogg', 50, TRUE)
	reset_spell_cooldown()
	return FALSE

/datum/action/cooldown/spell/living_shadow/proc/do_recall(mob/living/carbon/human/user)
	if(QDELETED(user) || user.stat == DEAD)
		return
	if(!active_portal || QDELETED(active_portal))
		return
	var/turf/dest = get_turf(active_portal)
	if(!dest)
		return
	var/path_err = arcyne_validate_blink_path(get_turf(user), dest)
	if(path_err)
		to_chat(owner, span_warning(path_err))
		return FALSE

	var/turf/start = get_turf(user)
	var/obj/effect/after_image/img = new(start, 0, 0, 0, 0, 0.5 SECONDS, 2 SECONDS, 0)
	img.name = user.name
	img.appearance = user.appearance
	img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	img.alpha = 80
	QDEL_IN(img, 2 SECONDS)

	do_teleport(user, dest, channel = TELEPORT_CHANNEL_MAGIC)
	playsound(dest, 'sound/magic/blink.ogg', 50, TRUE)
	user.visible_message(
		span_warning("[user] is pulled back through the shadows!"),
		span_notice("My shadow pulls me back."))
	active_portal.parent_spell = null
	qdel(active_portal)
	active_portal = null
	StartCooldown(45 SECONDS)

/datum/action/cooldown/spell/living_shadow/proc/clear_portal()
	active_portal = null
	invocations = "Umbra Vivens!"
	StartCooldown()
	build_all_button_icons()

// --- Tether object ---

/obj/structure/living_shadow
	name = "living shadow"
	desc = "An umbramancer's shadow, anchored in place and given a trace of vitality by their magicks. Destroy it to sever the connection."
	icon = 'icons/effects/effects.dmi'
	icon_state = "static"
	color = GLOW_COLOR_DARK
	max_integrity = 35
	anchored = TRUE
	density = FALSE
	opacity = 0
	light_outer_range = 1
	break_sound = 'sound/magic/magic_nulled.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg')
	var/datum/action/cooldown/spell/living_shadow/parent_spell

/obj/structure/living_shadow/Initialize(mapload, datum/action/cooldown/spell/leyline_anchor/spell)
	. = ..()
	parent_spell = spell
	QDEL_IN(src, 20 SECONDS)

/obj/structure/living_shadow/Destroy()
	if(parent_spell)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(shadow_burst), parent_spell.owner, get_turf(src), parent_spell.burst_damage, 1)
		parent_spell.clear_portal()
		parent_spell = null
	return ..()

/proc/shadow_burst(mob/living/caster, turf/target, damage = SPELL_DMG(50), radius = 1)
	for(var/turf/Te in range(radius, target))
		new /obj/effect/temp_visual/telegraph/pillar/fadein(Te, 1 SECONDS)
	spawn(1 SECONDS)
		for(var/turf/T in range(radius, target))
			new /obj/effect/temp_visual/umbral(T)
			for(var/obj/machinery/light/rogue/Ls in T)
				if(Ls.on)
					Ls.extinguish()
			if(!T.density)
				new /obj/effect/lingering_shadows(T, 4 SECONDS, caster, caster.zone_selected)
			for(var/mob/living/L in T)
				if(L.stat == DEAD)
					continue
				if(L.anti_magic_check())
					continue
				if(L.guard_deflect_spell("Living Shadow", TRUE, caster, punish_caster = FALSE))
					continue
				if(arcyne_strike(caster, L, null, SPELL_DMG(50), BODY_ZONE_CHEST, \
					BCLASS_BURN, spell_name = "Living Shadow", \
					allow_shield_check = TRUE, damage_type = BURN, \
					skip_animation = TRUE, SPELL_STRIKE_SCALING) == ARCYNE_STRIKE_WARDED)
					continue
				new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOW_COLOR_DARK, SPELL_IMPACT_MEDIUM)
