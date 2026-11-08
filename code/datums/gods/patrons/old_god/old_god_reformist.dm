//////////////////////////////
//REFORM PSYDON   OV ADD   //
/////////////////////////////

/datum/patron/old_god/old_god_reformist
	name = "Reformist Genesism"
	domain = "The Free City of Szöréndnížina"
	desc = "Born of Grenzelhoftian refugees into Avar, Reformist Genesism is a modern interpration of Psydon, that maintains that He has died and moved on. \
	<br> They maintain that His sacrifice endures onwards and that their capacity to endure and follow his teachings are the only true path to salvation and to follow him to his afterlife. \
	<br> For this, they maintain a perplexing sort of Pacifism, in where they avoid bloodshed and violence, unless they deem it necessary to protect themselves and their flock - when they then show no mercy. \
	<br> Given their apparent godlessness, they are confusing and somewhat beloathed by other Genesists, especially the more militant expressions."
	worshippers = "Freifechters, Pacificists, and miniscule amounts of Aaavnics."
	associated_faith = /datum/faith/old_god
	mob_traits = list(TRAIT_PSYDONIAN_GRIT) //Assigned to all mobs with Psydon as the chosen patron. Gives a Willpower-scaling chance to resist succumbing to pain.
	miracles = list(/datum/action/cooldown/spell/touch/orison						= CLERIC_ORI, // Should they get this? Whatever.
					/datum/action/cooldown/spell/psydon/bootcheck/reformist			= CLERIC_T0, //Personal spell - summons a completely random item upon use. Your mileage might vary.
					/datum/action/cooldown/spell/psydon/endure/						= CLERIC_T1, //External spell - seals bleeding wounds and helps to save people who've been critically injured.
					/datum/action/cooldown/spell/psydon/prayer/						= CLERIC_T1, //Internal spell - minor self-regeneration, repeatedly casted while still.
					/datum/action/cooldown/spell/psydon/respite/					= CLERIC_T2, //Ditto, but stronger. The original variant, intended for dedicated - non-Adventuring - combat classes.
					/datum/action/cooldown/spell/psydon/persist/					= CLERIC_T3, //Ditto-ditto. Intended for non-combative devotee classes, such as the Missionary and Absolver.
	)
	traits_tier = list(TRAIT_PSYDONITE = CLERIC_T0) //Requires a minimal holy skill or the 'Devotee' virtue to unlock. Offers passive wound regeneration, but prevents healing from most miracles.
	confess_lines = list(
		"I BELIEVE IN OUR ABILITY TO PERSIST!",
		"OUR GOD IS DEAD! HONOUR HIS SACRIFICE!",
		"I STILL LOVE HUMANITY! DO YOU?!",
		"OUR CAPACITY TO ENDURE IS INVIOLABLE! YOU CANNOT BREAK ME!",
		"EVEN NOW, THERE IS STILL HOPE FOR MAN! AVE PSYDONIA!",
		"HE SACRIFICED MORE THAN THIS! YOU WILL FAIL!",
		"CRUEL FANATIC! HE WAS LOVE INCARNATE!"
	)

	titles = list(
		"God", // people call him this for. some reason. he has a name, y'all
		"Architect",
		"Allfather",
		"Creator",
		"Father",
	)

/////////////////////////////////
// Does God Hear Your Prayer ? //
/////////////////////////////////
// no he's dead - But you can still commune.

/datum/patron/old_god/can_pray(mob/living/follower)
	. = ..()
	. = TRUE
	// Allows prayer near psycross.
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interrupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer if raining and outside. Psydon weeps.
	// this is a gpt'd fix after we updated our weather system. im pretty sure i get how it works, just didnt know how to call the SSParticleWeather.
	var/datum/particle_weather/W = SSParticleWeather?.runningWeather
	if(istype(W, /datum/particle_weather/rain_gentle) || istype(W, /datum/particle_weather/rain_storm))
		if(istype(get_area(follower), /area/rogue/outdoors))
			return TRUE
	if(istype(W, /datum/particle_weather/blood_rain_gentle) || istype(W, /datum/particle_weather/blood_rain_storm))
		if(istype(get_area(follower), /area/rogue/outdoors))
			follower.add_stress(/datum/stressevent/something_stirs)
			follower.playsound_local(follower, 'sound/magic/psydonbleeds.ogg', 40, TRUE)
			return TRUE
	// Allows prayer if bleeding.
	if(follower.bleed_rate > 0)
		return TRUE
	// Allows prayer if holding silver psycross.
	if(istype(follower.get_active_held_item(), /obj/item/clothing/neck/roguetown/psicross/silver))
		return TRUE
	to_chat(follower, span_danger("..yet, I feel incomplete. To complete my communion, I must stand before a structured cross, be grasping a silvered psycross, be bleeding from a wound, or be standing in the rain. Just as He wept, so must I."))
	return FALSE
