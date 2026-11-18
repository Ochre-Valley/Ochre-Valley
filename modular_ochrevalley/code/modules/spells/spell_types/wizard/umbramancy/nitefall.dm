/datum/action/cooldown/spell/nitefall
	name = "Nitefall"
	desc = " Conjure a spread of short-lyving Umbral Fountains across a wide area, each one only lingering long enough to release three bursts before expiring."
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "cataclysm"
	sound = 'sound/misc/portalactivate.ogg'
	spell_color = GLOW_COLOR_DARK
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_UMBRAMANCY

	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list("Nox Obscurissima!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_swingdelay_type = SWINGDELAY_CANCEL
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 100 SECONDS
	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_NO_MOVE

	var/fount_size = 2

/datum/action/cooldown/spell/nitefall/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/aimed = get_turf(cast_on)
	if(!aimed)
		return FALSE
	new /obj/effect/umbralfount(aimed, owner, 3)
	addtimer(CALLBACK(src, PROC_REF(do_ring), aimed, fount_size), 1.5 SECONDS)
	return TRUE


/datum/action/cooldown/spell/nitefall/proc/do_ring(turf/aimed, size = 2)
	if(!aimed)
		return
	for(var/i in 0 to (size**2 - 1)) //Why am I generalising this to any size? Because funny, and maybe admemes
		var/turf/fountLoc = locate(aimed.x - (2 * (size - 1)) + (4*(i%size)), aimed.y - (2 * (size - 1)) + (4*round(i/size)), aimed.z)
		if(fountLoc && !fountLoc.density && i != (size**2-1)/2)
			var/obj/effect/umbralfount/U = new /obj/effect/umbralfount(fountLoc, owner, 3)
			var/original_x = U.pixel_x
			var/original_y = U.pixel_y
			U.pixel_x = 32 * (aimed.x - U.x)
			U.pixel_y = 32 * (aimed.y - U.y)
			//Behold, the nonsense needed to make things spread out in a spiral. Basically, depending on the set of corners, invert behavior.
			if(((i%size < size/2) && (i/size < size/2)) || ((i%size >= size/2) && (i/size > size/2)))
				animate(U, pixel_x = original_x, time = 5, easing = SINE_EASING | EASE_OUT)
				animate(pixel_y = original_y, time = 5, easing = SINE_EASING | EASE_IN, flags = ANIMATION_PARALLEL)
			else
				animate(U, pixel_x = original_x, time = 5, easing = SINE_EASING | EASE_IN)
				animate(pixel_y = original_y, time = 5, easing = SINE_EASING | EASE_OUT, flags = ANIMATION_PARALLEL)
