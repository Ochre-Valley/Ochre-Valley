/datum/action/cooldown/spell/shadowbreach
	name = "Shadowbreach"
	desc = "Summon a persistent mass of umbral energies which will damage any who linger. \n \
	Breach: Designate an area to explode with a surge of volatile darkness after a small delay, leaving behind a pool of Lingering Shadows. The explosion will repeat and expand after an additional delay. Targets already hit take decreased damage. \n \
	Fountain: Conjure a pulsating crystal of darkness at a targeted location. It persists for 15 seconds, releasing damaging bursts every 3 seconds. When struck by Umbral Flow, Umbral Resonance, or upon its final burst, the Fountain will release a larger, more potent explosion."
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "leyline_anchor"
	sound = 'sound/misc/portalactivate.ogg'
	spell_color = GLOW_COLOR_DARK
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_UMBRAMANCY


	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Perruptio Umbrae!")
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_swingdelay_type = SWINGDELAY_PENALTY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	var/breach_damage = SPELL_DMG(60)
	var/obj/effect/umbralfount/active_fount
	current_mode = 1
	modes = list(
		list("name" = "Shadow Breach", "tag" = "BREACH",  "invocation" = "Perruptio Umbrae!", "cooldown" = 25 SECONDS),
		list("name" = "Umbral Fountain", "tag" = "FOUNT",  "invocation" = "Fons Obscurus!", "cooldown" = 30 SECONDS),
	)

/datum/action/cooldown/spell/shadowbreach/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	for(var/i in stats.Copy())
		if(findtext(i, "Damage:"))
			stats -= i
	stats += span_info("Damage: Shadow Breach [breach_damage] ([round(breach_damage*0.33)] on repeat hits)  / Umbral Fountain [SPELL_DMG(50)] ([SPELL_DMG(50*1.7)] when enhanced) ")
	return stats


/datum/action/cooldown/spell/shadowbreach/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/shadowbreach/apply_mode(index)
	..()
	var/list/mode = modes[index]
	invocations = list(mode["invocation"])
	cooldown_time = mode["cooldown"]

/datum/action/cooldown/spell/shadowbreach/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/aimed = get_turf(cast_on)
	if(!aimed)
		return FALSE
	if(current_mode == 1)
		INVOKE_ASYNC(src, PROC_REF(shadow_breach), aimed, telegraph_cardinal(owner.dir))
	else
		active_fount = new /obj/effect/umbralfount(aimed, owner)

/datum/action/cooldown/spell/shadowbreach/proc/get_pattern_offsets(flanks = 0)
	var/list/offs = list()
	for(var/d in -1 to 1)
		var/list/band = list(list(0, d))
		if(flanks > 0)
			for(var/s in 1 to flanks)
				band += list(list(-s, d), list(s, d))
		offs += band
	return offs

/datum/action/cooldown/spell/shadowbreach/proc/shadow_breach(turf/aimed, dir)
	var/list/hit = list()
	for(var/i in 0 to 2)
		var/list/target_turfs = telegraph_resolve_turfs(aimed, dir, get_pattern_offsets(i), TRUE)
		for(var/turf/T in target_turfs)
			new /obj/effect/temp_visual/telegraph/pillar/fadein(T, 1 SECONDS)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shadow_breach), target_turfs, hit, owner, breach_damage , owner.zone_selected, (8 - i) SECONDS), 1 SECONDS)
		sleep(1 SECONDS)

/proc/shadow_breach(list/turfs, list/hit, mob/living/carbon/human/caster, damage, aim_zone, shadow_duration = 8 SECONDS)
	playsound(turfs[1], 'sound/magic/soulshot.ogg', 100, TRUE, 5)
	for(var/turf/T in turfs)
		new /obj/effect/temp_visual/umbral(T)
		for(var/obj/machinery/light/rogue/Ls in T)
			if(Ls.on)
				Ls.extinguish()
		for(var/obj/effect/lingering_shadows/S in T)
			qdel(S)
		new /obj/effect/lingering_shadows(T, shadow_duration, caster, aim_zone)
		for(var/mob/living/L in T)
			var/mult = (L in hit) ? 0.333 : 1
			if(L.stat == DEAD)
				continue
			if(L.anti_magic_check())
				continue
			if(L.guard_deflect_spell("Shadow Breach", TRUE, caster, punish_caster = FALSE)) //Punish the initial hit, not any riders
				continue
			if(istype(caster) && !QDELETED(caster))
				if(arcyne_strike(caster, L, null, damage * mult, aim_zone || BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "shadow breach", damage_type = BURN, skip_animation = TRUE, exact_zone = TRUE, SPELL_STRIKE_SCALING) == ARCYNE_STRIKE_WARDED)
					continue
			else
				L.adjustFireLoss(SPELL_DMG_VS(L, damage * mult))
			hit += L
			apply_darkness_stack(L, 1)

/*
/datum/action/cooldown/spell/shadowbreach/proc/do_breach(list/target_turfs)
*/
/obj/effect/umbralfount
	name = "umbral fountain"
	desc = "A condensed mass of arcyne darkness which periodically releases its energies in destructive bursts."
	icon = 'icons/effects/32x64.dmi'
	icon_state = "leylinestable"
	color = GLOW_COLOR_DARK
	opacity = 0
	light_outer_range = 1
	var/mob/living/caster
	var/pulses = 0
	var/max_pulses = 5
	var/pulse_period = 3 SECONDS
	var/pulse_warning = 2 SECONDS
	var/last_pulse
	var/damage = SPELL_DMG(50)
	var/aimed_zone = BODY_ZONE_CHEST
	var/intense = FALSE
	var/list/star_turfs
	var/list/circle_turfs

/obj/effect/umbralfount/Initialize(mapload, mob/living/castby, max = 5)
	. = ..()
	caster = castby
	max_pulses = max
	if(istype(caster) && caster.zone_selected)
		aimed_zone = caster.zone_selected
	star_turfs = telegraph_resolve_turfs(get_turf(src), telegraph_cardinal(src.dir), get_star_offsets(), TRUE)
	circle_turfs = telegraph_resolve_turfs(get_turf(src), telegraph_cardinal(src.dir), get_circle_offsets(), TRUE)
	START_PROCESSING(SSobj, src)

/obj/effect/umbralfount/process()
	if(pulses > max_pulses)
		qdel(src) //Just to make sure it can't linger
	if(last_pulse && world.time < last_pulse + pulse_period)
		return
	addtimer(CALLBACK(src, PROC_REF(telegraph_burst), pulse_warning), pulse_period - pulse_warning)
	addtimer(CALLBACK(src, PROC_REF(burst)), pulse_period)
	last_pulse = world.time

/obj/effect/umbralfount/proc/telegraph_burst(warning_period)
	var/list/target_turfs = circle_turfs
	if(pulses >= max_pulses - 1 || intense) //We've not incremented the pulses by this point
		target_turfs = star_turfs
	for(var/turf/T in target_turfs)
		new /obj/effect/temp_visual/telegraph/pillar/fadein(T, warning_period)

/obj/effect/umbralfount/proc/delayedIntense(delay)
	addtimer(CALLBACK(src, PROC_REF(toggleIntense)), delay)
	//addtimer(CALLBACK(src, PROC_REF(telegraph_burst), pulse_warning - 1), delay + 1)

/obj/effect/umbralfount/proc/toggleIntense()
	intense = TRUE

/obj/effect/umbralfount/proc/burst()
	pulses++
	playsound(get_turf(src), 'sound/magic/soulshot.ogg', 100, TRUE, 5)
	var/list/target_turfs = circle_turfs
	if(pulses >= max_pulses || intense)
		new /obj/effect/temp_visual/umbral_explosion(get_turf(src))
		target_turfs = star_turfs
	for(var/turf/T in target_turfs)
		for(var/obj/machinery/light/rogue/Ls in T)
			if(Ls.on)
				Ls.extinguish()
		new /obj/effect/temp_visual/umbral(T)
		if(pulses >= max_pulses || intense)
			new /obj/effect/lingering_shadows(T, 3 SECONDS, caster, aimed_zone)
		for(var/mob/living/L in T)
			if(L.stat == DEAD)
				continue
			if(L.anti_magic_check())
				continue
			if(L.guard_deflect_spell("Umbral Fountain", TRUE, caster, punish_caster = FALSE)) //Punish the initial hit, not any riders
				continue
			if(istype(caster) && !QDELETED(caster))
				if(arcyne_strike(caster, L, null, damage * ((pulses < max_pulses || !intense) ? 1 : 1.7), aimed_zone || BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "Umbral Fountain", damage_type = BURN, skip_animation = TRUE, exact_zone = TRUE, SPELL_STRIKE_SCALING) == ARCYNE_STRIKE_WARDED)
					continue
			else
				L.adjustFireLoss(SPELL_DMG_VS(L, damage))
			apply_darkness_stack(L, 1)
	intense = FALSE
	if(pulses >= max_pulses)
		qdel(src)

/obj/effect/umbralfount/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()
/obj/effect/umbralfount/proc/get_circle_offsets()
	var/list/offs = list()
	for(var/d in -1 to 1)
		offs += list(list(-1, d), list(0, d), list(1, d))
	return offs

/obj/effect/umbralfount/proc/get_star_offsets()
	var/list/offs = list()
	for(var/d in -2 to 2)
		var/list/band = list(list(0, d))
		if(abs(d) < 2)
			for(var/s in 1 to (2 - abs(d)))
				band += list(list(-s, d), list(s, d))
		offs += band
	return offs
