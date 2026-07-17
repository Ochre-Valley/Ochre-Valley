/datum/world_topic/kickplayer
	keyword = "kickplayer"
	require_comms_key = TRUE

/datum/world_topic/kickplayer/Run(list/input)
	if(!("ckey" in input))
		return "No ckey given!"
	for(var/client/C in GLOB.clients)
		if(C.ckey == input["ckey"])
			to_chat(C, span_danger("You have been kicked for leaving the discord. An active presence is required to remain connected to the server."))
			log_admin("Ochrebot presence checking has kicked [key_name(C)].")
			message_admins(span_adminnotice("Ochrebot presence checking has kicked [key_name_admin(C)]."))
			qdel(C)
			return "Client with ckey [input["ckey"]] successfully kicked for failing presence check."
	return "Client with ckey [input["ckey"]] does not exist or is not connected."
	
