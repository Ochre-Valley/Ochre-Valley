//////////////////////////////
// EGYPT PSYDON   OV ADD   //
////////////////////////////

/datum/patron/old_god/naledi
	name = "Old Genesism"
	domain = "Naledi, Raneshen"
	desc = "Reputed to be the oldest surviving expression of Psydon, Old Genesism is the majority faith of Naledi and still holds out in the deepest, most isolated parts of Raneshen. \
	<br> Deistic in nature, they maintain that all of Creation is Psydon, except Sin and hardship, which spawns from the folly of Man for falling to the Archdevil's lies. Regretfully, Psydon has turned from his creation in turn. \
	<br> Believing that redemption is the only path to salvation and reconcilation with Psydon, they practise a stoic and self-reflective lifestyle, based around performing good works and managing their various vices. \
	<br> Interestingly, they did not know of the Ten until the arrival of Grenzehoftian Missionaries, and the disaster that followed soured them on the teachings of the Decadivinity. \
	<br> Usually they regard them as simply isolated aspects of Psydon, that foolish people have mistaken for separate Gods."
	worshippers = "Naledi Refugees, Warscholars, isolated Ranesheni"
	associated_faith = /datum/faith/old_god
	allow_golden_cross = TRUE
	prayer_failure_message = "..yet, my guilt lessens not, for this is an insufficient supplication. I must stand before a structured cross, be grasping a silvered or golden psycross, be bleeding from a wound, or be standing in the rain. Just as He weeps, so must I."
	mob_traits = list(TRAIT_PSYDONIAN_GRIT) //Assigned to all mobs with Psydon as the chosen patron. Gives a Willpower-scaling chance to resist succumbing to pain.
	miracles = list(/datum/action/cooldown/spell/touch/orison						= CLERIC_ORI, // Should they get this? Whatever.
					/datum/action/cooldown/spell/psydon/bootcheck/naledi			= CLERIC_T0, //Personal spell - summons a completely random item upon use. Your mileage might vary.
					/datum/action/cooldown/spell/psydon/endure/						= CLERIC_T1, //External spell - seals bleeding wounds and helps to save people who've been critically injured.
					/datum/action/cooldown/spell/psydon/prayer/						= CLERIC_T1, //Internal spell - minor self-regeneration, repeatedly casted while still.
					/datum/action/cooldown/spell/psydon/respite/					= CLERIC_T2, //Ditto, but stronger. The original variant, intended for dedicated - non-Adventuring - combat classes.
					/datum/action/cooldown/spell/psydon/persist/					= CLERIC_T3, //Ditto-ditto. Intended for non-combative devotee classes, such as the Missionary and Absolver.
	)
	traits_tier = list(TRAIT_PSYDONITE = CLERIC_T0) //Requires a minimal holy skill or the 'Devotee' virtue to unlock. Offers passive wound regeneration, but prevents healing from most miracles.
	confess_lines = list(
		"WE ARE HIS BEST AND WORST CREATION!",
		"DJINN-ADDLED ROTBRAIN, MY FAITH IS UNSHAKEABLE!",
		"HE TURNED HIS GAZE FROM US! I SHALL NOT TURN FROM HIM!",
		"OH ALLFATHER, FORGIVE US OUR VIOLENCE. FORGIVE US!",
		"BEHOLD! THE GRACEFUL ARC OF SYON! JIHAD IS MY CREED!",
		"REPENTENANCE IS THE ONLY WAY TO THE DAWN!",
		"WE ARE SINNERS! CAN'T YOU SEE? WE HAVE TO ATONE!",
		"I SUBMIT TO ONLY ONE LORD - PSYDON!"
	)

	titles = list(
		"Psydon",
		"God", // people call him this for. some reason. he has a name, y'all
		"Architect",
		"Allfather",
		"Creator",
		"Father",
		"Brightstar",
		"Divine Will"
	)
