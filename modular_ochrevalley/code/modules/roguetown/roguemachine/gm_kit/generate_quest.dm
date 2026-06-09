/client/proc/generate_quest_kill()
	set name = "Generate Kill Quest"
	set category = "Game Master"
	set hidden = 0

	var/mob/user = src.mob

	var/list/list_of_mobs = typesof(/mob/living)
	var/current_mob_count = 0
	var/list/quest_mobs = list()

	var/quest_title = tgui_input_text(user, "What is the quest title?", "Title")
	if(!quest_title)
		return
	var/reward = tgui_input_number(user, "How much coin should be rewarded on completion?", "Reward", 150)
	if(!reward)
		return
	
	var/bands_of_threat = tgui_input_number(user, "How many bands of threat does it remove?", "Threat", 1, 20)
	if(!bands_of_threat)
		return
	
	var/list/regions = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		regions[TR.region_name] = TR
	var/selected = tgui_input_list(user, "Pick a region for the quest.", "Region", regions)
	var/datum/threat_region/where_to_spawn = regions[selected]
	/*var/datum/threat_region/where_to_spawn = tgui_input_list(user, "Pick a region for the quest.", "Region", SSregionthreat.threat_regions)
	if(!where_to_spawn)
		return
	to_chat(user, "The region selected is: [where_to_spawn?.region_name]")*/

	while(current_mob_count < 21)
		var/mob_to_add = tgui_input_list(user, "Choose a mob that needs killing, cancel to finish adding mobs.", "Mob", list_of_mobs)
		if(!mob_to_add)
			break
		else
			var/remaining_count = 20 - current_mob_count
			var/number_to_add = tgui_input_number(user, "How many of this mob to include?", "Mob", 1, remaining_count)
			while(number_to_add > 0)
				quest_mobs += mob_to_add
				number_to_add--
				current_mob_count++
	
	if(!quest_mobs.len)
		return

	var/crimes = tgui_input_text(user, "Whereof they stand accused of:", "Message Text")
	
	var/ledger_or_floor = tgui_input_list(user, "Spawn in a ledger or on the floor?", "Scroll", list("Ledger", "Floor", "Cancel"))
	if(!ledger_or_floor || (ledger_or_floor == "Cancel"))
		return
	
	var/fellowship_size = 0
	if(ledger_or_floor == "Ledger")
		fellowship_size = tgui_input_number(user, "Minimum fellowship size?", "Threat", 1, 6)
		if(fellowship_size == 1)
			fellowship_size = 0
	
	var/spawn_loc = get_turf(user)

	SSquestpool.gm_kill_quest(quest_title, reward, bands_of_threat, fellowship_size, where_to_spawn, quest_mobs, ledger_or_floor, spawn_loc, crimes)

/datum/controller/subsystem/questpool/proc/gm_kill_quest(quest_title, reward, bands_of_threat, fellowship_size, datum/threat_region/where_to_spawn, list/quest_mobs, ledger_or_floor, spawn_loc, crimes)
	var/datum/quest/kill/generated/Q = new /datum/quest/kill/generated()
	if(!Q)
		return null
	Q.quest_mobs = quest_mobs
	Q.threat_bands_cleared = bands_of_threat
	Q.title = quest_title
	if(crimes)
		Q.rolled_crimes = list(crimes)
	Q.required_fellowship_size = fellowship_size
	Q.quest_difficulty = "Special"
	Q.created_at = world.time
	Q.issued_day = GLOB.dayspassed
	Q.quest_giver_name = "The Grand Duchy of Azuria"
	var/region_name = where_to_spawn?.region_name
	var/obj/effect/landmark/quest_spawner/landmark = find_quest_landmark(QUEST_KILL_EASY, region_name, Q)
	if(!landmark)
		qdel(Q)
		return null
	if(!Q.preview(landmark))
		qdel(Q)
		return null
	Q.reward_amount = reward

	if(ledger_or_floor ==  "Floor")
		if(!Q.materialize(landmark))
			message_admins("failed materialize")
			qdel(Q)
			return null
		var/obj/item/quest_writ/scroll = new(spawn_loc)
		scroll.base_icon_state = Q.get_scroll_icon()
		scroll.assigned_quest = Q
		Q.quest_scroll = scroll
		Q.quest_scroll_ref = WEAKREF(scroll)
		scroll.update_quest_text()
		record_round_statistic(STATS_CONTRACTS_GENERATED)
		log_event("generate", "rumor-on-floor [Q.quest_difficulty] [type] at [Q.target_spawn_area || "unknown"] (reward [Q.reward_amount])")
		log_and_message_admins("A custom quest ([quest_title]) has been created for [region_name] and the scroll has been dropped on the floor.")
		return Q

	pool += Q
	adjust_region_count(Q, 1)
	record_round_statistic(STATS_CONTRACTS_GENERATED)
	log_event("generate", "rumor-pool [Q.quest_difficulty] [type] at [Q.target_spawn_area || "unknown"] (reward [Q.reward_amount])")
	log_and_message_admins("A custom quest ([quest_title]) has been created for [region_name] and has been added to the nearest ledger.")
	return Q

/datum/quest/kill/generated
	quest_type = "Special"
	tp_budget = QUEST_TP_BUDGET_KILL_EASY
	threat_bands_cleared = QUEST_BANDS_KILL_EASY
	required_fellowship_size = 0
	var/list/quest_mobs = list()

/datum/quest/kill/generated/get_objective_text()
	return "Eliminate dire threats."

/datum/quest/kill/generated/materialize(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	spawn_kill_mobs(landmark)
	message_admins("A custom quest ([title]) has spawned its landmark at [landmark.x], [landmark.y], [landmark.z].")
	return TRUE

/datum/quest/kill/generated/compose_warband()
	return quest_mobs

/datum/quest/kill/generated/pick_region_faction_for(datum/threat_region/TR)
	return get_quest_faction("generated")

/datum/quest_faction/generated
	id = "generated"
	name_singular = "dire threat"
	name_plural = "dire threats"
	group_word = "horde"
	faction_tag = "unknown"
	can_blockade = FALSE
	category = FACTION_CAT_HUMANOID
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
	)
