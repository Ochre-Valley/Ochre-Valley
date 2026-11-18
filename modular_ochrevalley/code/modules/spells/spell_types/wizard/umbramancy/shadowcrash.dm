/datum/action/cooldown/spell/projectile/shadowcrash
	button_icon = 'icons/mob/actions/nocmiracles.dmi'
	name = "Shadow Crash"
	desc = "Conjure forth a mass of shadow to bombard your foes with \n \
	Crash: Lob a volatile mass of condensed darkness that will explode upon impact, leaving behind a pool of Lingering Shadows.\n \
	Flow: Cast forth a wave of smothering darkness, leaving behind a trail of Lingering Shadows. Striking an Umbral Fountain or Living Shadow will cause a strengthened explosion of darkness."
	button_icon_state = "blindness"
	sound = 'sound/magic/shadowstep_destination.ogg'
	spell_color = GLOW_COLOR_DARK
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_UMBRAMANCY

	projectile_type = /obj/projectile/magic/shadowcrash
	cast_range = SPELL_RANGE_PROJECTILE
	point_cost = 6
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Collisio Umbrae!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 16 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/flow_damage = SPELL_DMG(50)
	var/current_mode = 1
	var/list/modes = list(
		list("name" = "Shadow Crash", "tag" = "CRSH", "invocation" = "Collisio Umbrae!", "ground" = FALSE, "cooldown" = 16 SECONDS),
		list("name" = "Umbral Flow", "tag" = "FLOW", "invocation" = "Fluxus Umbrae!", "ground" = TRUE, "cooldown" = 20 SECONDS),
	)
/datum/action/cooldown/spell/projectile/shadowcrash/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	for(var/i in stats.Copy())
		if(findtext(i, "Damage:") || findtext(i, "Arc Mode"))
			stats -= i
	stats += span_info("Damage: Shadow Crash [SPELL_DMG(60)] (+[SPELL_DMG(20)] splash)  / Umbral Flow [flow_damage] ")
	stats += span_info("Firing mode (Shift+G): Shadow Crash (lobbed bombardment) / Umbral Flow (ground-rolling eruption).")
	return stats

/datum/action/cooldown/spell/projectile/shadowcrash/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/projectile/shadowcrash/proc/apply_mode(index)
	var/list/mode = modes[index]
	cooldown_time = mode["cooldown"]
	invocations = list(mode["invocation"])
	update_mode_maptext(mode["tag"])

/datum/action/cooldown/spell/projectile/shadowcrash/toggle_arc_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]] mode."))

/datum/action/cooldown/spell/projectile/shadowcrash/proc/update_mode_maptext(tag)
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(tag)
		holder.color = GLOW_COLOR_DARK

/datum/action/cooldown/spell/projectile/shadowcrash/fire_projectile(atom/target)
	if(!modes[current_mode]["ground"])
		return ..()
	INVOKE_ASYNC(src, PROC_REF(windup_flow), owner, target)
	return TRUE

/datum/action/cooldown/spell/projectile/shadowcrash/proc/windup_flow(mob/living/H, atom/cast_on)
	var/list/indicator = list()
	var/turf/last_turf
	var/locked_facing = telegraph_cardinal(H.dir)
	if(charge_slowdown)
		H.add_movespeed_modifier(MOVESPEED_ID_SPELL_CASTING, TRUE, 100, override = TRUE, multiplicative_slowdown = charge_slowdown)
	announce_telegraph(H)
	apply_cast_freeze(H, 1 SECONDS)
	show_cast_effect(H)
	for(var/i in 1 to 5)
		if(QDELETED(H) || H.stat != CONSCIOUS)
			break
		if(get_turf(H) != last_turf)
			last_turf = get_turf(H)
			telegraph_draw(last_turf, locked_facing, indicator, get_pattern_offsets(), /obj/effect/temp_visual/telegraph/pillar, TRUE)
		sleep(2)
	if(charge_slowdown && !QDELETED(H))
		H.remove_movespeed_modifier(MOVESPEED_ID_SPELL_CASTING)
	clear_cast_freeze(H)
	clear_cast_effect(H)
	telegraph_clear(indicator)
	if(QDELETED(H) || H.stat != CONSCIOUS)
		return
	umbral_flow(get_sweep_bands(), get_turf(owner), locked_facing, owner, flow_damage, owner.zone_selected)

/datum/action/cooldown/spell/projectile/shadowcrash/proc/get_pattern_offsets()
	var/list/offs = list()
	for(var/d in 1 to 5)
		offs += list(list(-1, d), list(0, d), list(1, d))
	return offs

/datum/action/cooldown/spell/projectile/shadowcrash/proc/get_sweep_bands()
	var/list/offs = list()
	for(var/d in 1 to 5)
		offs += list(list(list(-1, d), list(0, d), list(1, d)))
	return offs

/proc/umbral_flow(list/offsets, turf/origin, dir, mob/living/carbon/human/caster, damage, aim_zone, shadow_duration = 8 SECONDS, no_stack = FALSE, delay = 2)
	playsound(origin, 'sound/magic/soulshot.ogg', 100, TRUE, 5)
	for(var/list/band in offsets)
		var/list/turfs = telegraph_resolve_turfs(origin, dir, band, TRUE)
		for(var/turf/T in turfs)
			new /obj/effect/temp_visual/umbral(T)
			for(var/obj/machinery/light/rogue/Ls in T)
				if(Ls.on)
					Ls.extinguish()
			if(no_stack)
				for(var/obj/effect/lingering_shadows/S in T)
					qdel(S)
			new /obj/effect/lingering_shadows(T, shadow_duration, caster, aim_zone)
			if(!no_stack)
				for(var/obj/effect/umbralfount/U in T)
					//Prevent weird behavior, and keep people from sliming. 0.5 before so there's time to see what's happening, 0.2 after to account for any weirdness with the timer
					if(U.last_pulse + U.pulse_period - world.time > 0.5 SECONDS || U.last_pulse + U.pulse_period - world.time < -0.2 SECONDS)
						U.intense = TRUE
						if(U.last_pulse + U.pulse_period - world.time > 0) //Don't telegraph if we're waiting on the next processing tick anyways
							U.telegraph_burst(U.last_pulse + U.pulse_period - world.time) //Redraw telegraph
					else
						U.delayedIntense(U.last_pulse + U.pulse_period - world.time + 0.2 SECONDS )
					U.visible_message(span_warning("The umbral flow interacts with the umbral fountain, next burst will be empowered!"))
				for(var/obj/structure/living_shadow/S in T)
					S.visible_message(span_warning("The umbral flow interacts with the living shadow, causing it to burst into an umbral cloud!"))
					qdel(S)
			for(var/mob/living/L in T)
				if(L.stat == DEAD)
					continue
				if(L.anti_magic_check())
					continue
				if(L.guard_deflect_spell("Umbral Flow", TRUE, caster, punish_caster = FALSE)) //Punish the initial hit, not any riders
					continue
				if(istype(caster) && !QDELETED(caster))
					if(arcyne_strike(caster, L, null, damage, aim_zone || BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "umbral flow", damage_type = BURN, skip_animation = TRUE, exact_zone = TRUE, SPELL_STRIKE_SCALING) == ARCYNE_STRIKE_WARDED)
						continue
				else
					L.adjustFireLoss(SPELL_DMG_VS(L, damage))
				apply_darkness_stack(L, 1)
		sleep(delay)

/obj/projectile/magic/shadowcrash
	name = "condensed shadows"
	expose_caster_on_deflect = TRUE
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "gumball"
	color = GLOW_COLOR_DARK
	speed = MAGE_PROJ_VERY_SLOW
	damage = SPELL_DMG(60)
	damage_type = BURN
	woundclass = BCLASS_BURN
	nodamage = FALSE
	intdamfactor = SPELL_INTDAM(1)
	spell_damage_scaled = TRUE
	flag = "fire"
	arcshot = TRUE
	hitsound = 'sound/blank.ogg'
	/// Radius for AOE blast around impact point
	var/aoe_radius = 1
	/// AOE damage as a fraction of the projectile's base damage
	var/aoe_damage_ratio = 0.333

/obj/projectile/magic/shadowcrash/on_hit(target, blocked = FALSE)
	..()
	var/mob/living/M = ismob(target) ? target : null

	if(M?.anti_magic_check())
		visible_message(span_warning("[src] fizzles on contact with \the [target]!"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		qdel(src)
		return BULLET_ACT_BLOCK

	if(out_of_effective_range())
		return

	var/aoe_damage = round(damage * aoe_damage_ratio)
	var/turf/epicenter = get_turf(target)

	if(epicenter)
		playsound(epicenter, 'sound/magic/soulshot.ogg', 100, TRUE, 5)
		new /obj/effect/temp_visual/umbral_explosion(epicenter)
	if(aoe_radius > 0 && istype(firer, /mob/living/carbon/human))
		var/mob/living/carbon/human/caster = firer
		var/mob/living/direct_hit = M
		for(var/turf/T in range(aoe_radius, epicenter))
			new /obj/effect/temp_visual/umbral(T)
			for(var/obj/machinery/light/rogue/Ls in T)
				if(Ls.on)
					Ls.extinguish()
			if(!T.density)
				new /obj/effect/lingering_shadows(T, 4 SECONDS, caster, caster.zone_selected)
			for(var/mob/living/L in T)
				if(L == direct_hit || L.stat == DEAD)
					continue
				if(L.anti_magic_check())
					continue
				if(L.guard_deflect_spell("Shadow Crash", TRUE, caster, punish_caster = FALSE))
					continue
				if(arcyne_strike(caster, L, null, aoe_damage, BODY_ZONE_CHEST, \
					BCLASS_BURN, spell_name = "Shadow Crash", \
					allow_shield_check = TRUE, damage_type = BURN, \
					skip_animation = TRUE, SPELL_STRIKE_SCALING) == ARCYNE_STRIKE_WARDED)
					continue
				new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOW_COLOR_DARK, SPELL_IMPACT_MEDIUM)

	// Apply frost to direct hit target (AOE loop skips them)
	if(isliving(target) && blocked < 100)
		var/mob/living/L = target
		apply_darkness_stack(L, 1)

	qdel(src)
	return TRUE
