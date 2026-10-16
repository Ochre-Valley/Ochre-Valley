/obj/effect/landmark/remote_sanctuary_spawn
	name = "remote sanctuary spawn"
	icon_state = "x3"

/obj/effect/landmark/remote_sanctuary_spawn/Initialize(mapload)
	. = ..()
	SSremote_sanctuaries.all_sanctuary_markers += src
	SSremote_sanctuaries.markers_available += src

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
	/// All sanctuary markers that exist in the game world
	var/list/all_sanctuary_markers = list()
	/// Sanctuaries that have been claimed. Associated list; key is the ckey of the claimer, value is a reference to the sanctuary's data (See `/datum/sanctuary_info`).
	var/list/sanctuaries_claimed = list()
	/// Markers of sanctuaries that have not yet been claimed by a player.
	var/list/markers_available = list()
	/// Markers of sanctuaries that have been claimed by a player. Associated list; key is the ckey of the claimer, value is a reference to the marker the sanctuary used to spawn itself.
	var/list/markers_claimed = list()
	// There should ONLY EVER be ONE keymaster in the town and wretch coast! If there isn't, SOMEONE HAS FUCKED UP
	var/obj/item/roguemachine/keymaster/keymaster_town = null
	var/obj/item/roguemachine/keymaster/keymaster_wretchcoast = null
	var/portal_disappear_message = "dissolves into cerulean sparks that waver and fizzle out like dying embers."

	/// Turfs that the we will avoid spawning portals onto
	var/list/dangerous_turf_types = list(
		/turf/open/lava,
		/turf/open/transparent/openspace
	)

	/// Objects that the we will avoid spawning portals onto the turfs of
	var/list/dangerous_object_types = list(
		/obj/structure/glowshroom,
		/obj/item/restraints/legcuffs/beartrap,
		/obj/machinery/light/rogue/campfire

	)

/datum/controller/subsystem/remote_sanctuaries/proc/claim_sanctuary(var/mob/living/carbon/human/claimer, var/sanctuary_id, var/is_using_wretch_keymaster)
	var/datum/map_template/remote_sanctuary/claimed = get_claimed_sanctuary(claimer.ckey)
	if(claimed)
		to_chat(claimer, span_red("I've already claimed a sanctuary for this week."))
		return null
	try
		var/datum/sanctuary_data/data = spawn_sanctuary(claimer.ckey, sanctuary_id, is_using_wretch_keymaster, claimer.voice_color, claimer.real_name)
		message_admins("[ADMIN_LOOKUPFLW(claimer)] has claimed and spawned a remote sanctuary \"[data.used_template.name]\" costing [data.used_template.price] mammons at [ADMIN_VERBOSEJMP(data.min_turf)]")
		return data
	catch(var/exception/error)
		to_chat(claimer, span_alert("My sanctuary could not be created correctly because of an error! Scream at a developer about this:\n'[error.file], line [error.line]: [error]'"))
		return null

/datum/controller/subsystem/remote_sanctuaries/proc/spawn_sanctuary(var/owner_ckey, var/sanctuary_id, var/is_using_wretch_keymaster, var/owner_voice_color, var/owner_real_name)
	var/datum/map_template/remote_sanctuary/S = SSmapping.remote_sanctuary_templates[sanctuary_id]
	if(!length(markers_available))
		throw EXCEPTION("We couldn't find any landmarks to spawn a sanctuary at! Either there are no remaining non-claimed landmarks to spawn a sanctuary at (very unlikely,) or the z-level the remote sanctuaries require to work was never spawned (much more likely)!")
		return null
	var/obj/effect/landmark/remote_sanctuary_spawn/marker = markers_available[1]
	var/turf/T = marker.loc
	var/datum/sanctuary_data/data = new()
	data.min_x = T.x
	data.mix_y = T.y
	data.min_z = T.z
	data.min_turf = T
	data.max_x = T.x + S.width
	data.max_y = T.y + S.height
	data.max_z = T.z + S.floors
	data.used_template = S
	data.owner_voice_color = owner_voice_color
	data.owner_real_name = owner_real_name
	data.owner_ckey = owner_ckey
	markers_available.Remove(marker)
	sanctuaries_claimed[owner_ckey] = data
	markers_claimed[owner_ckey] = marker
	if(is_using_wretch_keymaster)
		data.sanctuary_return_point = keymaster_wretchcoast
	else
		data.sanctuary_return_point = keymaster_town

	S.load(T, FALSE)
	// We search specifically in the inner area of the sanctuary
	// because realistically there should never be anything of note on the very edges of the template maps!

	// Side note: I am also so very sorry for this messy messy process.
	// I genuinely could not think of a cleaner way to accomplish this.
	for(var/s_z in min(T.z, T.z + S.floors) to max(T.z, T.z + S.floors))
		for(var/s_x in min(T.x+1, T.x + S.width-2) to max(T.x+1, T.x + S.width-2))
			for(var/s_y in min(T.y+1, T.y + S.height-2) to max(T.y+1, T.y + S.height-2))
				var/turf/s_t = locate(s_x, s_y, s_z)
				if(!s_t)
					throw EXCEPTION("We attempted to generate a sanctuary in an impossible location! WUH OH")
				// Find every door and closet within our sanctuary's area
				// and assign it a lock that the user's sanctuary key will be able to lock/unlock
				var/obj/structure/mineral_door/D = locate() in s_t
				if(D)
					D.lockid = "sanctuary_[owner_ckey]"
					D.lockhash = GLOB.lockids[D.lockid]
				// Trying my best to ensure we locate() as few times as possible here...
				var/obj/structure/closet/C = null
				if(!D)
					C = locate() in s_t
					if(C)
						C.lockid = "sanctuary_[owner_ckey]"
						C.lockhash = GLOB.lockids[C.lockid]
				// If we don't already have an exit configured,
				// look for one and set our exit to it if it's there!
				if(!D && !C && !data.sanctuary_exit)
					data.sanctuary_exit = locate() in s_t
					if(data.sanctuary_exit)
						data.sanctuary_exit.data = data
				// Look for any and all items in the sanctuary.
				// Make them worthless by making them "special".
				// No, you will not be flipping sanctuaries for profits.
				for(var/atom/movable/A in s_t.contents)
					A.special_item = TRUE
	log_admin("[key_name(owner_ckey)] has claimed and spawned a remote sanctuary \"[S.name]\" costing [data.used_template.price] mammons at [ADMIN_VERBOSEJMP(T)]")
	return data

/// Returns the data of the remote sanctuary of the ckey (See `/datum/sanctuary_data`). Returns null if the ckey hasn't claimed one yet.
/datum/controller/subsystem/remote_sanctuaries/proc/get_claimed_sanctuary(var/sanctuary_owner_ckey)
	return sanctuaries_claimed[sanctuary_owner_ckey]

/// Creates a portal leading to and from a ckey's sanctuary.
///
/// - `sanctuary_owner_ckey`: Owner of the sanctuary we are making one of the portals for. The portal will be made at their sanctuary's exit (see `/datum/sanctuary_data.sanctuary_exit`).
///
/// #### Returns:
/// A value telling the success (or an error state) of the attempt to create the portals (see `modular_ochrevalley\code\__DEFINES\remote_sanctuary_defines.dm`).
/datum/controller/subsystem/remote_sanctuaries/proc/try_create_portals(var/sanctuary_owner_ckey)
	var/datum/sanctuary_data/D = get_claimed_sanctuary(sanctuary_owner_ckey)
	if (D.portal_to_gameworld || D.portal_to_sanctuary)
		return SANCTUARY_PORTAL_ERROR_PORTALSALREADYEXIST
	// Look for a viable (non-obstructed) location around both KEYMASTERs and make a portal at them.
	// If either return an error (a number and not a list,) return it.
	var/try_get_return_point_turfs  = get_portal_viable_turfs(D.sanctuary_return_point.loc)
	if(!islist(try_get_return_point_turfs))
		return try_get_return_point_turfs
	var/list/retrun_point_viable_turfs = try_get_return_point_turfs

	var/try_get_exit_turfs  = get_portal_viable_turfs(D.sanctuary_exit.loc)
	if(!islist(try_get_exit_turfs))
		return try_get_exit_turfs
	var/list/exit_viable_turfs = try_get_exit_turfs

	var/obj/structure/fluff/traveltile/sanctuary_portal/return_portal = new(pick(retrun_point_viable_turfs), TRUE) // Only the portal leading in shows the remote sanctuary disclaimer
	var/obj/structure/fluff/traveltile/sanctuary_portal/exit_portal = new(pick(exit_viable_turfs), FALSE)

	return_portal.filters += filter(type="outline", color="[D.owner_voice_color]40", size=2)
	return_portal.name = "[return_portal.name] ([D.owner_real_name])"
	return_portal.aportalid = "sanctuary_return_[sanctuary_owner_ckey]"
	return_portal.aportalgoesto = "sanctuary_exit_[sanctuary_owner_ckey]"
	D.portal_to_gameworld = return_portal

	exit_portal.filters += filter(type="outline", color="[D.owner_voice_color]40", size=2)
	exit_portal.name = "[exit_portal.name] ([D.owner_real_name])"
	exit_portal.aportalid = "sanctuary_exit_[sanctuary_owner_ckey]"
	exit_portal.aportalgoesto = "sanctuary_return_[sanctuary_owner_ckey]"
	D.portal_to_sanctuary = exit_portal

	addtimer(CALLBACK(src, PROC_REF(delete_portals), D), 1 MINUTES)

	return SANCTUARY_PORTAL_SUCCESSFUL

/datum/controller/subsystem/remote_sanctuaries/proc/delete_portals(datum/sanctuary_data/data)
	var/obj/structure/fluff/traveltile/sanctuary_portal/gw = data.portal_to_gameworld
	if(gw)
		gw.visible_message(span_notice("\The [gw] [portal_disappear_message]"))
		qdel(gw)
		data.portal_to_gameworld = null
	var/obj/structure/fluff/traveltile/sanctuary_portal/sanc = data.portal_to_sanctuary
	if(sanc)
		sanc.visible_message(span_notice("\The [sanc] [portal_disappear_message]"))
		qdel(sanc)
		data.portal_to_sanctuary = null

/// If successful in finding a space to spawn a portal, this returns a list of viable turfs to spawn a portal onto (as list).
///
/// If it is NOT successful, this instead returns an error detailing what happened (see `modular_ochrevalley\code\__DEFINES\remote_sanctuary_defines.dm`).
/datum/controller/subsystem/remote_sanctuaries/proc/get_portal_viable_turfs(turf/center)
	//var/list/gameworld_portal_turfs = RANGE_TURFS(2, center)
	var/list/gameworld_portal_turfs = list()
	for(var/turf/T in view(2, center))
		gameworld_portal_turfs.Add(T)
	var/list/non_obstructed_turfs = list()
	for(var/turf/T in gameworld_portal_turfs)
		var/is_viable = TRUE
		if(T.density)
			continue
		for(var/atom/A in T.contents)
			if(A.density)
				is_viable = FALSE
				break
		if(is_viable)
			non_obstructed_turfs.Add(T)
	// If no viable turfs remain by this point, they're obstructed! Report this back!
	if(!non_obstructed_turfs.len)
		return SANCTUARY_PORTAL_ERROR_OBSTRUCTEDTURFS
	// Now check for living mobs in those turfs. We don't want to spawn portals on top of a mob, after all!
	var/list/mobless_turfs = list()
	for(var/turf/T in non_obstructed_turfs)
		var/mob/living/M = locate() in T
		if(M)
			continue
		mobless_turfs.Add(T)
	if(!mobless_turfs.len)
		return SANCTUARY_PORTAL_ERROR_MOBSINWAY

	// Finally, check for turfs that don't have any immediate hazards on them
	var/list/safe_turfs = list()
	for(var/turf/T in mobless_turfs)
		var/is_safe = TRUE
		for(var/turf_type in dangerous_turf_types)
			if(istype(T, turf_type))
				is_safe = FALSE
				break
		if(!is_safe)
			continue
		for(var/object_type in dangerous_object_types)
			var/obj/the_danger = locate(object_type) in T
			if(the_danger)
				is_safe = FALSE
				break
		if(!is_safe)
			continue
		safe_turfs.Add(T)
	if(!safe_turfs.len)
		return SANCTUARY_PORTAL_ERROR_DANGEROUSTURFS

	// If we reached this point then we have viable spots to spawn portals on!
	return safe_turfs
