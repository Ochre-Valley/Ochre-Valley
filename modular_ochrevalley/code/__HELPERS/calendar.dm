/proc/get_calendar_events_for_week(month_number, start_day)
	var/list/matches = list()
	var/cur_month = month_number
	var/cur_day = start_day
	for(var/i in 0 to 7)
		for(var/datum/calendar_event/event in GLOB.calendar_events)
			if(!(event in matches) && event.covers_day(cur_month, cur_day))
				matches += event
		if(cur_day >= 28)
			cur_month++
		cur_day = (cur_day % 28) + 1
		return matches
