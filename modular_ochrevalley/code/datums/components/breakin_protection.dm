/// Component intended to be used in conjunction with /datum/element/breakin_rules_enforcement. Items with that element will be unable to be used on atoms with this protection component.
/datum/component/breakin_protection
	/// Message sent to the user if they attempt to break into our parent and are stopped from doing so.
	var/breakin_prevented_message
	/// Message shown in an OOC notice when a player examines our parent.
	var/examine_message

/datum/component/breakin_protection/Initialize(breakin_prevented_message, examine_message)
	. = ..()
	if(!istype(parent, /obj/structure/mineral_door))
		return ELEMENT_INCOMPATIBLE
	src.breakin_prevented_message = breakin_prevented_message
	src.examine_message = examine_message

	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_MOVABLE_CROSSED, PROC_REF(on_crossed))

/datum/component/breakin_protection/Destroy(force, silent)
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_PARENT_EXAMINE,
		COMSIG_MOVABLE_CROSSED,
	))

/datum/component/breakin_protection/proc/on_crossed(datum/source, atom/movable/AM)
	// Check to see if what crossed us is a gnoll
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/H = AM
	if(!isgnoll(H))
		return
	// So they're a gnoll... Check if they're invisible and/or sneaking
	// If they are, break either
	if(H.mob_timers[MT_INVISIBILITY] > world.time)
		H.mob_timers[MT_INVISIBILITY] = world.time
		H.update_sneak_invis(reset = TRUE)
		if(H.rogue_sneaking)
			H.mob_timers[MT_FOUNDSNEAK] = world.time
		// Put their invis spell on cooldown so they can't disregard the alert and as a punishment
		for(var/obj/effect/proc_holder/spell/invoked/invisibility/invis_spell in H.mob_spell_list)
			invis_spell.charge_counter = 0
			invis_spell.action?.build_all_button_icons()
			INVOKE_ASYNC(invis_spell, TYPE_PROC_REF(/obj/effect/proc_holder/spell, start_recharge))

		var/obj/structure/mineral_door/D = parent
		// Stun them so they feel more encouraged to read the chat and stop them from proceeding
		H.Stun(5 SECONDS)
		H.balloon_alert(H, "<font color = '#bb2b2b'>Read the chat!</font>")
		// Log the break-in, inform admins, and give the gnoll a big warning to GTFO
		to_chat(H, fieldset_block("OOC NOTICE", span_danger("The server rules protect [D.name] from break-ins and infiltration. By sneaking here, you are likely breaking server rules regarding breaking and entering. As such, your invisibility has been broken. Leave the area now."), "breakin_protection_block"))
		message_admins("([ADMIN_LOOKUPFLW(H)]), a GNOLL, attempted to invisibly sneak through rules-protected door ([D.name]), but was revealed and had invisibility broken by break-in protection mechanics. Likely failed to examine the door to see it is OOC protected, or worse ignored server rules. [ADMIN_JMP(D)]")
		log_admin("([key_name(H)]), a GNOLL, attempted to invisibly sneak through rules-protected door ([D.name]) at X:[D.x] Y:[D.y] Z:[D.z], but was revealed and had invisibility broken by break-in protection mechanics. Likely failed to examine the door to see it is OOC protected, or worse ignored server rules.")
		playsound(H, 'sound/misc/notice.ogg', 100, FALSE)

/datum/component/breakin_protection/proc/on_examine(atom/movable/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += fieldset_block("OOC NOTICE", span_baotha_plain(examine_message), "breakin_protection_block")
