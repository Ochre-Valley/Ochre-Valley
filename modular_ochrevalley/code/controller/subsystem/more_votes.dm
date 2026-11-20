#define MAP_VOTE_BASE_PERCENT 100
#define MAP_VOTE_OVERDUE_STEP_PERCENT 20
#define MAP_VOTE_OVERDUE_MAX_PERCENT 150 //basically identical to how storyteller in vote.dm works.
#define MAP_VOTE_WINNER_COOLDOWN_PERCENT 60
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
/datum/controller/subsystem/vote/proc/load_map_vote_multipliers()
	map_vote_multipliers = list()
	var/json_file = file(MAP_VOTE_MULTIPLIER_FILE)
	if(!fexists(json_file))
		return FALSE
	var/list/file_data = safe_json_decode(file2text(json_file))
	if(!islist(file_data))
		return FALSE
	for(var/type_text in file_data)
		var/map_type = text2path(type_text)
		if(!config.maplist[map_type])
			continue
		var/percent = file_data[type_text]
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
		if(curMap == winning_choice)
			map_vote_multipliers[othermaps] = MAP_VOTE_WINNER_COOLDOWN_PERCENT
			continue
		map_vote_multipliers[othermaps] = min(get_storyteller_vote_percent(storyteller_type) + STORYTELLER_OVERDUE_STEP_PERCENT, STORYTELLER_OVERDUE_MAX_PERCENT)
	save_storyteller_vote_multipliers()
	var/list/mult_lines = list()
	for(var/storyteller_type in storyteller_vote_multipliers)
		var/datum/storyteller/storyboy = SSgamemode.storytellers?[storyteller_type]
		mult_lines += "[storyboy ? storyboy.name : storyteller_type]: x[get_storyteller_vote_mult(storyteller_type)]"
	log_vote("Storyteller vote multipliers for next vote: [length(mult_lines) ? jointext(mult_lines, ", ") : "none"]")

/// Puts one preset's multiplier, or every preset's if none is given, back to the base x1.
/datum/controller/subsystem/vote/proc/reset_storyteller_vote_multipliers(storyteller_type = null)
	load_storyteller_vote_multipliers()
	if(storyteller_type)
		storyteller_vote_multipliers[storyteller_type] = STORYTELLER_VOTE_BASE_PERCENT
	else
		for(var/tracked_type in storyteller_vote_multipliers)
			storyteller_vote_multipliers[tracked_type] = STORYTELLER_VOTE_BASE_PERCENT
	save_storyteller_vote_multipliers()

/// A preset's vote multiplier in percent. Presets with no record yet sit at the base.
/datum/controller/subsystem/vote/proc/get_storyteller_vote_percent(storyteller_type)
	var/percent = storyteller_vote_multipliers[storyteller_type]
	return isnum(percent) ? percent : STORYTELLER_VOTE_BASE_PERCENT

/// Display form of the multiplier, e.g. 1.3.
/datum/controller/subsystem/vote/proc/get_storyteller_vote_mult(storyteller_type)
	return get_storyteller_vote_percent(storyteller_type) / 100

/// An option's votes after its multiplier, rounded down. Only votes cast this vote count; the multiplier just
/// scales them, so a preset nobody voted for still scores 0. A preset that got any votes scores at least 1, so in
/// tiny lobbies a cooldown can't round the only votes cast down to nothing and void the vote.
/datum/controller/subsystem/vote/proc/get_storyteller_effective_votes(option)
	var/votes = choices[option] || 0
	if(votes <= 0)
		return 0
	var/percent = get_storyteller_vote_percent(get_storyteller_choice_type(option))
	return max(1, floor(votes * percent / 100))

/datum/controller/subsystem/vote/proc/get_storyteller_vote_pool(storyteller_type)
	if(!ispath(storyteller_type, /datum/storyteller))
		return null
	return SSgamemode.get_story_pool(storyteller_type)

/datum/controller/subsystem/vote/proc/get_storyteller_pool_totals()
	var/list/pool_totals = list()
	for(var/option in choices)
		var/storyteller_type = get_storyteller_choice_type(option)
		var/pool_name = get_storyteller_vote_pool(storyteller_type)
		if(!pool_name)
			continue
		pool_totals[pool_name] = (pool_totals[pool_name] || 0) + get_storyteller_effective_votes(option)
	return pool_totals

/datum/controller/subsystem/vote/proc/get_storyteller_pool_winners()
	var/list/pool_totals = get_storyteller_pool_totals()
	var/greatest_votes = 0
	for(var/pool_name in pool_totals)
		var/pool_votes = pool_totals[pool_name] || 0
		if(pool_votes > greatest_votes)
			greatest_votes = pool_votes
	var/list/winning_pools = list()
	if(!greatest_votes)
		return winning_pools
	for(var/pool_name in pool_totals)
		if((pool_totals[pool_name] || 0) == greatest_votes)
			winning_pools += pool_name
	return winning_pools

/datum/controller/subsystem/vote/proc/get_storyteller_winning_choices(list/winning_pools)
	var/list/winners = list()
	if(!length(winning_pools))
		return winners
	var/greatest_votes = 0
	for(var/option in choices)
		var/storyteller_type = get_storyteller_choice_type(option)
		var/pool_name = get_storyteller_vote_pool(storyteller_type)
		if(!(pool_name in winning_pools))
			continue
		var/option_votes = get_storyteller_effective_votes(option)
		if(option_votes > greatest_votes)
			greatest_votes = option_votes
			winners = list(option)
		else if(option_votes == greatest_votes && option_votes > 0)
			winners += option
	return winners
