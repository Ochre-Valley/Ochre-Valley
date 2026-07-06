	
/datum/world_topic/givebenefits
	keyword = "givebenefits"
	require_comms_key = TRUE
/datum/world_topic/givebenefits/Run(list/input)
	if(!("ckey" in input))
		return "No ckey given!"
	var/key = input["ckey"]
	if(donator_addkey(key))
		message_admins("Ochrebot added [key] to the donator list.")
		log_admin("Ochrebot added [key] to the donator list.")
		return "Ochrebot added [key] to the donator list."
	return "Ckey is invalid, or [key] is already on donator list."
