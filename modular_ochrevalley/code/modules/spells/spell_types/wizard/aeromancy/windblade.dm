#define MT_WINDBLADE "sawblade"
#define WINDBLADE_HIT_IMMUNITY 1 SECONDS

/datum/action/cooldown/spell/projectile/windblade_volley
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	name = "Razorwind Volley"
	desc = "Unleash a windstorm honed into a trio of whirling blades that slice right through their victims. \
			Each blade can pierce through up to three targets.\
		    Repeated hits on a single target from the same volley do reduced damage."
	button_icon_state = "caedo"
	sound = 'sound/magic/blade_burst.ogg'
	spell_color = GLOW_COLOR_WIND
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_AEROMANCY

	projectile_type = /obj/projectile/magic/wind_sawblade
	cast_range = SPELL_RANGE_PROJECTILE
	projectiles_per_fire = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Venti Caedite!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_swingdelay_type = SWINGDELAY_PENALTY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 14 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	displayed_damage = SPELL_DMG(60)

	var/spread_step = 8

/datum/action/cooldown/spell/projectile/windblade_volley/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	var/base_angle = to_fire.Angle
	if(isnull(base_angle))
		base_angle = Get_Angle(user, target)
	var/center_index = (projectiles_per_fire + 1) / 2
	to_fire.Angle = base_angle + ((iteration - center_index) * spread_step)

/obj/projectile/magic/wind_sawblade
	name = "wind blade"
	icon = 'icons/effects/wizard_spell_effects.dmi'
	icon_state = "grassblade"
	guard_deflectable = TRUE
	damage = SPELL_DMG(45)
	intdamfactor = SPELL_INTDAM(1)
	damage_type = BRUTE
	woundclass = BCLASS_CUT
	flag = "slash"
	nodamage = FALSE
	speed = MAGE_PROJ_MEDIUM
	movement_type = UNSTOPPABLE
	range = SPELL_RANGE_PROJECTILE
	spell_damage_scaled = TRUE
	hitsound = 'sound/combat/newstuck.ogg'
	var/reduced_damage = SPELL_DMG(22)
	var/hits = 0
	var/max_hits = 3

/obj/projectile/magic/wind_sawblade/prehit(atom/target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.mob_timers[MT_WINDBLADE] && world.time < M.mob_timers[MT_WINDBLADE] + WINDBLADE_HIT_IMMUNITY)
			damage = reduced_damage
			no_crit = TRUE
		else
			M.mob_timers[MT_WINDBLADE] = world.time
	return ..()

/obj/projectile/magic/wind_sawblade/on_hit(target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] shatters on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		playsound(get_turf(target), hitsound, 80, TRUE)
	. = ..()
	if(!ismob(target))
		qdel(src)
		return . || BULLET_ACT_HIT
	hits++
	if(hits >= max_hits)
		qdel(src)
		return . || BULLET_ACT_HIT
	return BULLET_ACT_FORCE_PIERCE

#undef MT_WINDBLADE
#undef WINDBLADE_HIT_IMMUNITY
