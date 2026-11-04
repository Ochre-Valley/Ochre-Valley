#define TAILWIND_DURATION 2 SECONDS
/datum/action/cooldown/spell/tailwind
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	name = "Wind's Wake"
	desc = "Surge forth like the wind, rushing ahead in a cardinal direction and flowing around those in your path. \
			In your wake, leave behind turbulence that lightly hampers the movements of pursuers. Shares a cooldown with squall."
	button_icon_state = "haste"
	sound = 'sound/combat/wooshes/bladed/wooshsmall (1).ogg'
	spell_color = GLOW_COLOR_WIND
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_AEROMANCY

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Venti Ducite!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS
	shared_cooldown = "aeromancy_util"

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	point_cost = 3

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/charge_steps = 5
	var/step_delay = 1

/datum/action/cooldown/spell/squall
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	name = "Squall"
	desc = "Call forth a surge of fierce, if harmless winds, throwing back any nearby and hampering them briefly. \
			Shares a cooldown with tailwind."
	button_icon_state = "nondetection"
	sound = 'sound/combat/wooshes/bladed/wooshsmall (1).ogg'
	spell_color = GLOW_COLOR_WIND
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_AEROMANCY

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Venti Custodite!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS
	shared_cooldown = "aeromancy_util"

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	point_cost = 3

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_NO_MOVE


/datum/action/cooldown/spell/squall/on_start_charge()
	. = ..()
	var/turf/center = get_turf(owner)
	for(var/turf/T in range(1, center))
		if(T == center)
			continue
		new /obj/effect/temp_visual/telegraph/pillar(T, charge_time)

/datum/action/cooldown/spell/tailwind/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/facing = H.dir
	var/turf/start = get_turf(H)
	var/turf/first_step = get_step(start, facing)
	if(!first_step || first_step.density)
		to_chat(H, span_warning("There's no room to move!"))
		return FALSE

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)


	H.visible_message(
		span_warning("[H] is carried forth by the wind!"),
		span_notice("I am carried forth by the wind!"))
	playsound(start, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 60, TRUE)

	var/steps_taken = 0
	owner.pass_flags |= PASSMOB
	for(var/i in 1 to charge_steps)
		if(H.stat != CONSCIOUS || H.IsParalyzed() || H.IsStun() || QDELETED(H))
			break
		var/turf/next = get_step(get_turf(H), facing)
		if(!next || next.density)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in next.contents)
			if(S.density)
				blocked = TRUE
				break
		if(blocked)
			break

		// Shove mobs on the next tile to the sides before stepping in
		step(H, facing)
		steps_taken++

		if(i < charge_steps)
			new /obj/effect/tailwind(get_turf(H), H)
			sleep(step_delay)
	owner.pass_flags &= ~PASSMOB
	if(steps_taken == 0)
		to_chat(H, span_warning("My path is blocked!"))
		return FALSE

	log_combat(H, null, "used Tailwind!")
	return TRUE

/datum/action/cooldown/spell/squall/cast(atom/cast_on)
	. = ..()
	var/turf/center = get_turf(owner)
	for(var/turf/T in range(1, center))
		if(T == center)
			continue
		new /obj/effect/temp_visual/tempest(T, 5)
		for(var/mob/living/victim in T)
			if(victim == owner || victim.stat == DEAD)
				continue
			if(victim.anti_magic_check())
				continue
			if(spell_guard_check(victim, TRUE))
				continue
			victim.apply_status_effect(/datum/status_effect/tailwind_slow)
			var/push_dir = get_dir(T, victim) || get_dir(owner, victim) || pick(GLOB.cardinals)
			victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, 1), 1, 1, owner, force = MOVE_FORCE_STRONG)
	log_combat(owner, null, "used Squall!")
	return TRUE
/*
/datum/action/cooldown/spell/tailwind/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/turf = get_turf(H)
	playsound(turf, 'sound/spellbooks/crystal.ogg', 80, TRUE)
	var/init = new /obj/effect/tailwind(turf, H)
	if(init)
		H.apply_status_effect(/datum/status_effect/tailwind)
		return TRUE
	return FALSE
*/
/obj/effect/tailwind
	name = "tailwind"
	desc = "Whirling winds left in an aeromancer's wake."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_outer_range = 1
	light_color = GLOW_COLOR_WIND
	var/mob/living/caster

/obj/effect/tailwind/Initialize(mapload, mob/living/owner, lifespan = TAILWIND_DURATION)
	. = ..()
	caster = owner
	RegisterSignal(get_turf(src), COMSIG_ATOM_ENTERED, PROC_REF(on_entered))
	//RegisterSignal(get_turf(src), COMSIG_ATOM_EXIT, PROC_REF(on_exit))
	if(lifespan)
		QDEL_IN(src, lifespan)

/obj/effect/tailwind/Destroy()
	UnregisterSignal(get_turf(src), COMSIG_ATOM_ENTERED)
	//UnregisterSignal(get_turf(src),	COMSIG_ATOM_EXIT)
	return ..()

/obj/effect/tailwind/proc/on_entered(datum/source, atom/movable/AM, atom/old_loc)
	SIGNAL_HANDLER
	if(!isliving(AM))
		return
	var/mob/living/L = AM
	if(L == caster)
		return
	if(L.force_moving || L.throwing || L.buckled || L.IsImmobilized())
		return
	if(L.has_status_effect(/datum/status_effect/tailwind_slow))
		return
	L.apply_status_effect(/datum/status_effect/tailwind_slow)
/*
/obj/effect/tailwind/proc/on_exit(turf/exited, atom/movable/exiting, atom/newloc)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = exiting
	if(ishuman(exiting) && H.has_status_effect(/datum/status_effect/tailwind)) //Don't check caster here so two tailwinding mages don't cancel their tailwinds out
		new /obj/effect/tailwind(get_turf(newloc), H)
*/
/datum/status_effect/tailwind_slow
	id = "tailwind_slow"
	duration = 6 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/tailwind_slow
	effectedstats = list(STATKEY_SPD = -1)
/*
/datum/status_effect/tailwind
	id = "tailwind"
	duration = 6 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/tailwind
	effectedstats = list(STATKEY_SPD = 2)

/datum/status_effect/tailwind/on_apply()
	owner.pass_flags |= PASSMOB
	. = ..()

/datum/status_effect/tailwind/on_remove()
	owner.pass_flags &= ~PASSMOB
	. = ..()

/atom/movable/screen/alert/status_effect/tailwind
	name = "Tailwind"
	desc = "I am one with the winds, bolstering my speed and leaving a turbulent wake in my steps."
	icon_state = "buff"
*/
/atom/movable/screen/alert/status_effect/tailwind_slow
	name = "Tailwind"
	desc = "An unfavorable wind is making movement slightly more difficult."
	icon_state = "debuff"

#undef TAILWIND_DURATION
