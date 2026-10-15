/*
*	So, here's the general idea behind these:
*	These are static threat spawners. They routinely will, at random, generate enemies
*	in the same way that ambushes spawn them - that is, spawning them around random
*	trees/mushrooms/etc within view of the spawner. However, unlike ambushes, THESE
*	mobs will actually stick around and not despawn!
*
*	After a specified time into the round, the threat spawners become "active," and will
*	start a cooldown that is randomized between the min and max time. When the cooldown
*	hits 0, it spawns lingering enemies around any valid targets in much the same way
*	that ambushes spawn enemies. Then it goes on a randomized cooldown again, and the
*	cycle repeats for the rest of the round.
*/

GLOBAL_VAR_INIT(threatspawner_cd_min, 10 MINUTES)
GLOBAL_VAR_INIT(threatspawner_cd_max, 17 MINUTES)
// Determines different min/max possible ranges for # of enemies spawned.
// Makes it much more common that only a couple enemies spawn
// while making it unlikely but possible that a bunch of enemies spawn as a !!FUN SURPRISE!!
GLOBAL_LIST_INIT(threatspawner_quantities, list(
	list(1,2) = 40,
	list(2,3) = 15,
	list(3,4) = 3,
	list(4,6) = 1,
))


/obj/effect/landmark/threatspawner
	name = "static threat spawner"
	icon = 'modular_ochrevalley/icons/effects/threat_spawners.dmi'
	icon_state = "threatspawner"
	/// How long we wait at round start before becoming active
	var/inital_cooldown = 30 MINUTES
	/// Max range around us to search for spots to spawn mobs
	var/spawn_range = 5
	/// The time at which we will spawn more mobs
	var/next_spawn_time = 0
	/// List of our spawned mobs who are still able to fight
	var/list/mob/living/our_living_mobs = list()

/obj/effect/landmark/threatspawner/Initialize()
	. = ..()
	next_spawn_time = world.time + inital_cooldown
	START_PROCESSING(SSprocessing, src)

/obj/effect/landmark/threatspawner/Destroy(force)
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/effect/landmark/threatspawner/process()
	if(world.time > next_spawn_time)
		if(consider_spawning())
			spawn_threats()

/obj/effect/landmark/threatspawner/proc/consider_spawning()
	var/turf/T = get_turf(src)
	if(!T)
		next_spawn_time = world.time + INFINITY
		CRASH("A threat spawner doesn't have a valid turf... SOMEHOW!")
	// If we have spawned mobs that are still alive, wait a while longer.
	if(our_living_mobs.len > 0)
		next_spawn_time = world.time + 1 MINUTES
		return FALSE
	// Make sure nobody is able to see us or anything we might spawn!
	for(var/mob/living/carbon/human/L in range(src, spawn_range + 7))
		if(L.ckey)
			// If there are viewers, we'll just wait a bit and then try again.
			next_spawn_time = world.time + 1 MINUTES
			return FALSE
	// Now, make sure we don't have any lit objects around us!
	// (This way we don't wind up spawning dudes in a space a player might be building in)
	var/lights_around = FALSE
	for(var/obj/O in range(spawn_range, src))
		if(istype(O, /obj/item/flashlight/flare))
			var/obj/item/flashlight/flare/F = O
			if(F.on)
				lights_around = TRUE
				break
		if(istype(O, /obj/machinery/light/rogue))
			var/obj/machinery/light/rogue/L = O
			if(L.on)
				lights_around = TRUE
				break
	if(lights_around)
		// If there are, well, guess we'll wait a good while before checking again.
		start_cooldown()
		return FALSE
	return TRUE

/obj/effect/landmark/threatspawner/proc/spawn_threats()
	var/list/possible_targets = list()
	for(var/obj/structure/flora/F in range(src, spawn_range))
		if(isturf(F.loc))
			possible_targets += F.loc
	// If we find no valid flora to spawn them on, then um... uh... I guess we wait a while??
	if(!possible_targets.len)
		start_cooldown()
		return
	// First determine the minimum and maximum possible quantity of dudes we'll spawn
	var/list/minmax = pickweight(GLOB.threatspawner_quantities)
	var/amt2spawn = rand(minmax[1], minmax[2])
	// Now we actually spawn the dudes!!
	var/area/AR = get_area(src)
	var/spawnedtype = get_mob_spawn_type(AR)
	for(var/i in 1 to amt2spawn)
		var/spawnloc = pick(possible_targets)
		if(spawnloc)
			var/mob/living/spawnedmob = new spawnedtype(spawnloc)
			RegisterSignal(spawnedmob, COMSIG_MOB_DEATH, PROC_REF(on_our_mobs_death))
			our_living_mobs.Add(spawnedmob)
	start_cooldown()

/obj/effect/landmark/threatspawner/proc/on_our_mobs_death(mob/living/source)
	our_living_mobs.Remove(source)

/// Returns the type of the mob that the spawner will create
/obj/effect/landmark/threatspawner/proc/get_mob_spawn_type(area/AR)
	return pickweight(AR.ambush_mobs)

/obj/effect/landmark/threatspawner/proc/start_cooldown()
	next_spawn_time = world.time + rand(GLOB.threatspawner_cd_min, GLOB.threatspawner_cd_max)
