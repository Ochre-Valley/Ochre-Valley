#define DEFAULT_OOC_INFO (span_baotha_plain("This is a scene tool, intended to be used only in scenes and nothing more. Do not this for mechanical game advantages."))
/datum/element/scene_tool
	/// Message shown to the player when they examine something with this element.
	var/ooc_info

/datum/element/scene_tool/Attach(datum/target, ooc_info = DEFAULT_OOC_INFO)
	..()
	src.ooc_info = ooc_info
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/element/scene_tool/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, COMSIG_PARENT_EXAMINE)

/datum/element/scene_tool/proc/on_examine(atom/movable/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += fieldset_block("OOC NOTICE", ooc_info, "ooc_info_block")

#undef DEFAULT_OOC_INFO
