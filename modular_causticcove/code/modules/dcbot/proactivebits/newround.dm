/proc/newround()
	if(CONFIG_GET(flag/amia_enabled))
		var/constring =  amia_constring() + "newround"
		var/current_date = resolve_ic_date_parts(GLOB.dayspassed)
		var/list/holidays = get_calendar_events_for_week(current_date[2], current_date[1])
		var/list/holiday_names = resolve_holidays_to_printable(holidays)
		var/data = "?date=[url_encode(get_ic_date_short_as_string(GLOB.dayspassed))]&holidays=[json_encode(list(holiday_names))]"
		var/list/response = world.Export(constring + data)
		if(!islist(response))
			log_runtime("Can't reach AMIA")


/proc/resolve_holidays_to_printable(list/holidays)
	var/list/holiday_names = list()
	for(var/datum/calendar_event/E in holidays)
		var/formatted = "\n[E.title] [E.duration_days > 1 ? "from" : "on"] [E.recur_day] [get_month_number_to_text(E.recur_month)]"
		if(E.duration_days > 1)
			var/end_day = E.recur_day + E.duration_days
			formatted += " to [end_day > 28 ? end_day % 28 : end_day] [get_month_number_to_text((end_day > 28 ? E.recur_month + 1 : E.recur_month))]"
		holiday_names += formatted
	return holiday_names
