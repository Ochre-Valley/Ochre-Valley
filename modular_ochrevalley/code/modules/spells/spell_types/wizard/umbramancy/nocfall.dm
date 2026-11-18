/datum/action/cooldown/spell/nocfall
	button_icon = 'icons/mob/actions/vheslynspells.dmi'
	name = "Umbral Sundering"
	expose_caster_on_deflect = FALSE
	desc = "Form a crystallized mass of darkness overhead and violently cast it down upon a target area, dealing significant damage and leaving behind a sizeable pool of Lingering Shadows. Targets struck will be knocked down and afflicted with Shadowed, and structures hit by the spell will take increased damage."
	button_icon_state = "conscindo"
	sound = 'sound/magic/fireball.ogg'
	spell_color = GLOW_COLOR_DARK
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_UMBRAMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Noc Frange Ea!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 75 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/blast_radius = 2
	var/impact_delay = 2 SECONDS
	var/structural_damage = 600
	var/mob_damage = SPELL_DMG(90)
	displayed_damage = SPELL_DMG(90)
	var/shadow_life = 10 SECONDS

/datum/action/cooldown/spell/nocfall/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE
	if(!(center in get_hear(cast_range, get_turf(H))))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	for(var/turf/T in range(blast_radius, center))
		new /obj/effect/temp_visual/telegraph/wall/fire(T)
	center.visible_message(span_boldwarning("The sky above darkens - stars eclipsed by a mass of darkness!"))
	addtimer(CALLBACK(src, PROC_REF(drop_darkball), center), impact_delay)
	return TRUE

/datum/action/cooldown/spell/nocfall/proc/drop_darkball(turf/center)
	if(QDELETED(src) || QDELETED(owner))
		return
	new /obj/effect/temp_visual/falling_boulder/darkball(center, CALLBACK(src, PROC_REF(dark_impact), center))

/datum/action/cooldown/spell/nocfall/proc/dark_impact(turf/center)
	if(QDELETED(src) || QDELETED(owner))
		return
	var/mob/living/carbon/human/caster = owner
	playsound(center, 'sound/magic/soulshot.ogg', 100, TRUE, 6)
	new /obj/effect/temp_visual/spell_impact(center, spell_color, spell_impact_intensity)
	for(var/turf/T in range(blast_radius, center))
		new /obj/effect/lingering_shadows(T, shadow_life, caster, BODY_ZONE_CHEST)
		for(var/obj/structure/S in T.contents)
			S.take_damage(structural_damage, BRUTE, "blunt", object_damage_multiplier = 2)
		for(var/obj/machinery/light/rogue/Ls in T)
			if(Ls.on)
				Ls.extinguish()
		T.take_damage(structural_damage, BRUTE, "blunt", object_damage_multiplier = 2)
		for(var/mob/living/L in T.contents)
			if(L.anti_magic_check())
				continue
			if(spell_guard_check(L, TRUE))
				continue
			if(istype(caster) && ishuman(L))
				if(arcyne_strike(caster, L, null, mob_damage, BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "Nocfall", damage_type = BURN, skip_animation = TRUE, SPELL_STRIKE_SCALING) == ARCYNE_STRIKE_WARDED)
					continue
			else
				L.adjustFireLoss(SPELL_DMG_VS(L, mob_damage))
			L.Knockdown(3)


/obj/effect/temp_visual/falling_boulder/darkball
	icon = 'icons/effects/32x64.dmi'
	icon_state = "leylineunstable"
	name = "falling darkness"
	color = GLOW_COLOR_DARK
