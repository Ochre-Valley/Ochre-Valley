#define CYCLONE_DAMAGE 30
#define CYCLONE_TELEGRAPH 5
#define CYCLONE_DURATION 10 SECONDS
#define CYCLONE_INTERRUPTS list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_CAST_SPELL, COMSIG_MOB_ITEM_BEING_ATTACKED, COMSIG_MOB_ATTACKED_BY_HAND, COMSIG_ATOM_BULLET_ACT, COMSIG_ATOM_HITBY, COMSIG_ATOM_WAS_ATTACKED)
/datum/action/cooldown/spell/cyclone
	button_icon = 'icons/mob/actions/mage_fulgurmancy.dmi'
	name = "Maelstrom"
	desc = "Channel to conjure up swirling windstorm of razor-sharp winds, devastating an area over a lengthy duration, save for a small zone of safety in the eye of the storm. \
			While channeling, you cannot move or cast any other spells, and are susceptible to interruptions."
	button_icon_state = "greater_thunderstrike"
	sound = 'sound/combat/wooshes/bladed/wooshlarge (1).ogg'
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
	cooldown_time = 90 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_NO_MOVE

	displayed_damage = CYCLONE_DAMAGE

	var/tempest_duration = CYCLONE_DURATION
	/// Damage per tick
	var/tempest_damage = CYCLONE_DAMAGE
	/// Radius of the damage ring (center tile is safe)
	var/tempest_radius = 3
	var/obj/effect/tempest/cyclone/active_zone

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
	RegisterSignal(H, CYCLONE_INTERRUPTS, PROC_REF(end_cyclone))
	active_zone = new(centerpoint, H, src, "Cyclone")
	return TRUE

/datum/action/cooldown/spell/cyclone/proc/end_cyclone()
	SIGNAL_HANDLER
	if(owner)
		UnregisterSignal(owner, CYCLONE_INTERRUPTS)
		owner.balloon_alert(owner, "Cyclone ended.")
	if(active_zone && !QDELETED(active_zone))
		qdel(active_zone)
	active_zone = null

/obj/effect/tempest/cyclone
	tick_damage = SPELL_DMG(30)
	effect_radius = 3
	var/datum/beam/caster_beam

/obj/effect/tempest/cyclone/Initialize(mapload, mob/living/summoner, datum/action/cooldown/spell/spell_ref)
	var/turf/center = get_turf(src)
	for(var/turf/T in range(effect_radius, center))
		if(!(T in get_hear(effect_radius, center)) || T == center)
			continue
		new /obj/effect/temp_visual/telegraph/pillar/fadein(T, CYCLONE_TELEGRAPH)
	spawn(CYCLONE_TELEGRAPH)
		. = ..()
		INVOKE_ASYNC(src, PROC_REF(setup_visuals))

/obj/effect/tempest/cyclone/proc/setup_visuals()
	// Visible beam from zone center to caster
	caster_beam = new(src, caster, 'icons/effects/beam.dmi', "b_beam", CYCLONE_DURATION + 1 SECONDS, maxdistance = 20)
	caster_beam.Start()

/obj/effect/tempest/cyclone/Destroy()
	if(caster_beam)
		caster_beam.End()
		caster_beam = null
	if(source_spell && istype(source_spell, /datum/action/cooldown/spell/cyclone))
		var/datum/action/cooldown/spell/cyclone/C = source_spell
		C.end_cyclone()
	source_spell = null
	caster = null
	QDEL_LIST(daggers)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

#undef CYCLONE_DAMAGE
#undef CYCLONE_TELEGRAPH
#undef CYCLONE_DURATION
#undef CYCLONE_INTERRUPTS
