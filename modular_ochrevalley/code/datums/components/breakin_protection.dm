/// Component intended to be used in conjunction with /datum/element/breakin_rules_enforcement. Items with that element will be unable to be used on atoms with this protection component.
/datum/component/breakin_protection
	var/breakin_prevented_message
	var/examine_message

/datum/component/breakin_protection/Initialize(breakin_prevented_message, examine_message)
	. = ..()
	if(!istype(parent, /obj/structure/mineral_door))
		return ELEMENT_INCOMPATIBLE
	src.breakin_prevented_message = breakin_prevented_message
	src.examine_message = examine_message

	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/breakin_protection/Destroy(force, silent)
	. = ..()
	UnregisterSignal(parent, COMSIG_PARENT_EXAMINE)

/datum/component/breakin_protection/proc/on_examine(atom/movable/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += fieldset_block("OOC NOTICE", span_baotha_plain(examine_message), "breakin_protection_block")
