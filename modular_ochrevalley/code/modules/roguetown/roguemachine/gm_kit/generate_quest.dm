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
		var/mob_to_add = tgui_input_list(user, "Choose a mob that needs killing, cancel to finish adding mobs. (max of 20)", "Mob", list_of_mobs)
		if(!mob_to_add)
			break
		else
			var/remaining_count = 20 - current_mob_count
			var/number_to_add = tgui_input_number(user, "How many of this mob to include? ([remaining_count] remaining)", "Mob", 1, remaining_count)
			to_chat(user, "Added [number_to_add] of [mob_to_add]")
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
		message_admins("No landmark")
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



////////////////////Generate recovery quest////////////////////////
/client/proc/generate_quest_recover()
	set name = "Generate Recovery Quest"
	set category = "Game Master"
	set hidden = 0

	var/mob/user = src.mob

	var/list/list_of_mobs = typesof(/mob/living)
	var/current_mob_count = 0
	var/list/quest_mobs = list()

	var/list/list_of_items = typesof(/obj/item)
	var/current_item_count = 0
	var/list/quest_items = list()

	var/turn_in_areas = list(
		/area/rogue/indoors/town/tavern,
		/area/rogue/indoors/town/bath,
		/area/rogue/indoors/town/church,
		/area/rogue/indoors/town/dwarfin,
		/area/rogue/indoors/town/shop,
		/area/rogue/indoors/town/manor,
		/area/rogue/indoors/town/magician,
		/area/rogue/indoors/town/physician,
		/area/rogue/indoors/town,
	)

	var/quest_title = tgui_input_text(user, "What is the quest title?", "Title")
	if(!quest_title)
		return
	var/reward = tgui_input_number(user, "How much coin should be rewarded on completion?", "Reward", 150)
	if(!reward)
		return
	
	var/bands_of_threat = tgui_input_number(user, "How many bands of threat does it remove?", "Threat", 1, 20)
	if(!bands_of_threat)
		return

	while(current_item_count < 21)
		var/the_item = tgui_input_list(user, "Choose the type of item that needs to be recovered. Cancel to finish adding items. (max of 20)", "Item", list_of_items)
		if(!the_item)
			break
		else
			var/remaining_count = 20 - current_item_count
			var/number_to_add = tgui_input_number(user, "How many of this item to include ([remaining_count] remaining)?", "Item", 1, remaining_count)
			to_chat(user, "Added [number_to_add] of [the_item]")
			while(number_to_add > 0)
				quest_items += the_item
				number_to_add--
				current_item_count++	
	if(!quest_items.len)
		return
	
	var/shipment_name = tgui_input_text(user, "What is the name of the package?", "Shipment name")
	if(!shipment_name)
		return
	
	var/area/target_area = tgui_input_list(user, "Where is the delivery area?", "Delivery", turn_in_areas)
	if(!target_area)
		return
	
	var/list/regions = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		regions[TR.region_name] = TR
	var/selected = tgui_input_list(user, "Pick a region for the quest.", "Region", regions)
	var/datum/threat_region/where_to_spawn = regions[selected]

	while(current_mob_count < 21)
		var/mob_to_add = tgui_input_list(user, "Choose a mob that needs killing, cancel to finish adding mobs. (max of 20)", "Mob", list_of_mobs)
		if(!mob_to_add)
			break
		else
			var/remaining_count = 20 - current_mob_count
			var/number_to_add = tgui_input_number(user, "How many of this mob to include ([remaining_count] remaining)?", "Mob", 1, remaining_count)
			to_chat(user, "Added [number_to_add] of [mob_to_add]")
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

	SSquestpool.gm_recovery_quest(quest_title, reward, bands_of_threat, fellowship_size, where_to_spawn, quest_mobs, ledger_or_floor, spawn_loc, crimes, quest_items, target_area, shipment_name)

/datum/controller/subsystem/questpool/proc/gm_recovery_quest(quest_title, reward, bands_of_threat, fellowship_size, datum/threat_region/where_to_spawn, list/quest_mobs, ledger_or_floor, spawn_loc, crimes, list/quest_items, target_area, shipment_name)
	message_admins("Entered subsystem")
	var/datum/quest/kill/recovery/generated/Q = new /datum/quest/kill/recovery/generated()
	if(!Q)
		message_admins("No quest")
		return null
	Q.quest_mobs = quest_mobs
	Q.threat_bands_cleared = bands_of_threat
	Q.title = quest_title
	Q.shipment_name = shipment_name
	Q.quest_items = quest_items
	Q.override_destination = target_area
	if(crimes)
		Q.rolled_crimes = list(crimes)
	Q.required_fellowship_size = fellowship_size
	Q.quest_difficulty = "Special"
	Q.created_at = world.time
	Q.issued_day = GLOB.dayspassed
	Q.quest_giver_name = "The Grand Duchy of Azuria"
	var/region_name = where_to_spawn?.region_name
	var/obj/effect/landmark/quest_spawner/landmark = find_quest_landmark(QUEST_RECOVERY, region_name, Q)
	if(!landmark)
		message_admins("No landmark")
		qdel(Q)
		return null
	if(!Q.preview(landmark))
		message_admins("No preview landmark")
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

/datum/quest/kill/recovery/generated
	quest_type = "Special"
	tp_budget = QUEST_TP_BUDGET_KILL_EASY
	threat_bands_cleared = QUEST_BANDS_KILL_EASY
	required_fellowship_size = 0
	var/list/quest_mobs = list()
	var/list/quest_items = list()

/datum/quest/kill/recovery/generated/get_objective_text()
	return "Recover Essential Items."

/datum/quest/kill/recovery/generated/materialize(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	spawn_kill_mobs(landmark)
	spawn_recovery_parcel(landmark)
	message_admins("A custom quest ([title]) has spawned its landmark at [landmark.x], [landmark.y], [landmark.z].")
	return TRUE

/datum/quest/kill/recovery/generated/compose_warband()
	return quest_mobs

/datum/quest/kill/recovery/generated/pick_region_faction_for(datum/threat_region/TR)
	return get_quest_faction("generated")

/datum/quest/kill/recovery/generated/preview(obj/effect/landmark/quest_spawner/landmark)
	message_admins("Entered preview")
	if(!landmark)
		message_admins("No landmark")
		return FALSE
	pending_landmark_ref = WEAKREF(landmark)
	target_spawn_area = get_area_name(get_turf(landmark))
	region = landmark.region

	if(!region)
		message_admins("no region")
		return FALSE
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(!TR)
		message_admins("no threat region")
		return FALSE
	faction = pick_region_faction_for(TR)
	if(!faction)
		message_admins("no faction")
		return FALSE
	faction_id = faction.id
	// Scale by regional danger, then roll per-quest variance so two same-difficulty quests differ.
	tp_budget = roll_tp_budget(tp_budget, TR.tp_budget_multiplier)
	// target_mob_type is picked here for display purposes only — the actual composition is
	// computed at materialize time via TP budget spending.
	target_mob_type = faction.pick_mob_type()
	if(!target_mob_type)
		message_admins("no target mob type")
		return FALSE
	
	progress_required = estimate_mob_count()
	if(faction.boss_name_file)
		band_leader_name = faction.generate_boss_name()
	
	var/area/destination = override_destination
	target_delivery_location = destination
	progress_required = 1
	finalize_preview_title()
	message_admins("Preview complete")
	return TRUE

/datum/quest/kill/recovery/generated/spawn_recovery_parcel(obj/effect/landmark/quest_spawner/landmark)
	var/turf/spawn_turf = landmark.get_safe_spawn_turf()
	if(!spawn_turf)
		return
	var/obj/item/parcel/recovered = new(spawn_turf)
	// Pack shipment_count copies of target_delivery_item into the parcel's list.
	for(var/our_item in quest_items)
		var/obj/item/I = new our_item(recovered)
		recovered.contained_items += I
	recovered.delivery_area_type = target_delivery_location
	recovered.allowed_jobs = recovered.get_area_jobs(target_delivery_location)
	recovered.name = "lost shipment of [shipment_name]"
	recovered.desc = "A sealed parcel of [shipment_name] wrested back from its captors. Marked for delivery to [initial(target_delivery_location.name)]. The seal can only be broken by the recipient."
	recovered.icon_state = "ration_large"
	recovered.dropshrink = 1
	recovered.update_icon()
	recovered.AddComponent(/datum/component/quest_object/courier, src)
	add_tracked_atom(recovered)

