/datum/round_event_control/antagonist/solo/lich
	name = "Lich"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_LICH
	shared_occurence_type = SHARED_HIGH_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	storyteller_guarantee_flags = STORYTELLER_FAVOR_LICH

	denominator = 80

	base_antags = 1
	maximum_antags = 2

	weight = 0	//i hate you CC edit: Disabled. Was originally 2.
	max_occurrences = 0 // mashallah //OV Edit: Disabled. Was 1.

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/lich
	antag_datum = /datum/antagonist/lich

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event_control/antagonist/solo/lich/preRunEvent()
	if(is_storyteller_villain_blocked())
		return EVENT_CANT_RUN
	return ..()

/datum/round_event/antagonist/solo/lich
