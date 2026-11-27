/// Component that forces gnolls out of invisibility after a delay, with a warning and telegraph.
/// These exist to stop gnolls from abusing their invisibility
/datum/component/gnoll_invisibility_restrictions
	/// The z-level of the ground floor of the town
	var/town_floor_zlevel
	/// Are we in an area where our invisibility is not allowed to be used?
	var/in_forbidden_area = FALSE
	///
	var/exit_grace_period = 5 SECONDS
	var/invis_break_timer

/datum/component/gnoll_invisibility_restrictions/Initialize(mapload)
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/human/H = parent
	if(!isgnoll(H) || !H.mind)
		return COMPONENT_INCOMPATIBLE

	var/town_z_bottommost = SSmapping.levels_by_trait(ZTRAIT_STATION)[1]
	switch(SSmapping.config.map_path)
		if("map_files/roguetest")
			town_floor_zlevel = town_z_bottommost
		if("map_files/jagged_jaw")
			town_floor_zlevel = town_z_bottommost + 2
		else
			town_floor_zlevel = town_z_bottommost + 1

	RegisterSignal(H, COMSIG_ENTER_AREA, PROC_REF(on_area_entered))
	RegisterSignal(H, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_changed_z_level))
	START_PROCESSING(SSprocessing, src)

/datum/component/gnoll_invisibility_restrictions/Destroy(force, silent)
	UnregisterSignal(parent, list(
		COMSIG_ENTER_AREA,
		COMSIG_MOVABLE_Z_CHANGED,
	))
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/component/gnoll_invisibility_restrictions/process()
	var/mob/living/carbon/human/H = parent
	// Check if we've activated invisibility and we aren't already counting down killing their invis
	if(in_forbidden_area)
		var/invisible = is_invisible()
		// If we're invsiible and a timer hasn't stared yet
		if(!invis_break_timer && invisible)
			to_chat(H, span_danger("I cannot be invisible here! I must become visible, NOW!"))
			balloonalert_area_forbidden(H, invisible)
			start_break_timer()
		// If there is a timer ticking but we're visible
		else if (invis_break_timer && !invisible)
			H.balloon_alert(H, "<font color = '#64dbdf'>Must stay visible here...</font>")
			stop_break_timer()


/datum/component/gnoll_invisibility_restrictions/proc/balloonalert_area_forbidden(mob/M, is_mob_invisible)
	if(is_mob_invisible)
		M.balloon_alert(M, "<font color = '#bb2b2b'>TURN VISIBLE OR LEAVE NOW.</font>")
	else
		M.balloon_alert(M, "<font color = '#bb2b2b'>Invis forbidden here!</font>")

/datum/component/gnoll_invisibility_restrictions/proc/sendmessage_area_forbidden(mob/M, is_mob_invisible)
	to_chat(M, span_warning("These accursed lands weaken the strength of my invisibility; it will not hold here."))
	balloonalert_area_forbidden(M, is_mob_invisible)

/datum/component/gnoll_invisibility_restrictions/proc/sendmessage_area_valid(mob/M)
	to_chat(M, span_warning("Here is safer... I may use my invisibility here."))
	M.balloon_alert(M, "<font color = '#64dbdf'>Invis allowed here...</font>")

/datum/component/gnoll_invisibility_restrictions/proc/start_break_timer()
	invis_break_timer = addtimer(CALLBACK(src, PROC_REF(break_invisibility)), exit_grace_period, TIMER_STOPPABLE)

/datum/component/gnoll_invisibility_restrictions/proc/stop_break_timer()
	if(invis_break_timer)
		deltimer(invis_break_timer)
		invis_break_timer = null

/datum/component/gnoll_invisibility_restrictions/proc/is_invisible()
	var/mob/living/carbon/human/H = parent
	return H.mob_timers[MT_INVISIBILITY] > world.time

/datum/component/gnoll_invisibility_restrictions/proc/break_invisibility(alert_admins = TRUE)
	var/mob/living/carbon/human/H = parent
	H.mob_timers[MT_INVISIBILITY] = world.time
	H.update_sneak_invis(reset = TRUE)
	if(H.rogue_sneaking)
		H.mob_timers[MT_FOUNDSNEAK] = world.time
	// Put their invis spell on cooldown so they can't disregard the alert and as a punishment
	for(var/obj/effect/proc_holder/spell/invoked/invisibility/invis_spell in H.mob_spell_list)
		invis_spell.charge_counter = 0
		invis_spell.action?.build_all_button_icons()
		INVOKE_ASYNC(invis_spell, TYPE_PROC_REF(/obj/effect/proc_holder/spell, start_recharge))
	H.visible_message(span_danger("\The [H] appears from nowhere, momentarily writhing and thrown off-balance!"), span_danger("My cover is torn away from my being! I am thrown off-balance! I AM EXPOSED!!"))
	// Obliterate them
	H.Immobilize(5 SECONDS)
	H.OffBalance(5 SECONDS)
	// In case they're trying to abuse the grace period for an invis escape, make them vulnerable and blow their cover as hard as possible.
	H.apply_status_effect(/datum/status_effect/debuff/vulnerable, 10 SECONDS)
	playsound(H, 'sound/combat/riposte.ogg', 100, TRUE)
	playsound(H, 'sound/vo/mobs/wwolf/painscream.ogg', 100, TRUE)
	var/turf/T = get_turf(H)
	T.loud_message("A pained, furious snarl bellows out", hearing_distance = 14)
	if(alert_admins)
		var/area/A = get_area(H)
		message_admins("([ADMIN_LOOKUPFLW(H)]), a GNOLL, had their invisibility broken by gnoll invis restriction mechanics due to lingering invisibly too long on the ground floor of the town (Area name: \"[A.name]\").")
		log_combat(H, null, ", a GNOLL, had their invisibility broken by gnoll invis restriction mechanics due to lingering invisibly too long on the ground floor of the town. Immobilized, sent off-balance, made vulnerable, and forced to send a loud emote that could be heard 14 tiles away.")
	stop_break_timer()

/datum/component/gnoll_invisibility_restrictions/proc/is_area_forbidden(area/A)
	var/mob/living/carbon/human/H = parent
	// Never forbidden if we're not on the ground floor of the town
	if(H.z != town_floor_zlevel)
		return FALSE
	var/static/list/forbidden_areas = list(
		/area/rogue/outdoors/town,
		/area/rogue/indoors/town,
		/area/rogue/outdoors/exposed/town,
	)
	for(var/area_type in forbidden_areas)
		if(istype(A, area_type))
			return TRUE
	return FALSE

/datum/component/gnoll_invisibility_restrictions/proc/on_area_entered(datum/source, area/new_area)
	var/mob/living/carbon/human/H = parent
	// Are we entering a forbidden area?
	if(is_area_forbidden(new_area))
		var/invisible = is_invisible()
		// If we're entering from a non-forbidden area, throw up the warning
		if(!in_forbidden_area)
			sendmessage_area_forbidden(H, invisible)
		in_forbidden_area = TRUE
		if(invisible)
			start_break_timer()
	// Check if we WERE in a forbidden area (in this case we've entered a valid area)
	else if(in_forbidden_area)
		in_forbidden_area = FALSE
		sendmessage_area_valid(H)
		stop_break_timer()

/datum/component/gnoll_invisibility_restrictions/proc/on_changed_z_level(atom/source, old_z, new_z, same_z_layer, notify_contents)
	var/mob/living/carbon/human/H = parent
	var/area/A = get_area(H)
	if(is_area_forbidden(A))
		in_forbidden_area = TRUE
		var/invisible = is_invisible()
		sendmessage_area_forbidden(H, invisible)
		if(!invis_break_timer && invisible)
			start_break_timer()
	else if(in_forbidden_area)
		in_forbidden_area = FALSE
		sendmessage_area_valid(H)
		stop_break_timer()
