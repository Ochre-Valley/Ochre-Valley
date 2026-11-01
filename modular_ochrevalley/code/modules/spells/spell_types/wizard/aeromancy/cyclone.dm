#define CYCLONE_DAMAGE 30
#define CYCLONE_TELEGRAPH 8

/datum/action/cooldown/spell/cyclone
	button_icon = 'icons/mob/actions/mage_fulgurmancy.dmi'
	name = "Maelstrom"
	desc = "Channel to conjure up swirling windstorm of razor-sharp winds, devastating an area over a lengthy duration. \
			While channeling, you cannot move or cast any other spells, and are susceptible to interruptions."
	button_icon_state = "greater_thunderstrike"
	sound = 'sound/magic/lightning.ogg'
	spell_color = GLOW_COLOR_WIND
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_AEROMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list("Ventorum Letalium, Respondete Mihi!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_swingdelay_type = SWINGDELAY_CANCEL
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	displayed_damage = CYCLONE_DAMAGE

	var/tempest_duration = 10 SECONDS
	/// Damage per tick
	var/tempest_damage = CYCLONE_DAMAGE
	/// Radius of the damage ring (center tile is safe)
	var/tempest_radius = 3

/datum/action/cooldown/spell/cyclone/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/centerpoint = get_turf(cast_on)
	if(!centerpoint)
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(centerpoint.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(centerpoint.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)
	if(!(centerpoint in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	for(var/turf/T in range(tempest_radius, centerpoint))
		if(!(T in get_hear(tempest_radius, centerpoint)) || T == centerpoint)
			continue
		new /obj/effect/temp_visual/telegraph/pillar/fadein(T, CYCLONE_TELEGRAPH)

	H.visible_message(span_boldwarning("[H] whips up a fierce gale!"))
	playsound(centerpoint, 'sound/magic/charging.ogg', 80, TRUE, 6)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(make_cyclone), centerpoint, H, src, "Cyclone"), CYCLONE_TELEGRAPH)
	return TRUE

/proc/make_cyclone(turf/centerpoint, mob/living/carbon/human/caster, datum/action/cooldown/spell/guard_source, spell_name = "Cyclone")
	new /obj/effect/tempest/cyclone(centerpoint, caster, guard_source)
/obj/effect/tempest/cyclone
	tick_damage = 30
	effect_radius = 3
