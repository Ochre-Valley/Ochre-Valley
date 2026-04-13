
/proc/amia_ahelprelay(ticketid, initckey, msg)
	if(CONFIG_GET(flag/amia_enabled)) //Yes I know we had a check, but what about a second check?
		var/roundid = url_encode(GLOB.rogue_round_id)
		var/roundtime
		if (SSticker.HasRoundStarted())
			roundtime = url_encode(time2text(STATION_TIME_PASSED(), "hh:mm", 0))
		else
			roundtime = "Pregame"
		//OV Edit Start: List Active Admins
		var/alist = get_admin_counts(0)["present"]
		var/anames = list()
		for(var/client/A in alist)
			anames += "\n[A.ckey]"
		var/encodednames = url_encode(json_encode(list(anames)))
		//OV Edit End
		var/encodedckey = url_encode(initckey)
		var/encodedmsg = url_encode(msg)
		var/constring =  amia_constring() + "ahelprelay?roundid=[roundid]&roundtime=[roundtime]&ticketid=[ticketid]&ckey=[encodedckey]&msg=[encodedmsg]&admins=[encodednames]" //OV Edit: List active admins
		var/list/response = world.Export(constring)
		if(!islist(response))
			log_runtime("Can't reach AMIA")
			return FALSE
//OV Edit Start
/proc/ahelphandled(ticketid, handler)
	if(CONFIG_GET(flag/amia_enabled))
		var/encodedhandler = url_encode(handler)
		var/constring = amia_constring() + "ahelphandled?ticketid=[ticketid]&handler=[encodedhandler]"
		var/list/response = world.Export(constring)
		if(!islist(response))
			log_runtime("Can't reach AMIA")
			return FALSE
//OV Edit End
