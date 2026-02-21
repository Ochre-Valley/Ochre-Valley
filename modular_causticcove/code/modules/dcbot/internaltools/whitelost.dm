/proc/amia_whitelistcheck(ckey)
	if(CONFIG_GET(flag/amia_enabled))
		var/encondedckey = url_encode(ckey)
		var/constring =  amia_constring() + "CheckWL?ckey=[encondedckey]" 
		var/list/response = world.Export(constring)
		if(response.len == 2) //OV Edit: The list is two long when it fails, the old check if it didn't exist would never proc
			log_runtime("Can't reach OchreBot") //OV Edit: Clear up confusion, since our bot is not named Automatic Mia
			return TRUE //OV Edit: Since this stops people from playing now, default to TRUE
		var/content = file2text(response["CONTENT"])
		var/list/decoded = json_decode(content)
		if(decoded["ok"])
			return TRUE
		else
			return FALSE
	else
		return TRUE //OV Edit: Since this stops people from playing now, default to TRUE
