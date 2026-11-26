/// Element intended to be put on lockpicking/break-in items, which prevents them from attacking atoms with the breakin_protection component
/datum/element/breakin_rules_enforcement

/datum/element/breakin_rules_enforcement/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ITEM_PRE_ATTACK, PROC_REF(preattack_intercept))

/datum/element/breakin_rules_enforcement/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, COMSIG_ITEM_PRE_ATTACK)

/datum/element/breakin_rules_enforcement/proc/preattack_intercept(obj/item/source, obj/attacked, mob/living/user, params)
	SIGNAL_HANDLER
	if(!istype(attacked))
		return
	// Check if the target has a breakin protection component
	var/datum/component/breakin_protection/BC = attacked.GetComponent(/datum/component/breakin_protection)
	if(!BC)
		return
	// If it is, cancel the item's attack, tell the user they can NOT lockpick this, and alert admins
	to_chat(user, fieldset_block("OOC NOTICE", span_danger(BC.breakin_prevented_message), "breakin_protection_block"))
	message_admins("[ADMIN_LOOKUPFLW(user)]) attempted to break into rules-protected door ([attacked.name]) with a lockpicking tool ([source.name]), but was denied by break-in protection mechanics. Likely failed to examine the door to see it is OOC protected, or worse ignored server rules. [ADMIN_JMP(attacked)]")
	log_admin("([key_name(user)]) attempted to break into rules-protected door ([attacked.name]) at X:[attacked.x] Y:[attacked.y] Z:[attacked.z] with a lockpicking tool ([source.name]), but was denied by break-in protection mechanics. Likely failed to examine the door to see it is OOC protected, or worse ignored server rules.")
	SEND_SOUND(user, sound('sound/misc/notice.ogg'))
	user.changeNext_move(CLICK_CD_EXHAUSTED) // BIG fucking delay to make sure they actually read

	return COMPONENT_NO_ATTACK
