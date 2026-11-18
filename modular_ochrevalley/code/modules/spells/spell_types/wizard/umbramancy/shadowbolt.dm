#define RESONANCE_RIDER_DAMAGE 45

/datum/action/cooldown/spell/projectile/shadow_bolt
	button_icon = 'icons/mob/actions/mage_hex.dmi'
	name = "Shadow Bolt"
	desc = "Fire a precise jolt of lightning that sears a target's struck body part with heavy burn. \
	Toggle firing mode (Shift+G) while active: Chain leaps to up to three foes behind the target, searing the same body part for half as much, \
	Focus only strike one target, and Arc lobs a single weakened bolt over obstacles. \
	The bolt loses power past 5 paces."
	button_icon_state = "wither"
	sound = 'sound/magic/shadowstep_destination.ogg'
	spell_color = GLOW_COLOR_DARK
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/shadow_bolt
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Tenebra!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_swingdelay_type = SWINGDELAY_NORMAL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 6.5 SECONDS
	attunement_school = ASPECT_NAME_UMBRAMANCY

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN
	var/resonance_delay = 0.5 SECONDS
	var/resonance_damage = SPELL_DMG(30)
	var/current_mode = 1
	var/list/modes = list(
		list("name" = "Shadow Bolt", "tag" = "BOLT", "proj" = /obj/projectile/magic/shadow_bolt, "invocation" = "Tenebra!", "charge_time" = CHARGETIME_POKE, "ground" = FALSE),
		list("name" = "Arced Shadow Bolt", "tag" = "ARC", "proj" = /obj/projectile/magic/shadow_bolt/arc, "invocation" = "Tenebra!", "charge_time" = CHARGETIME_POKE, "ground" = FALSE),
		list("name" = "Umbral Resonance", "tag" = "RESN", "proj" = /obj/projectile/magic/shadow_bolt, "invocation" = "Tenebra Resonat!", "charge_time" = CHARGETIME_MINOR, "ground" = TRUE),
	)

/datum/action/cooldown/spell/projectile/shadow_bolt/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/projectile/shadow_bolt/proc/apply_mode(index)
	var/list/mode = modes[index]
	projectile_type = mode["proj"]
	invocations = list(mode["invocation"])
	charge_time = mode["charge_time"]
	update_mode_maptext(mode["tag"])

/datum/action/cooldown/spell/projectile/shadow_bolt/toggle_arc_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]] mode."))

/datum/action/cooldown/spell/projectile/shadow_bolt/proc/update_mode_maptext(tag)
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

/datum/action/cooldown/spell/projectile/shadow_bolt/fire_projectile(atom/target)
	if(!modes[current_mode]["ground"])
		return ..()
	var/turf/epicenter = get_turf(target)
	if(!epicenter)
		return FALSE
	new /obj/effect/temp_visual/telegraph/pillar/fadein(epicenter, resonance_delay)
	playsound(epicenter, 'sound/magic/charging_fire.ogg', 80, TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(resonance_erupt), epicenter, owner, resonance_damage, 0, owner.zone_selected, FALSE), resonance_delay)
	return TRUE

/proc/resonance_erupt(turf/epicenter, mob/living/carbon/human/caster, damage, radius, aim_zone, chained)
	if(!epicenter)
		return
	var/has_exploded = FALSE //Keep any weirdness with a bunch of people with stacks on one tile from causing absolute death
	playsound(epicenter, pick('sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg'), 100, TRUE, 5)
	for(var/turf/T in range(radius, epicenter))
		new /obj/effect/temp_visual/umbral(T)
		for(var/obj/machinery/light/rogue/Ls in T)
			if(Ls.on)
				Ls.extinguish()
		for(var/obj/effect/umbralfount/U in T)
			//Prevent weird behavior, and keep people from sliming. 0.5 before so there's time to see what's happening, 0.2 after to account for any weirdness with the timer
			if(U.last_pulse + U.pulse_period - world.time > 0.5 SECONDS || U.last_pulse + U.pulse_period - world.time < -0.2 SECONDS)
				U.intense = TRUE
				if(U.last_pulse + U.pulse_period - world.time > 0) //Don't telegraph if we're waiting on the next processing tick anyways
					U.telegraph_burst(U.last_pulse + U.pulse_period - world.time) //Redraw telegraph
			else
				U.delayedIntense(U.last_pulse + U.pulse_period - world.time + 0.2 SECONDS )
			U.visible_message(span_warning("The umbral resonance interacts with the umbral fountain, next burst will be empowered!"))
		for(var/obj/structure/living_shadow/S in T)
			S.visible_message(span_warning("The umbral resonance interacts with the living shadow, causing it to burst into an umbral cloud!"))
			qdel(S)
		for(var/mob/living/L in T)
			if(L.stat == DEAD)
				continue
			if(L.anti_magic_check())
				continue
			if(L.guard_deflect_spell("Umbral Resonance", TRUE, caster, punish_caster = !chained)) //Punish the initial hit, not any riders
				continue
			if(istype(caster) && !QDELETED(caster))
				if(arcyne_strike(caster, L, null, damage, aim_zone || BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "Umbral Resonance", damage_type = BURN, skip_animation = TRUE, exact_zone = TRUE, SPELL_STRIKE_SCALING) == ARCYNE_STRIKE_WARDED)
					continue
				if(get_darkness_stacks(L) > 2 && !chained && !has_exploded) //No chaining rider effects, while also letting us use one proc for all our explodey needs.
					arcyne_strike(caster, L, null, SPELL_DMG(RESONANCE_RIDER_DAMAGE), aim_zone || BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "Shadow Burst", damage_type = BURN, skip_animation = TRUE, exact_zone = TRUE, SPELL_STRIKE_SCALING)
					for(var/turf/Tg in range(1, epicenter))
						new /obj/effect/temp_visual/telegraph/pillar/fadein(Tg, 0.5 SECONDS)
					playsound(epicenter, 'sound/magic/charging_fire.ogg', 80, TRUE)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(resonance_erupt), T, caster, damage, 1, caster.zone_selected, TRUE), 0.5 SECONDS)
					has_exploded = TRUE
					remove_all_darkness_stacks(L)
			else
				L.adjustFireLoss(SPELL_DMG_VS(L, damage))


/obj/projectile/magic/shadow_bolt
	name = "shadow bolt"
	expose_caster_on_deflect = TRUE
	icon_state = "necropotence"
	light_color = GLOW_COLOR_DARK
	light_outer_range = 1
	speed = MAGE_PROJ_VERY_SLOW
	damage = SPELL_DMG(45)
	intdamfactor = SPELL_INTDAM(1)
	spell_damage_scaled = TRUE
	damage_type = BURN
	woundclass = BCLASS_BURN
	nodamage = FALSE
	flag = "fire"
	hitsound = 'sound/blank.ogg'
	var/stack_boost = SPELL_DMG(30)

/obj/projectile/magic/shadow_bolt/arc
	name = "arced shadow bolt"
	damage = SPELL_DMG(30)
	arcshot = TRUE

/obj/projectile/magic/shadow_bolt/on_hit(target, blocked = FALSE)
	. = ..()
	if(istype(target, /obj/machinery/light/rogue))
		var/obj/machinery/light/rogue/L = target
		if(L.on)
			L.extinguish()
	if(isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(blocked >= 100)
			return
		if(get_darkness_stacks(L) > 2 && isliving(firer))
			var/mob/living/caster = firer
			arcyne_strike(caster, L, null, stack_boost, def_zone || BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "Shadow Burst", damage_type = BURN, skip_animation = TRUE, exact_zone = TRUE, SPELL_STRIKE_SCALING)
			L.apply_status_effect(/datum/status_effect/debuff/vulnerable, 5 SECONDS)
			remove_all_darkness_stacks(L)


#undef RESONANCE_RIDER_DAMAGE
