/obj/effect/landmark/remote_sanctuary_spawn
	name = "remote sanctuary spawn"
	icon_state = "x3"

/obj/effect/landmark/remote_sanctuary_spawn/Initialize(mapload)
	. = ..()
	SSremote_sanctuaries.sanctuaries += src
	SSremote_sanctuaries.sanctuaries_available += src

/datum/controller/subsystem/mapping
	var/list/remote_sanctuary_templates = list()

/datum/controller/subsystem/mapping/proc/preload_remote_sanctuary_templates()
	for(var/datum/map_template/remote_sanctuary/sanctuary_type as anything in subtypesof(/datum/map_template/remote_sanctuary))
		if(!initial(sanctuary_type.mappath))
			continue
		var/datum/map_template/remote_sanctuary/S = new sanctuary_type()

		remote_sanctuary_templates[S.sanctuary_id] = S

SUBSYSTEM_DEF(remote_sanctuaries)
	name = "Remote Sanctuary"
	flags = SS_NO_FIRE
	/// All sanctuaries that exist in the game world
	var/list/sanctuaries = list()
	/// Sanctuaries that have been claimed. Associated list; key is the ckey of the claimer
	var/list/sanctuaries_claimed = list()
	/// Sanctuaries that have not yet been claimed by a player.
	var/list/sanctuaries_available = list()
	/// Associated list of template dmm files that players can purchase to claim as their own sanctuaries.
	var/list/available_templates = list()

/datum/controller/subsystem/remote_sanctuaries/proc/claim_sanctuary(var/mob/living/carbon/human/claimer, var/sanctuary_id)
	var/obj/effect/landmark/remote_sanctuary_spawn/claimed = get_claimed_sanctuary(claimer.ckey)
	if(claimed)
		to_chat(claimer, span_red("I've already claimed a sanctuary for this week."))
		return
	try
		spawn_sanctuary(claimer.ckey, sanctuary_id)
		to_chat(claimer, span_notice("My sanctuary is ready."))
	catch(var/exception/error)
		to_chat(claimer, span_alert("My sanctuary could not be created correctly because of an error! Scream at a coder about this:\n'[error]'"))

/datum/controller/subsystem/remote_sanctuaries/proc/spawn_sanctuary(var/owner_ckey, var/sanctuary_id)
	var/datum/map_template/remote_sanctuary/S = SSmapping.remote_sanctuary_templates[sanctuary_id]
	var/obj/effect/landmark/remote_sanctuary_spawn/marker = sanctuaries_available[1]
	var/turf/T = marker.loc
	S.load(T, FALSE)
	sanctuaries_available.Remove(marker)
	sanctuaries_claimed[owner_ckey] = marker
	log_admin("[key_name(owner_ckey)] has claimed and spawned a remote sanctuary at [ADMIN_VERBOSEJMP(T)]")

/datum/controller/subsystem/remote_sanctuaries/proc/get_claimed_sanctuary(var/sanctuary_owner_ckey)
	var/obj/effect/landmark/remote_sanctuary_spawn/claimed = sanctuaries_claimed[sanctuary_owner_ckey]
	return claimed
