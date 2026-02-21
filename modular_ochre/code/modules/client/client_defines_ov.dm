/client
	var/is_registered = FALSE

/client/proc/checkCkeyLink()
	is_registered = amia_whitelistcheck(ckey)
	return is_registered
