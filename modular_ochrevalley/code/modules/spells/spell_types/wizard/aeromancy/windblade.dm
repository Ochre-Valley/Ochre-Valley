#define MT_WINDBLADE "sawblade"
#define WINDBLADE_HIT_IMMUNITY 1 SECONDS

/datum/action/cooldown/spell/projectile/windblade_volley
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	name = "Razorwind Volley"
	desc = "Volley: Unleash a windstorm honed into a trio of whirling blades that slice right through their victims. \
			Each blade can pierce through up to three targets.\
		    Repeated hits on a single target from the same volley do reduced damage.\n \
			Compaction: Launch forth a compressed sphere of vicious gales that will burst upon contact with a target, delivering a brutal flurry of slashes in an instant."
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

	var/spread_step = 8
	var/current_mode = 1
	var/list/modes = list(
		list("name" = "Volley", "tag" = "VLLY", "proj" = /obj/projectile/magic/wind_sawblade, "invocation" = "Venti Caedite!", "projectiles" = 3, "cooldown" = 14 SECONDS),
		list("name" = "Compaction", "tag" = "COMP", "proj" = /obj/projectile/magic/wind_compaction, "invocation" = "Venti Saevite!", "projectiles" = 1, "cooldown" = 16 SECONDS),
	)

/datum/action/cooldown/spell/projectile/windblade_volley/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/projectile/windblade_volley/proc/apply_mode(index)
	var/list/mode = modes[index]
	name = "Razorwind [mode["name"]]"
	projectile_type = mode["proj"]
	projectiles_per_fire = mode["projectiles"]
	cooldown_time = mode["cooldown"]
	invocations = list(mode["invocation"])
	update_mode_maptext(mode["tag"])

/datum/action/cooldown/spell/projectile/windblade_volley/toggle_arc_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]] mode."))

/datum/action/cooldown/spell/projectile/windblade_volley/proc/update_mode_maptext(tag)
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
		holder.color = GLOW_COLOR_WIND

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

/obj/projectile/magic/wind_compaction
	name = "condensed winds"
	icon = 'icons/effects/wizard_spell_effects.dmi'
	icon_state = "grassblade"
	guard_deflectable = TRUE
	intdamfactor = SPELL_INTDAM(1)
	damage_type = BRUTE
	woundclass = BCLASS_CUT
	flag = "slash"
	nodamage = TRUE
	damage = 0
	speed = MAGE_PROJ_MEDIUM
	range = SPELL_RANGE_PROJECTILE
	hitsound = 'sound/combat/newstuck.ogg'
	var/slash_damage = SPELL_DMG(30)
	var/hits = 3

/obj/projectile/magic/wind_compaction/on_hit(target, blocked = FALSE)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(out_of_effective_range())
			return
		if(blocked >= 100)
			return
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(resolve_compaction), M, firer, slash_damage, hits, def_zone)
	return . || BULLET_ACT_HIT

/proc/resolve_compaction(mob/living/target, mob/living/caster, damage = 30, hits = 3, target_zone = BODY_ZONE_CHEST)
	if(!istype(target))
		return
	if(isliving(caster) && !QDELETED(caster))
		for(var/i in 1 to hits)
			if(arcyne_strike(caster, target, null, damage, target_zone, BCLASS_CUT, spell_name = "cleaving winds", damage_type = BRUTE, skip_animation = FALSE, exact_zone = TRUE, SPELL_STRIKE_SCALING) == ARCYNE_STRIKE_WARDED)
				return //If any hits are blocked, just stop
			sleep(2)
	else
		var/fallback_zone = check_zone(target_zone)
		for(var/i in 1 to hits)
			var/armor_block = target.run_armor_check(fallback_zone, "slash", blade_dulling = BCLASS_CUT, damage = damage, intdamfactor = SPELL_INTDAM(1), no_debuff = TRUE)
			target.apply_damage(SPELL_DMG_VS(target, damage), BRUTE, fallback_zone, armor_block)
			sleep(2)

#undef MT_WINDBLADE
#undef WINDBLADE_HIT_IMMUNITY
