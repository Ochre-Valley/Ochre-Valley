//OV add of vars here
#define MAP_VOTE_BASE_PERCENT 100
#define MAP_VOTE_OVERDUE_STEP_PERCENT 20
#define MAP_VOTE_OVERDUE_MAX_PERCENT 150 //basically identical to how storyteller in vote.dm works.
#define MAP_VOTE_WINNER_COOLDOWN_PERCENT 60
//OV end
#define LAST_MAP_VOTE_LOG_FILE "data/last_round/lastmap_vote.json"
/// Per-preset vote multiplier (in percent), carried between rounds.
#define MAP_VOTE_MULTIPLIER_FILE "data/last_round/map_vote_multipliers.json"
/// Multipliers are whole percentages because BYOND's 32-bit floats would turn e.g. 10 * 1.3 into 12.9


/* json file structure should look something like

MULTIPLIER FILE
map name, percentage (e.g is it 60, is it 150, is it somewhere in between, etc)
{"/datum/storyteller/gamemode/extended":60,"/datum/storyteller/gamemode/guaranteed_antag":150,"/datum/storyteller/gamemode/no_antag":150,"/datum/storyteller/gamemode/no_antag/standard":150,"/datum/storyteller/gamemode/no_antag/small_wretch":60}

LAST MAP VOTE FILE
copying how it is from original storyteller file, something like
{"state":"completed","votes":{"lightanddark1":{"choice":"Extended","vote_power":1}},"storyteller_vote":"/datum/storyteller/gamemode/extended","winner":"Extended"}
luckily we also don't need to delve too much, we just need map_vote and winner to get us the map name
*/
/datum/controller/subsystem/vote/proc/getmapvotebasepercent() //going for ol' reliable when I am not used to these funny python limitations
	return MAP_VOTE_BASE_PERCENT


/datum/controller/subsystem/vote/proc/load_map_vote_multipliers()
	map_vote_multipliers = list()
	var/json_file = file(MAP_VOTE_MULTIPLIER_FILE)
	if(!fexists(json_file))
		return FALSE
	var/list/file_data = safe_json_decode(file2text(json_file))
	if(!islist(file_data))
		return FALSE
	for(var/type_text in file_data)
		var/map_type = type_text //if we're not blank, then just pull the first arg? We know that's always a string.
		if(!config.maplist[map_type])
			continue
		var/percent = file_data[map_type]
		if(!isnum(percent))
			percent = text2num("[percent]")
		if(!isnum(percent))
			continue
		map_vote_multipliers[map_type] = clamp(round(percent), 0, MAP_VOTE_OVERDUE_MAX_PERCENT)
	return TRUE

/datum/controller/subsystem/vote/proc/save_map_vote_multipliers()
	var/list/file_data = list()
	for(var/map_type in map_vote_multipliers)
		file_data["[map_type]"] = map_vote_multipliers[map_type]
	var/json_file = file(MAP_VOTE_MULTIPLIER_FILE)
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))


/// After a completed player vote, every votable preset's multiplier climbs by the overdue step, then every preset
/// in the winning pool drops to the cooldown multiplier. Cooling the whole pool keeps a pool with several options
/// from chaining wins by shifting votes to a sibling preset that still carries its overdue bonus.
/datum/controller/subsystem/vote/proc/record_map_vote_win(winning_choice)
	load_map_vote_multipliers()
	for(var/othermaps in global.config.maplist)
		var/datum/map_config/curMap = config.maplist[othermaps]
		if(curMap.map_name == winning_choice)
			map_vote_multipliers[othermaps] = MAP_VOTE_WINNER_COOLDOWN_PERCENT
			continue
		map_vote_multipliers[othermaps] = min(get_map_vote_percent(othermaps) + MAP_VOTE_OVERDUE_STEP_PERCENT, MAP_VOTE_OVERDUE_MAX_PERCENT)
	save_map_vote_multipliers()
	var/list/mult_lines = list()
	for(var/maps in map_vote_multipliers)
		var/datum/map_config/curMap = config.maplist[maps]
		mult_lines += "[curMap ? curMap.map_name : maps]: x[get_map_vote_mult(maps)]"
	log_vote("Map vote multipliers for next vote: [length(mult_lines) ? jointext(mult_lines, ", ") : "none"]")

/// Puts one preset's multiplier, or every preset's if none is given, back to the base x1.
/datum/controller/subsystem/vote/proc/reset_map_vote_multipliers(storyteller_type = null)
	load_map_vote_multipliers()
	if(storyteller_type)
		map_vote_multipliers[storyteller_type] = MAP_VOTE_BASE_PERCENT
	else
		for(var/tracked_type in map_vote_multipliers)
			map_vote_multipliers[tracked_type] = MAP_VOTE_BASE_PERCENT
	save_map_vote_multipliers()

/// A preset's vote multiplier in percent. Presets with no record yet sit at the base.
/datum/controller/subsystem/vote/proc/get_map_vote_percent(map_type)
	var/percent = map_vote_multipliers[map_type]
	return isnum(percent) ? percent : MAP_VOTE_BASE_PERCENT

/// Display form of the multiplier, e.g. 1.3.
/datum/controller/subsystem/vote/proc/get_map_vote_mult(map_type)
	return get_map_vote_percent(map_type) / 100

/// An option's votes after its multiplier, rounded down. Only votes cast this vote count; the multiplier just
/// scales them, so a preset nobody voted for still scores 0. A preset that got any votes scores at least 1, so in
/// tiny lobbies a cooldown can't round the only votes cast down to nothing and void the vote.
/datum/controller/subsystem/vote/proc/get_map_effective_votes(option)
	var/votes = choices[option] || 0
	if(votes <= 0)
		return 0
	var/percent = get_map_vote_percent(option)
	return max(1, floor(votes * percent / 100))


/datum/controller/subsystem/vote/proc/get_map_winning_choices()
	var/list/winners = list()
	var/greatest_votes = 0
	for(var/option in choices)
		//for maps, we are getting a MAP NAME back from the voters
		var/map_type = global.config.maplist[option]
		if(!map_type)
			continue
		var/option_votes = get_map_effective_votes(option)
		if(option_votes > greatest_votes)
			greatest_votes = option_votes
			winners = list(option)
		else if(option_votes == greatest_votes && option_votes > 0)
			winners += option
	return winners


/datum/controller/subsystem/vote/proc/load_map_vote_log()
	var/json_file = file(LAST_MAP_VOTE_LOG_FILE)
	if(!fexists(json_file))
		return FALSE
	var/list/file_data = safe_json_decode(file2text(json_file))
	if(!islist(file_data))
		return FALSE
	var/list/file_votes = file_data["votes"]
	if(!islist(file_votes))
		return FALSE
	voted.Cut()
	vote_selections.Cut()
	vote_powers.Cut()
	map_vote_log.Cut()
	for(var/voter_ckey in file_votes)
		var/list/vote_data = file_votes[voter_ckey]
		if(!islist(vote_data))
			continue
		var/choice_name = vote_data["choice"]
		var/vote_power = vote_data["vote_power"]
		if(!(choice_name in choices))
			continue
		voted += voter_ckey
		vote_selections[voter_ckey] = choice_name
		vote_powers[voter_ckey] = vote_power
		map_vote_log[voter_ckey] = list(
			"choice" = choice_name,
			"vote_power" = vote_power,
		)
	return TRUE

/datum/controller/subsystem/vote/proc/save_map_vote_log(winning_choice = null, state = "active", starting_pop = null)
	var/json_file = file(LAST_MAP_VOTE_LOG_FILE)
	var/list/file_data = list()
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	else
		file_data = safe_json_decode(file2text(json_file))
	if(!islist(file_data))
		file_data = list()
	file_data["state"] = state
	var/winner_name = get_map_choice_name(winning_choice)
	if(winner_name)
		file_data["winner"] = winner_name
	else
		file_data -= "winner"
	if(!isnull(starting_pop))
		file_data["map_vote_pop"] = starting_pop
	var/list/votes = list()
	for(var/voter_ckey in map_vote_log)
		var/list/vote_data = map_vote_log[voter_ckey]
		if(!islist(vote_data))
			continue
		votes[voter_ckey] = list(
			"choice" = vote_data["choice"],
			"vote_power" = vote_data["vote_power"],
		)
	file_data["votes"] = votes
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/vote/proc/get_map_choice_name(choice_text)
	if(!choice_text)
		return null
	if(global.config.maplist[choice_text])
		var/datum/map_config/map_type = global.config.maplist[choice_text]
		return map_type?.map_name

	return strip_html("[choice_text]")
