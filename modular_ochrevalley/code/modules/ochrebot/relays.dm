/proc/amia_relaynote(target_ckey, admin_ckey, text, note_severity) //Still going to preface these with amia for internal consistency
	if(CONFIG_GET(flag/amia_enabled))
		var/roundid = url_encode(GLOB.rogue_round_id)
		var/encoded_targetkey = url_encode(ckey(target_ckey))
		var/encoded_adminkey = url_encode(ckey(admin_ckey))
		var/encoded_text = url_encode(text)
		var/encoded_severity = isnull(note_severity) ? "null" : url_encode(note_severity)
		var/constring =  amia_constring() + "noterelay?roundid=[roundid]&target=[encoded_targetkey]&admin=[encoded_adminkey]&text=[encoded_text]&severity=[encoded_severity]"
		var/list/response = world.Export(constring)
		if(!islist(response))
			log_runtime("Can't reach AMIA")
			return FALSE

/proc/amia_relayban(target_ckey, admin_ckey, text, role, time)
	if(CONFIG_GET(flag/amia_enabled))
		var/roundid = url_encode(GLOB.rogue_round_id)
		var/encoded_targetkey = url_encode(ckey(target_ckey))
		var/encoded_adminkey = url_encode(ckey(admin_ckey))
		var/encoded_text = url_encode(text)
		var/encoded_role = url_encode(role)
		var/encoded_time = url_encode(time)
		var/constring =  amia_constring() + "banrelay?roundid=[roundid]&target=[encoded_targetkey]&admin=[encoded_adminkey]&text=[encoded_text]&role=[encoded_role]&time=[encoded_time]"
		var/list/response = world.Export(constring)
		if(!islist(response))
			log_runtime("Can't reach AMIA")
			return FALSE
