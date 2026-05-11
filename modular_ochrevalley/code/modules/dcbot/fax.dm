/proc/sendfax(role, msg)
	if(CONFIG_GET(flag/amia_enabled))
		var/encodedrole = url_encode(role)
		var/encodedmsg = url_encode(msg)
		var/constring = amia_constring() + "sendfax?role=[encodedrole]&msg=[encodedmsg]"
		var/list/response = world.Export(constring)
		if(!islist(response))
			log_runtime("Can't reach AMIA")
			return FALSE
		return TRUE
	return FALSE
/proc/dofax(mob/user)
	var/list/roles = list()
	for(var/rolepath in typesof(/datum/job/roguetown))
		var/datum/job/roguetown/role = new rolepath()
		if(role.spawn_positions>0 && !istype(role, /datum/job/roguetown/heartfelt)) //Let's not let you request roles that can't spawn? Heartfelts too
			roles |= role.title
	var/reqrole = tgui_input_list(user, "Pick the role to request.", "Missive", roles)
	if(!reqrole)
		return FALSE
	var/reason = tgui_input_text(user, "Provide a reason for the missive (Keep IC information or information on the current round to a minimum)", "Missive", multiline=TRUE)
	if(!reason)
		return FALSE
	message_admins("[key_name(user)] sent a missive for [reqrole]: [reason]")
	log_admin("[key_name(user)] sent a missive for [reqrole]: [reason]")
	return sendfax(reqrole, reason)

/datum/status_effect/debuff/missivecooldown
	id = "missivecooldown"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/missivecooldown

/atom/movable/screen/alert/status_effect/debuff/missivecooldown
	name = "Recent missive"
	desc = "I'll have to wait a bit before sending another missive!"
