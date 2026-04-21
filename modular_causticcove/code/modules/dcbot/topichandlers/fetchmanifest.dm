/datum/world_topic/fetchmanifest
	keyword = "fetchmanifest"
	log = FALSE

/datum/world_topic/fetchmanifest/Run(list/input)
	//OVEdit: Get storyteller too!
	var/datum/storyteller/st = new SSgamemode.selected_storyteller
	var/dat = ("**Round Time:** [time2text(STATION_TIME_PASSED(), "hh:mm", 0)]\t**Storyteller:** [st ? st.name : "none"]\n") //OV Edit: Add round timer
	//OV Edit End
	var/list/sortedActors = get_sorted_actors_list()
	//OVEdit Start: Behind the scenes stuff to fancify fetchmanifest
	var/list/actordat = list(
	"Ducal Family" = "",
	"Courtiers" = "",
	"Retinue" = "",
	"Garrison" = "",
	"Church" = "",
	"Burgher" = "",
	"Peasant" = "",
	"Sidefolk" = "",
	"Inquisition" = "",
	"Wanderer" = "",
	"Nobodies" = "")
	for(var/X in sortedActors)
		if(sortedActors[X]["category"] in actordat)
			if(length(actordat[sortedActors[X]["category"]]) == 0)
				actordat[sortedActors[X]["category"]] += "\n**-[sortedActors[X]["category"]]-**\n"
			actordat[sortedActors[X]["category"]] += ("[sortedActors[X]["data"]["name"]]" + " as " + "[sortedActors[X]["data"]["rank"]]\n")
	for(var/group in actordat)
		dat += actordat[group]
	//OVEdit End
	return dat
