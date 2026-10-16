GLOBAL_LIST_EMPTY(reformation_portals)

//Testing respawn bullshit because fuck you
/obj/structure/respawn_portal
	name = "mysterious portal"
	desc = "A gate that's said to spit out Necra's unwanted denizens."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"
	max_integrity = 99999
	anchored = TRUE
	density = FALSE
	layer = BELOW_OBJ_LAYER
	var/datum/looping_sound/boneloop/soundloop
	var/spawning = FALSE

	attacked_sound = 'sound/vo/mobs/ghost/skullpile_hit.ogg'

/obj/structure/respawn_portal/Initialize()
	. = ..()
//	soundloop = new(list(src), FALSE) //OV REMOVE
//	soundloop.start() //OV REMOVE

/obj/structure/respawn_portal/attack_ghost(mob/dead/observer/user) //Bit Jank for now but just copied over the Reform Option code... Maybe this will work? If a Ghost escapes the belly somehow lol
	if(QDELETED(user))
		return
	if(!in_range(src, user))
		return
	user.vore_death = FALSE //OV_ADD
	var/turf/portal_loc = get_turf(src) //OV ADD
	user.bring_body(portal_loc) //OV EDIT
	user.rise_body()
	qdel(src)

/obj/structure/respawn_portal/Destroy()
//	soundloop.stop() //OV REMOVE
	. = ..()

/mob/dead/observer/proc/bring_body(var/turf/portal_loc) //OV EDIT
	if(!client)
		return
	if(!mind || QDELETED(mind.current))
		to_chat(src, span_warning("I have no body."))
		return
	if(!can_reenter_corpse)
		to_chat(src, span_warning("I cannot re-enter my body."))
		return
	if(mind.current.key && copytext(mind.current.key,1,2)!="@")	//makes sure we don't accidentally kick any clients
		to_chat(usr, span_warning("Another consciousness is in my body... It is resisting me."))
		return
//	stop_all_loops()
	SSdroning.kill_rain(src.client)
	SSdroning.kill_loop(src.client)
	SSdroning.kill_droning(src.client)
	remove_client_colour(/datum/client_colour/monochrome)
	client.change_view(CONFIG_GET(string/default_view))
	client?.verbs -= GLOB.ghost_verbs
	SStgui.on_transfer(src, mind.current) // Transfer NanoUIs.
	mind.remove_antag_datum(/datum/antagonist/zombie)
	//OV edit
	mind.current.muffled = FALSE
	if(portal_loc)
		mind.current.forceMove(portal_loc)
	else
		mind.current.forceMove(get_turf(src))
	//OV edit end
	mind.current.key = key
	return TRUE

/mob/dead/observer/proc/rise_body()
	var/mob/living/carbon/human/bigbad = mind.current
	bigbad.enabled = TRUE
	bigbad.revive(TRUE, TRUE)
	bigbad.alpha = 255

//OV edit
// Permanent respawn points

/obj/structure/respawn_portal/permanent
	name = "vore reformation portal"
	desc = "A gate that's said to spit out Necra's unwanted denizens, only to be used by those who perished inside of another."
	icon = 'modular_ochrevalley/icons/roguetown/misc/structure.dmi'
	icon_state = "voreportal"
	invisibility = INVISIBILITY_OBSERVER

/obj/structure/respawn_portal/permanent/Initialize()
	. = ..()
	GLOB.reformation_portals += src

/obj/structure/respawn_portal/permanent/Destroy()
	. = ..()
	GLOB.reformation_portals -= src


/obj/structure/respawn_portal/permanent/attack_ghost(mob/dead/observer/user)
	if(!user.vore_death)
		to_chat(user, span_warning("This portal can only resurrect those who were devoured."))
		return
	var/want_to_respawn = tgui_alert(user, "This portal will resurrect you at this location. It is heavily advised that you forget the cirumstances of your death, you must not come back and make a problem for the person who ate you. Are you sure you want to reform?", "Reformation",list("Yes", "No"))
	if(!want_to_respawn || (want_to_respawn == "No"))
		return
	if(QDELETED(user))
		return
	if(!in_range(src, user))
		return
	user.vore_death = FALSE
	var/turf/portal_loc = get_turf(src)
	user.bring_body(portal_loc)
	user.rise_body()
//OV edit end
