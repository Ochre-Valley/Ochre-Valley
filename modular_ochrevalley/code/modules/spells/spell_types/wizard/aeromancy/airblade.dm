
/datum/action/cooldown/spell/projectile/wind_blade
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	name = "Cutting Gale"
	desc = "Cast forth a gust of wind, bound into the shape of a small blade. Toggle arc mode (Shift+G) while the spell is active to arc it over intervening mobs.\
			 Arced attacks deal 25% less damage. Capable of piercing through up to three targets."
	button_icon_state = "air_strike"
	sound = 'sound/combat/hits/whipgrab.ogg'
	spell_color = GLOW_COLOR_WIND
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/wind_blade
	projectile_type_arc = /obj/projectile/magic/wind_blade/arc
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Venti Secant!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 6 SECONDS
	attunement_school = ASPECT_NAME_AEROMANCY

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/obj/projectile/magic/wind_blade
	name = "wind blade"
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	range = 7 // Let you pressure a whole screen, in theory
	icon_state = "chronobolt"
	max_range = MAGE_LONG_PROJ_RANGE // Effective range is lower than its maximal range
	damage = SPELL_DMG(60)
	damage_type = BRUTE
	woundclass = BCLASS_CUT
	speed = MAGE_PROJ_FAST
	movement_type = UNSTOPPABLE
	intdamfactor = SPELL_INTDAM(1)
	nodamage = FALSE
	spell_damage_scaled = TRUE
	flag = "slash"
	color = "#8CDD8C"
	hitsound = 'sound/combat/hits/bladed/genslash (1).ogg'
	/// How many mob targets have been pierced
	var/hits = 0
	/// Max mob targets before stopping
	var/max_hits = 3

/obj/projectile/magic/wind_blade/arc
	name = "arced wind blade"
	damage = 45
	arcshot = TRUE
	max_hits = 1

/obj/projectile/magic/wind_blade/on_hit(target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] shatters harmlessly against [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()
	if(!ismob(target))
		qdel(src)
		return . || BULLET_ACT_HIT
	hits++
	if(hits >= max_hits)
		qdel(src)
		return . || BULLET_ACT_HIT
	return BULLET_ACT_FORCE_PIERCE
