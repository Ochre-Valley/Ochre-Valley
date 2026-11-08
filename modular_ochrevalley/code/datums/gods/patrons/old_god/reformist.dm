//////////////////////////////
//REFORM PSYDON   OV ADD   //
/////////////////////////////

/datum/patron/old_god/reformist
	name = "Reformist Genesism"
	domain = "The Free City of Szöréndnížina"
	desc = "Born of Grenzelhoftian refugees into Avar, Reformist Genesism is a modern interpration of Psydon, that maintains that He has died and moved on. \
	<br> They maintain that His sacrifice endures onwards and that their capacity to endure and follow his teachings are the only true path to salvation and to follow him to his afterlife. \
	<br> For this, they maintain a perplexing sort of Pacifism, in where they avoid bloodshed and violence, unless they deem it necessary to protect themselves and their flock - when they then show no mercy. \
	<br> Given their apparent godlessness, they are confusing and somewhat beloathed by other Genesists, especially the more militant expressions."
	worshippers = "Freifechters, Pacificists, and miniscule amounts of Aavnics."
	associated_faith = /datum/faith/old_god
	prayer_failure_message = "..yet, I feel incomplete. To complete my communion, I must stand before a structured cross, be grasping a silvered psycross, be bleeding from a wound, or be standing in the rain. Just as He wept, so must I."
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
		"Psydon",
		"God", // people call him this for. some reason. he has a name, y'all
		"Architect",
		"Allfather",
		"Creator",
		"Father",
	)
