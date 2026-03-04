//OV FILE
/mob/living/simple_animal

	var/vore_active = 0					// If vore behavior is enabled for this mob

	vore_capacity = 1					// The capacity (in people) this person can hold
	var/vore_bump_chance = 0			// Chance of trying to eat anyone that bumps into them, regardless of hostility
	var/vore_bump_emote	= "grabs hold of"				// Allow messages for bumpnom mobs to have a flavorful bumpnom
	var/vore_pounce_chance = 0			// Chance of this mob knocking down an opponent
	var/vore_pounce_cooldown = 0		// Cooldown timer - if it fails a pounce it won't pounce again for a while
	var/vore_pounce_successrate	= 0	// Chance of a pounce succeeding against a theoretical 0-health opponent
	var/vore_pounce_falloff = 0			// Success rate falloff per %health of target mob.
	var/vore_pounce_maxhealth = 0		// Mob will not attempt to pounce targets above this %health
	var/vore_standing_too = 0			// Can also eat non-stunned mobs
	var/vore_ignores_undigestable = FALSE	// If set to true, will refuse to eat mobs who are undigestable by the prefs toggle.
	var/swallowsound = null				// What noise plays when you succeed in eating the mob.

	var/vore_default_mode = DM_SELECT	// Default bellymode (DM_DIGEST, DM_HOLD, DM_ABSORB, DM_SELECT)
	var/vore_default_flags = 0			// No flags
	var/vore_digest_chance = 25			// Chance to switch to digest mode if resisted
	var/vore_absorb_chance = 0			// Chance to switch to absorb mode if resisted
	var/vore_escape_chance = 25			// Chance of resisting out of mob
	var/vore_escape_chance_absorbed = 20// Chance of absorbed prey finishing an escape. Requires a successful escape roll against the above as well.

	var/vore_stomach_name				// The name for the first belly if not "stomach"
	var/vore_stomach_flavor				// The flavortext for the first belly if not the default

	var/vore_default_item_mode = IM_DIGEST_FOOD			//How belly will interact with items
	var/vore_default_contaminates = FALSE				//Will it contaminate?
	var/vore_default_contamination_flavor = "Generic"	//Contamination descriptors
	var/vore_default_contamination_color = "green"		//Contamination color

	var/life_disabled = 0				// For performance reasons

	var/vore_attack_override = FALSE	// Enable on mobs you want to have special behaviour on melee grab attack.

	var/mount_offset_x = 5				// Horizontal riding offset.
	var/mount_offset_y = 8				// Vertical riding offset

	var/obj/item/radio/headset/mob_radio		//Adminbus headset for simplemob shenanigans.
	can_be_drop_pred = TRUE				// Mobs are pred by default.
	can_be_drop_prey = TRUE
	var/damage_threshold  = 0 //For some mobs, they have a damage threshold required to deal damage to them.

	var/nom_mob = FALSE //If a mob is meant to be hostile for vore purposes but is otherwise not hostile, if true makes certain AI ignore the mob

	var/voremob_loaded = FALSE // On-demand belly loading.

	var/eat_surrendering_only = TRUE
	var/currently_eating = FALSE

/mob/living/simple_animal/proc/will_eat(var/mob/living/M)
	if(client) //You do this yourself, dick!
		//ai_log("vr/wont eat [M] because we're player-controlled", 3) //VORESTATION AI TEMPORARY REMOVAL
		return 0
	if(!istype(M)) //Can't eat 'em if they ain't /mob/living
		//ai_log("vr/wont eat [M] because they are not /mob/living", 3) //VORESTATION AI TEMPORARY REMOVAL
		return 0
	if(src == M) //Don't eat YOURSELF dork
		//ai_log("vr/won't eat [M] because it's me!", 3) //VORESTATION AI TEMPORARY REMOVAL
		return 0
	if(vore_ignores_undigestable && !M.digestable) //Don't eat people with nogurgle prefs
		//ai_log("vr/wont eat [M] because I am picky", 3) //VORESTATION AI TEMPORARY REMOVAL
		return 0
	if(!M.allowmobvore || !M.devourable) // Don't eat people who don't want to be ate by mobs
		//ai_log("vr/wont eat [M] because they don't allow mob vore", 3) //VORESTATION AI TEMPORARY REMOVAL
		return 0
	if(ishuman(M))
		var/mob/living/carbon/human/the_prey = M
		if(eat_surrendering_only && !the_prey.surrendering)
			return 0
	if(vore_capacity != 0 && (vore_fullness >= vore_capacity)) // We're too full to fit them
		//ai_log("vr/wont eat [M] because I am too full", 3) //VORESTATION AI TEMPORARY REMOVAL
		return 0
	return 1

/mob/living/simple_animal/init_vore(force)
	if(force)
		vore_active = TRUE
		voremob_loaded = TRUE
	if(!vore_active || no_vore || !voremob_loaded)
		return

	AddElement(/datum/element/slosh) // Sloshy element

	// Since they have bellies, add verbs to toggle settings on them.
	//add_verb(src, /mob/living/simple_animal/proc/toggle_digestion)
	//add_verb(src, /mob/living/simple_animal/proc/toggle_fancygurgle)
	//add_verb(src, /mob/living/simple_animal/proc/animal_nom)

	if(LAZYLEN(vore_organs))
		return

	can_be_drop_pred = TRUE // Mobs will eat anyone that decides to drop/slip into them by default.
	load_default_bellies()

/mob/living/simple_animal/proc/load_default_bellies()
	//A much more detailed version of the default /living implementation
	var/obj/belly/B = new /obj/belly(src)
	vore_selected = B
	B.immutable = 1
	B.affects_vore_sprites = TRUE
	B.name = vore_stomach_name ? vore_stomach_name : "stomach"
	B.desc = vore_stomach_flavor ? vore_stomach_flavor : "Your surroundings are warm, soft, and slimy. Makes sense, considering you're inside \the [name]."
	B.digest_mode = vore_default_mode
	B.mode_flags = vore_default_flags
	B.item_digest_mode = vore_default_item_mode
	B.contaminates = vore_default_contaminates
	B.contamination_flavor = vore_default_contamination_flavor
	B.contamination_color = vore_default_contamination_color
	B.escapable = vore_escape_chance > 0 ? 1 : 0
	B.escapechance = vore_escape_chance
	B.escapechance_absorbed = vore_escape_chance_absorbed
	B.digestchance = vore_digest_chance
	B.absorbchance = vore_absorb_chance
	B.human_prey_swallow_time = 5 SECONDS
	B.nonhuman_prey_swallow_time = 5 SECONDS
	B.vore_verb = "swallow"
	B.emote_lists[DM_HOLD] = list( // We need more that aren't repetitive. I suck at endo. -Ace
		"The insides knead at you gently for a moment.",
		"The guts glorp wetly around you as some air shifts.",
		"The predator takes a deep breath and sighs, shifting you somewhat.",
		"The stomach squeezes you tight for a moment, then relaxes harmlessly.",
		"The predator's calm breathing and thumping heartbeat pulses around you.",
		"The warm walls kneads harmlessly against you.",
		"The liquids churn around you, though there doesn't seem to be much effect.",
		"The sound of bodily movements drown out everything for a moment.",
		"The predator's movements gently force you into a different position.")
	B.emote_lists[DM_DIGEST] = list(
		"The burning acids eat away at your form.",
		"The muscular stomach flesh grinds harshly against you.",
		"The caustic air stings your chest when you try to breathe.",
		"The slimy guts squeeze inward to help the digestive juices soften you up.",
		"The onslaught against your body doesn't seem to be letting up; you're food now.",
		"The predator's body ripples and crushes against you as digestive enzymes pull you apart.",
		"The juices pooling beneath you sizzle against your sore skin.",
		"The churning walls slowly pulverize you into meaty nutrients.",
		"The stomach glorps and gurgles as it tries to work you into slop.")
	can_be_drop_pred = TRUE // Mobs will eat anyone that decides to drop/slip into them by default.
	B.belly_fullscreen = "a_tumby"
	B.belly_fullscreen_color = "#823232"
	B.belly_fullscreen_color2 = "#823232"

/mob/living/simple_animal/proc/animal_nom(mob/living/T in living_mobs_in_view(1))
	set name = "Animal Nom"
	set category = "Abilities.Vore" // Moving this to abilities from IC as it's more fitting there
	set desc = "Since you can't grab, you get a verb!"

	if(vore_active && !voremob_loaded) // On-demand belly loading.
		init_vore(TRUE)

	if(stat != CONSCIOUS)
		return

	feed_grabbed_to_self(src,T)

/mob/living/simple_animal/perform_the_nom(mob/living/user, mob/living/prey, mob/living/pred, obj/belly/belly, delay_time)
	if(vore_active && !voremob_loaded && pred == src) //Only init your own bellies.
		init_vore(TRUE)
		belly = vore_selected
	return ..()

/mob/living/simple_animal/begin_instant_nom(mob/living/user, mob/living/prey, mob/living/pred, obj/belly/belly)
	if(vore_active && !voremob_loaded && pred == src) //Only init your own bellies.
		init_vore(TRUE)
		belly = vore_selected
	return ..()

/mob/living/simple_mob/proc/toggle_digestion()
	set name = "Toggle Animal's Digestion"
	set desc = "Enables digestion on this mob for 20 minutes."
	set category = "OOC.Mob Settings"
	set src in oview(1)

	var/mob/living/carbon/human/user = usr
	if(!istype(user) || user.stat) return

	if(!vore_selected)
		to_chat(user, span_warning("[src] isn't planning on eating anything much less digesting it."))
		return

	if(vore_selected.digest_mode == DM_HOLD)
		var/confirm = tgui_alert(user, "Enabling digestion on [name] will cause it to digest all stomach contents. Using this to break OOC prefs is against the rules. Digestion will reset after 20 minutes.", "Enabling [name]'s Digestion", list("Enable", "Cancel"))
		if(confirm == "Enable")
			vore_selected.digest_mode = DM_DIGEST
	else
		var/confirm = tgui_alert(user, "This mob is currently set to process all stomach contents. Do you want to disable this?", "Disabling [name]'s Digestion", list("Disable", "Cancel"))
		if(confirm == "Disable")
			vore_selected.digest_mode = DM_HOLD

// Added as a verb in /mob/living/simple_mob/init_vore() if vore is enabled for this mob.
/mob/living/simple_animal/proc/toggle_fancygurgle()
	set name = "Toggle Animal's Gurgle sounds"
	set desc = "Switches between Fancy and Classic sounds on this mob."
	set category = "OOC.Mob Settings"
	set src in oview(1)

	var/mob/living/user = usr	//I mean, At least ghosts won't use it.
	if(!istype(user) || user.stat) return
	if(!vore_selected)
		to_chat(user, span_warning("[src] isn't vore capable."))
		return

	vore_selected.fancy_vore = !vore_selected.fancy_vore
	to_chat(user, "[src] is now using [vore_selected.fancy_vore ? "Fancy" : "Classic"] vore sounds.")

/mob/living/simple_animal/proc/vore_surrendered(var/mob/living/carbon/human/our_prey)
	if(!istype(our_prey))
		return FALSE
	if(stat || !vore_active)
		return FALSE
	
	if(our_prey.surrendering)
		if(will_eat(our_prey))
			if(!vore_selected)
				init_vore()
			currently_eating = TRUE
			addtimer(CALLBACK(src, PROC_REF(finished_eating)), 5 SECONDS)
			return perform_the_nom(src, our_prey, src, src.vore_selected, 5 SECONDS)

	return FALSE

/mob/living/simple_animal/proc/finished_eating()
	currently_eating = FALSE
