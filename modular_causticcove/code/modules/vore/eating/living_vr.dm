///////////////////// Mob Living /////////////////////
/mob/living
	var/showvoreprefs = TRUE			// Determines if the mechanical vore preferences button will be displayed on the mob or not.
	var/list/temp_language_sources = list()	//Absorbs add languages to the pred
	var/list/temp_languages = list()		// Absorbs add languages to the pred
	var/prey_controlled = FALSE			// If the mob is currently controlled by their prey.
	var/weight = 137					// Weight for mobs for weightgain system
	var/weight_gain = 1 				// How fast you gain weight
	var/weight_loss = 0.5 				// How fast you lose weight
	var/vore_egg_type = "egg" 			// Default egg type.	// Only used for creatures that have the xenochimera regen ability, so far.
	var/metabolism = 0.0015
	var/no_vore = FALSE					// If the character/mob can vore.
	var/restrict_vore_ventcrawl = FALSE // Self explanatory
	var/absorbing_prey = 0 				// Determines if the person is using the succubus drain or not. See station_special_abilities_vr.
	var/drain_finalized = 0				// Determines if the succubus drain will be KO'd/absorbed. Can be toggled on at any time.
	var/fuzzy = 0						// Preference toggle for sharp/fuzzy icon.
	var/next_preyloop					// For Fancy sound internal loop
	var/stuffing_feeder = FALSE			// Can feed foods to others whole, like trash eater can eat them on their own.
	var/adminbus_trash = FALSE			// For abusing trash eater for event shenanigans.
	var/adminbus_eat_minerals = FALSE	// This creature subsists on a diet of pure adminium.
	var/vis_height = 32					// Sprite height used for resize features.
	var/appendage_color = "#e03997" //Default pink. Used for the 'long_vore' trait.
	var/appendage_alt_setting = FALSE	// Dictates if 'long_vore' user pulls prey to them or not. 1 = user thrown towards target.
	var/digestion_in_progress = FALSE	// Gradual corpse gurgles
	var/trash_catching = FALSE					//Toggle for trash throw vore
	var/list/trait_injection_reagents = list()	//List of all the reagents allowed to be used for injection via venom bite
	var/skin_reagent
	var/trait_injection_selected = null			//What trait reagent you're injecting.
	var/trait_injection_amount = 5				//How much you're injecting with traits.
	var/trait_injection_verb = "bite"			//Which fluffy manner you're doing the injecting.

	var/mute_entry = FALSE					//Toggleable vorgan entry logs.
	var/parasitic = FALSE					//Digestion immunity and nutrition leeching variable
	var/liquidbelly_visuals = TRUE			//Toggle for liquidbelly level visuals.
	var/churn_count = 0						//Counter for digested livings

	var/passtable_reset		// For crawling
	var/passtable_crawl_checked = FALSE
	var/holder_type

/mob/living/carbon/human
	var/list/body_writing // assoc list by BP_ key

/mob/living/proc/handle_special_unlocks()
	return

/mob/proc/init_vore(force = FALSE)
	//Something else made organs, meanwhile.
	if(!isnewplayer(src))
		AddElement(/datum/element/slosh)
	if(LAZYLEN(vore_organs))
		return TRUE

	//We'll load our client's organs if we have one
	if(client && client.prefs_vr)
		if(!copy_from_prefs_vr())
			to_chat(src,span_warning("ERROR: You seem to have saved VOREStation prefs, but they couldn't be loaded."))
			return FALSE
		if(LAZYLEN(vore_organs))
			vore_selected = vore_organs[1]
			return TRUE

	//Or, we can create a basic one for them
	if(!LAZYLEN(vore_organs) && isliving(src))
		LAZYINITLIST(vore_organs)
		var/obj/belly/B = new /obj/belly(src)
		vore_selected = B
		B.immutable = TRUE
		B.name = "Stomach"
		B.desc = "It appears to be rather warm and wet. Makes sense, considering it's inside \the [name]."
		B.can_taste = TRUE
		return TRUE

/mob/living/init_vore(force)
	if(no_vore)
		return FALSE
	return ..()

//
// Hide vore organs in contents
//
///mob/living/view_variables_filter_contents(list/L)
//	. = ..()
//	var/len_before = L.len
//	L -= vore_organs
//	. += len_before - L.len
//
//
// Handle being clicked, perhaps with something to devour
//
/mob/living/proc/vore_attackby(obj/item/I, mob/user)
	//Handle case: /obj/item/grabbing
	if(istype(I, /obj/item/grabbing))
		var/obj/item/grabbing/G = I
		var/mob/living/carbon/victim = G.grabbed

		//Has to be aggressive grab, has to be living click-er and non-silicon grabbed
		if(G.grab_state >= GRAB_AGGRESSIVE && (isliving(user)))
			var/mob/living/attacker = user  // Typecast to living

			// src is the mob clicked on and attempted predator

			///// If user clicked on themselves
			if(src == G.grabbee && is_vore_predator(src))
				if(istype(victim) && !victim.client && !victim.ai_controller)
					log_and_message_admins("attempted to eat [key_name_admin(victim)] whilst they were AFK ([G.grabbed ? ADMIN_JMP(victim) : "null"])", src)
				if(feed_grabbed_to_self(src, victim))
					qdel(G)
					return TRUE
				else
					log_attack("[attacker] attempted to feed [G.grabbed] to [user] ([user.type]) but it failed.")

			///// If user clicked on their grabbed target
			else if((src == G.grabbed) && (istype(attacker.a_intent, INTENT_GRAB)) && (attacker.zone_selected == BODY_ZONE_CHEST) && (is_vore_predator(G.grabbed)))
				if(istype(victim) && !victim.client && !victim.ai_controller) //Check whether the victim is: A carbon mob, has no client, but has a ckey. This should indicate an SSD player.
					log_and_message_admins("attempted to force feed themselves to [key_name_admin(G.grabbed)] whilst they were AFK ([G.grabbed ? ADMIN_JMP(victim) : "null"])", attacker)
				if(!victim.feeding)
					to_chat(user, span_notice("[G.grabbed] isn't willing to be fed."))
					log_and_message_admins("attempted to feed themselves to [key_name_admin(G.grabbed)] against their prefs ([G.grabbed ? ADMIN_JMP(victim) : "null"])", src)
					return FALSE

				if(attacker.feed_self_to_grabbed(attacker, G.grabbed))
					qdel(G)
					return TRUE
				else
					log_attack("[attacker] attempted to feed [user] to [G.grabbed] ([G.grabbed ? victim.type : "null"]) but it failed.")

			///// If user clicked on anyone else but their grabbed target
			else if((src != G.grabbed) && (src != G.grabbee) && (is_vore_predator(src)))
				if(istype(victim) && !victim.client && !victim.ai_controller)
					log_and_message_admins("attempted to feed [key_name_admin(G.grabbed)] to [key_name_admin(src)] whilst [key_name_admin(G.grabbed)] was AFK ([G.grabbed ? ADMIN_JMP(victim) : "null"])", attacker)
				var/mob/living/carbon/victim_fed = src
				if(istype(victim_fed) && !victim_fed.client && !victim_fed.ai_controller)
					log_and_message_admins("attempted to feed [key_name_admin(G.grabbed)] to [key_name_admin(src)] whilst [key_name_admin(src)] was AFK ([G.grabbed ? ADMIN_JMP(victim) : "null"])", attacker)

				if(!feeding)
					to_chat(user, span_notice("[src] isn't willing to be fed."))
					log_and_message_admins("attempted to feed [key_name_admin(G.grabbed)] to [key_name_admin(src)] against predator's prefs ([src ? ADMIN_JMP(src) : "null"])", attacker)
					return FALSE
				if(!(victim.devourable))
					to_chat(user, span_notice("[G.grabbed] isn't able to be devoured."))
					log_and_message_admins("attempted to feed [key_name_admin(G.grabbed)] to [key_name_admin(src)] against prey's prefs ([G.grabbed ? ADMIN_JMP(victim) : "null"])", attacker)
					return FALSE
				if(attacker.feed_grabbed_to_other(attacker, G.grabbed, src))
					qdel(G)
					return TRUE
				else
					log_attack("[attacker] attempted to feed [G.grabbed] to [src] ([type]) but it failed.")

	//Handle case: /obj/item/holder
	else if(istype(I, /obj/item/holder))
		var/obj/item/holder/H = I

		if(!isliving(user))
			return FALSE // return FALSE to continue upper procs

		var/mob/living/attacker = user  // Typecast to living
		if(is_vore_predator(src))
			for(var/mob/living/M in H.contents)
				if(attacker.eat_held_mob(attacker, M, src))
					return TRUE //return TRUE to exit upper procs
		else
			log_attack("[attacker] attempted to feed [H.contents] to [src] ([type]) but it failed.")

	// Body writing
	else if(istype(I, /obj/item/natural/feather) || istype(I, /obj/item/natural/thorn))
		if(!ishuman(src))
			return FALSE
		var/mob/living/carbon/human/canvas_user = src

		if(!isliving(user))
			return FALSE
		var/mob/living/attacker = user

		if(!istype(attacker.a_intent, INTENT_HELP))
			return FALSE

		var/hit_zone = attacker.zone_selected

		var/obj/item/bodypart/affecting = canvas_user.get_bodypart(hit_zone)
		if(!affecting || affecting.is_disabled())
			to_chat(attacker, span_danger("They are missing that limb!"))
			return TRUE

		var/message = tgui_input_text(attacker, "What would you like to write on [src]'s [affecting]? (This will replace existing writing.)", "Body Writing", "", 128, FALSE)
		if(!message)
			return TRUE

		to_chat(canvas_user, span_notice("[attacker] is attempting to write on your [affecting.name]!"))
		attacker.visible_message(span_notice("[attacker] starts writing on [canvas_user]'s [affecting.name]."), \
			span_notice("You start writing on [canvas_user]'s [affecting.name]..."))

		// Progress bar for writing on someone for better consent check.
		if(!do_after(attacker, 3 SECONDS, target = canvas_user))
			to_chat(attacker, span_warning("You stop writing on [canvas_user]."))
			return TRUE

		log_combat(attacker, canvas_user, "wrote \"[message]\"")

		LAZYSET(canvas_user.body_writing, affecting.body_part, message)

		attacker.visible_message(span_notice("[attacker] finishes writing on [canvas_user]'s [affecting.name]."), \
			span_notice("You finish writing on [canvas_user]'s [affecting.name]."))
		return TRUE

	return FALSE

/* //Caustic - Removing this to implement it the Chomper's way
//A variant of vore_attackby for insta noms, primarily to check prefs
/mob/living/proc/spontaneous_vore_attackby(mob/living/target, mob/user)
	//Has to be aggressive grab, has to be living click-er and non-silicon grabbed
	if(isliving(user))
		var/mob/living/attacker = user  // Typecast to living
		// src is the mob clicked on and attempted predator
		///// If user clicked on themselves
		if(target.can_be_drop_prey && attacker.can_be_drop_pred) //OV EDIT
			feed_grabbed_to_self_falling_nom(attacker, target)
			return
		if(target.can_be_drop_pred && attacker.can_be_drop_prey) //OV EDIT
			feed_grabbed_to_self_falling_nom(target, attacker)
	return FALSE */

//
// Our custom resist catches for /mob/living
//
/mob/living/proc/vore_process_resist()
	//Are we resisting from inside a belly?
	// if(isbelly(loc))
	// 	var/obj/belly/B = loc
	// 	B.relay_resist(src)
	// 	return TRUE //resist() on living does this TRUE thing.
	// Note: This is no longer required, as the refactors to resisting allow bellies to just define container_resist

	//Other overridden resists go here
	return FALSE

//
//	Verb for saving vore preferences to save file
//
/mob/proc/save_vore_prefs()
	if(!client || !client.prefs_vr)
		return FALSE
	if(!copy_to_prefs_vr())
		return FALSE
	if(!client.prefs_vr.save_vore())
		return FALSE

	return TRUE

/mob/proc/apply_vore_prefs()
	if(!client || !client.prefs_vr)
		return FALSE
	if(!client.prefs_vr.load_vore())
		return FALSE
	if(!copy_from_prefs_vr())
		return FALSE

	return TRUE

/mob/proc/copy_to_prefs_vr()
	if(!client || !client.prefs_vr)
		to_chat(src,span_warning("You attempted to save your vore prefs but somehow you're in this character without a client.prefs_vr variable. Tell a dev."))
		return FALSE

	var/datum/vore_preferences/P = client.prefs_vr

	VORE_PREF_TRANSFER(P, src)

	var/list/serialized = list()
	for(var/obj/belly/B as anything in src.vore_organs)
		if(B.prevent_saving) // Dont save bellies marked as unsavable.
			continue
		serialized += list(B.serialize()) //Can't add a list as an object to another list in Byond. Thanks.

	P.belly_prefs = serialized
	return TRUE

//
//	Proc for applying vore preferences, given bellies
//
/mob/proc/copy_from_prefs_vr(var/bellies = TRUE, var/full_vorgans = FALSE) // full_vorgans var to bypass 1-belly load optimization.
	if(!client || !client.prefs_vr)
		to_chat(src,span_warning("You attempted to apply your vore prefs but somehow you're in this character without a client.prefs_vr variable. Tell a dev."))
		return FALSE

	var/datum/vore_preferences/P = client.prefs_vr

	VORE_PREF_TRANSFER(src, P)

	if(bellies)
		if(isliving(src))
			var/mob/living/L = src
			L.release_vore_contents(silent = TRUE)
		QDEL_LIST(vore_organs)
		for(var/entry in P.belly_prefs)
			list_to_object(entry,src)
		if(!vore_organs.len)
			var/obj/belly/B = new /obj/belly(src)
			vore_selected = B
			B.immutable = TRUE
			B.name = "Stomach"
			B.desc = "It appears to be rather warm and wet. Makes sense, considering it's inside \the [name]."
			B.can_taste = TRUE
		else
			vore_selected = vore_organs[1]

	return TRUE

/mob/proc/load_vore_prefs_from_slot()

	var/datum/preferences/P = client.prefs

	var/remembered_default = P.load_vore_prefs_from_client(src) //Loads the preferences of a chosen slot
	if(!remembered_default)
		return

	apply_vore_prefs() //Applies the vore preferences of said slot

	if(remembered_default)
		P.return_to_character_slot(src, remembered_default) //sets you back to the original default slot

	return TRUE


/datum/preferences/proc/load_vore_prefs_from_client(mob/user)
	/*if(selecting_slots)
		to_chat(user, span_warning("You already have a slot selection dialog open!"))
		return*/
	var/savefile/S = new /savefile(path)
	var/default
	var/charlist = list()
	if(S)
		for(var/i=1, i<=max_save_slots, i++)
			var/name
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)
				name = "[i] - \[Unused Slot\]"
			else if(i == default_slot)
				name = "►[i] - [name]"
				default = "[name][nickname ? " ([nickname])" : ""]"
			else
				name = "[i] - [name]"
			charlist["[name][nickname ? " ([nickname])" : ""]"] = i

	var/remember_default = default_slot

	//selecting_slots = TRUE
	var/choice = tgui_input_list(user, "Select a character to load:", "Load Slot", charlist, default)
	//selecting_slots = FALSE
	if(!choice)
		return

	var/slotnum = charlist[choice]
	if(!slotnum)
		log_world("## ERROR Player picked [choice] slot to load, but that wasn't one we sent.")
		return

	load_character(slotnum)
	user.client?.prefs_vr.load_vore()
	//attempt_vr(user.client?.prefs_vr,"load_vore","")
	//sanitize_preferences()

	return remember_default

/datum/preferences/proc/return_to_character_slot(mob/user, var/remembered_default)
	load_character(remembered_default)
	user.client?.prefs_vr.load_vore()
	//attempt_vr(user.client?.prefs_vr,"load_vore","")
	//sanitize_preferences()

//
// Release everything in every vore organ
//
/mob/living/proc/release_vore_contents(var/include_absorbed = TRUE, var/silent = FALSE)
	for(var/obj/belly/B as anything in vore_organs)
		B.release_all_contents(include_absorbed, silent)

//
// Returns examine messages for bellies
//
/mob/living/proc/examine_bellies()
//	if(!show_pudge()) //OV REMOVE - Some clothing or equipment can hide this.
//		return list() //OV REMOVE

	var/list/message_list = list()
	for(var/obj/belly/B as anything in vore_organs)
		//OV edit
		if(B.hidden_by_armor)
			if(!show_pudge())
				continue
		//OV edit end
		var/bellymessage = B.get_examine_msg()
		if(bellymessage) message_list += bellymessage

		bellymessage = B.get_examine_msg_absorbed()
		if(bellymessage) message_list += bellymessage

	return message_list

//
// Whether or not people can see our belly messages
//
/mob/living/proc/show_pudge()
	return TRUE //Can override if you want.

/mob/living/carbon/human/show_pudge()
	//A uniform could hide it.
	if(istype(wear_shirt,/obj/item/clothing))
		/*var/obj/item/clothing/under = wear_shirt
		if(istype(under) && under.hides_bulges)*/
		return FALSE

	//We return as soon as we find one, no need for 'else' really.
	if(istype(wear_armor,/obj/item/clothing))
		/*var/obj/item/clothing/suit = wear_armor
		if(istype(suit) && suit.hides_bulges)*/
		return FALSE

	return ..()

//
// Formats the belly texts if possible
//

/mob/living/proc/formatted_vore_examine()
	var/reagent_examine = examine_reagent_bellies()
	var/list/examine_belly = examine_bellies()
	if(!reagent_examine && !LAZYLEN(examine_belly))
		return ""
	var/list/vore_examine_data = list()
	vore_examine_data += reagent_examine
	vore_examine_data += examine_belly
	/*if(!client?.prefs?.read_preference(/datum/preference/toggle/vchat_enable))
		return vore_examine_data*/

	return span_details("Vore Descriptions", vore_examine_data.Join("\n")) //OV EDIT


//
// Clearly super important. Obviously.
//
/mob/living/verb/lick_taste(mob/living/tasted in living_mobs_in_view(1, TRUE))
	set name = "Lick someone"
	set category = "Vore" //OV EDIT
	set desc = "Lick someone nearby!"
	set popup_menu = FALSE // Stop licking by accident!

	if(!istype(tasted))
		return

	if(!checkClickCooldown() || incapacitated(INCAPACITATION_KNOCKOUT))
		return

	setClickCooldown(CLICK_CD_MELEE)

	if(tasted == src)
		visible_message(span_warning("[src] licks themself!"),span_notice("You lick yourself. You taste rather like [tasted.get_taste_message()]."),span_info(span_bold("Slurp!")))
		//balloon_alert_visible("licks themself!", "tastes like [tasted.get_taste_message()]")
	else
		if(tasted.skin_reagent && ishuman(src) && (tasted != src))
			var/mob/living/carbon/human/us_but_human = src
			us_but_human.reagents.add_reagent(tasted.skin_reagent, 5)
		
		visible_message(span_warning("[src] licks [tasted]!"),span_notice("You lick [tasted]. They taste rather like [tasted.get_taste_message()]."),span_info(span_bold("Slurp!")))
		//balloon_alert_visible("licks [tasted]!", "tastes like [tasted.get_taste_message()]")
	/* //Caustic - Maybe we add this in sometime?
	// This has already passed consent tests
	if(HAS_TRAIT(src, TRAIT_SLOBBER))
		tasted.adjust_wet_stacks(2)*/

/mob/living/proc/get_taste_message(allow_generic = 1)
	if(!vore_taste && !allow_generic)
		return FALSE

	var/taste_message = ""
	if(vore_taste && (vore_taste != ""))
		taste_message += "[vore_taste]"
	else
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			taste_message += "a normal [H.dna.species.name]"
		else
			taste_message += "a plain old normal [src]"

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.reagents.reagent_list.len) //Just the first one otherwise I'll go insane.
			var/datum/reagent/R = H.reagents.reagent_list[1]
			taste_message += " You also get the flavor of [R.taste_description] from something on them"
	return taste_message



//This is just the above proc but switched about.
/mob/living/verb/smell(mob/living/smelled in living_mobs(1, TRUE))
	set name = "Smell someone"
	set category = "Vore" //OV EDIT
	set desc = "Smell someone nearby!"
	set popup_menu = FALSE

	if(!istype(smelled))
		return
	if(!checkClickCooldown() || incapacitated(INCAPACITATION_KNOCKOUT))
		return

	setClickCooldown((CLICK_CD_MELEE))

	if(smelled == src)
		visible_message(span_warning("[src] smells themself!"),span_notice("You smell yourself. You smell like [smelled.get_smell_message()]."),span_info(span_bold("Sniff!")))
		//balloon_alert_visible("smells themself!", "smells like [smelled.get_smell_message()]")
	else
		visible_message(span_warning("[src] smells [smelled]!"),span_notice("You smell [smelled]. They smell like [smelled.get_smell_message()]."),span_info(span_bold("Sniff!")))
		//balloon_alert_visible("smells [smelled]!", "smells like [smelled.get_smell_message()]")

/mob/living/proc/get_smell_message(allow_generic = 1)
	if(!vore_smell && !allow_generic)
		return FALSE

	var/smell_message = ""
	if(vore_smell && (vore_smell != ""))
		smell_message += "[vore_smell]"
	else
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			smell_message += "a normal [H.dna.species.name]"
		else
			smell_message += "a plain old normal [src]"

	return smell_message




//
// OOC Escape code for pref-breaking or AFK preds
//
/mob/living/proc/escapeOOC()
	set name = "OOC Escape"
	set category = "OOC.Vore"

	//You're in a belly!
	if(isbelly(loc))
		var/obj/belly/B = loc
		var/confirm = tgui_alert(src, "Please feel free to use this button at any time you are uncomfortable and in a belly. Consent is important.", "Confirmation", list("Okay", "Cancel"))
		if(confirm != "Okay" || loc != B)
			return
		//Actual escaping
		absorbed = FALSE	//Make sure we're not absorbed
		muffled = FALSE		//Removes Muffling
		forceMove(get_turf(src)) //Just move me up to the turf, let's not cascade through bellies, there's been a problem, let's just leave.
		SetSleeping(0) //Wake up instantly if asleep
		/*for(var/mob/living/simple_animal/SA in range(10)) //Commented out Simplemob stuff for now, just to get the rest working
			LAZYSET(SA.prey_excludes, src, world.time)*/
		log_and_message_admins("[key_name(src)] used the OOC escape button to get out of [key_name(B.owner)] ([B.owner ? "<a href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[B.owner.x];Y=[B.owner.y];Z=[B.owner.z]'>JMP</a>" : "null"])", src)

		B.owner.handle_belly_update() //This is run whenever a belly's contents are changed.
	
	//You've been turned into an item!
	/*else if(tf_mob_holder && isvoice(src) && istype(src.loc, /obj/item)) //Commented out the TF stuff for now to get the rest working.
		var/obj/item/item_to_destroy = src.loc //If so, let's destroy the item they just TF'd out of.
		//If tf_mob_holder is not located in src, then it's a Mind Binder OOC Escape
		var/mob/living/ourmob = tf_mob_holder
		if(ourmob.loc != src)
			if(isnull(ourmob.loc))
				var/mob/living/voice/possessed_voice = src  // Stupid band-aid fix for OOC escaping object TF
				if(possessed_voice.item_tf)
					mind.transfer_to(ourmob)
					item_to_destroy.possessed_voice -= src
					qdel(src)
					ourmob.forceMove(item_to_destroy.loc)
					qdel(item_to_destroy)
					log_and_message_admins("[key_name(src)] used the OOC escape button to revert back to their original form from being TFed into an object.")
					return
				to_chat(src,span_notice("You have no body."))
				src.tf_mob_holder = null
				return
			if(ourmob.ckey)
				to_chat(src,span_notice("Your body appears to be in someone else's control."))
				return
			src.mind.transfer_to(ourmob)
			item_to_destroy.possessed_voice -= src
			qdel(src)
			log_and_message_admins("[key_name(src)] used the OOC escape button to revert back to their original form from being TFed into an object.")
			return
		if(istype(src.loc, /obj/item/clothing)) //Are they in clothes? Delete the item then revert them.
			qdel(item_to_destroy)
			log_and_message_admins("[key_name(src)] used the OOC escape button to revert back to their original form from being TFed into an object.", src)
			revert_mob_tf()
		else //Are they in any other type of object? If qdel is done first, the mob is deleted from the world.
			forceMove(get_turf(src))
			qdel(item_to_destroy)
			log_and_message_admins("[key_name(src)] used the OOC escape button to revert back to their original form from being TFed into an object.", src)
			revert_mob_tf()

	//You've been turned into a mob!
	else if(tf_mob_holder)
		log_and_message_admins("[key_name(src)] used the OOC escape button to revert back to their original form from being TFed into another mob.", src)
		revert_mob_tf()*/

	/*else if(istype(loc, /obj/structure/gargoyle) && loc:was_rayed) //For petrification stuff. Probably not anything we have the ability to cause to anyone yet?
		var/obj/structure/gargoyle/G = loc
		G.can_revert = TRUE
		qdel(G)
		log_and_message_admins("[key_name(src)] used the OOC escape button to revert back from being petrified.", src)*/

	//In-shoe OOC escape. Checking voices as precaution if something akin to obj TF or possession happens
	else if(!istype(src, /mob/living/voice) && istype(src.loc, /obj/item/clothing/shoes))
		var/obj/item/clothing/shoes/S = src.loc
		forceMove(get_turf(src))
		log_and_message_admins("[key_name(src)] used the OOC escape button to escape from of a pair of shoes. [ADMIN_FLW(src)] - Shoes [ADMIN_VV(S)]")

	//You are in food and for some reason can't resist out
	else if(istype(loc, /obj/item/reagent_containers/food))
		var/obj/item/reagent_containers/food/F = src.loc
		if(F.food_inserted_micros)
			F.food_inserted_micros -= src
		src.forceMove(get_turf(F))
		log_and_message_admins("[key_name(src)] used the OOC escape button to get out of a food item.", src)

	else if(alerts && alerts["leashed"])
		var/atom/movable/screen/alert/status_effect/leash_pet/pet_alert = src.alerts["leashed"]
		var/obj/item/leash/owner = pet_alert.master
		if(owner.leash_pet)
			owner.leash_pet.dropItemToGround(owner, TRUE)
		else if(owner.leash_freepet)
			owner.leash_freepet.dropItemToGround(owner, TRUE)
		log_and_message_admins("[key_name(src)] used the OOC escape button to get out of a leash.", src)

	//Don't appear to be in a vore situation
	else
		to_chat(src,span_warning("You aren't inside anyone, though, is the thing."))

//
// Eating procs depending on who clicked what
//

/mob/living/proc/feedable_bellies()
	var/list/bellies = list()
	for(var/obj/belly/Y in src.vore_organs)
		if(Y.is_feedable)
			bellies += Y
	return bellies

/mob/living/proc/feed_grabbed_to_self(mob/living/user, mob/living/prey)
	var/belly = user.vore_selected
	return perform_the_nom(user, prey, user, belly)

/mob/living/proc/eat_held_mob(mob/living/user, mob/living/prey, mob/living/pred)
	var/belly
	if(user != pred)
		belly = tgui_input_list(user, "Choose Belly", "Belly Choice", pred.feedable_bellies())
	else
		belly = pred.vore_selected
	return perform_the_nom(user, prey, pred, belly)

/mob/living/proc/feed_self_to_grabbed(mob/living/user, mob/living/pred)
	var/belly = tgui_input_list(user, "Choose Belly", "Belly Choice", pred.feedable_bellies())
	return perform_the_nom(user, user, pred, belly)

/mob/living/proc/feed_grabbed_to_other(mob/living/user, mob/living/prey, mob/living/pred)
	var/belly = tgui_input_list(user, "Choose Belly", "Belly Choice", pred.feedable_bellies())
	return perform_the_nom(user, prey, pred, belly)

//
// Magical pred-air breathing for inside preds
// overrides a proc defined on atom called by breathe.dm
//
/*/obj/belly/return_air()
	return return_air_for_internal_lifeform()

/obj/belly/return_air_for_internal_lifeform(var/mob/living/lifeform)
	//Free air until someone wants to code processing it for reals from predbreaths
	var/air_type = /datum/gas_mixture/belly_air
	if(istype(lifeform))	// If this doesn't succeed, then 'lifeform' is actually a bag or capture crystal with someone inside
		air_type = lifeform.get_perfect_belly_air_type()		// Without any overrides/changes, its gonna be /datum/gas_mixture/belly_air
	var/air = new air_type(1000)
	return air*/

/*mob/living/proc/get_perfect_belly_air_type()
	return /datum/gas_mixture/belly_air

/mob/living/carbon/human/get_perfect_belly_air_type()
	if(species)
		return species.get_perfect_belly_air_type()
	return ..()

// This is about 0.896m^3 of atmosphere
/datum/gas_mixture/belly_air
	volume = 2500
	temperature = 293.150
	total_moles = 104

/datum/gas_mixture/belly_air/New()
	. = ..()
	gas = list(
		GAS_O2 = 21,
		GAS_N2 = 79)

/datum/gas_mixture/belly_air/vox
	volume = 2500
	temperature = 293.150
	total_moles = 104

/datum/gas_mixture/belly_air/vox/New()
	. = ..()
	gas = list(
		GAS_N2 = 100) // CHOMPEdit

/datum/gas_mixture/belly_air/zaddat
	volume = 2500
	temperature = 293.150
	total_moles = 300

/datum/gas_mixture/belly_air/zaddat/New()
	. = ..()
	gas = list(
		GAS_O2 = 100)

/datum/gas_mixture/belly_air/nitrogen_breather
	volume = 2500
	temperature = 293.150
	total_moles = 104

/datum/gas_mixture/belly_air/nitrogen_breather/New()
	. = ..()
	gas = list(
		GAS_N2 = 100)

/datum/gas_mixture/belly_air/carbon_dioxide_breather
	volume = 2500
	temperature = 293.150
	total_moles = 104

/datum/gas_mixture/carbon_dioxide_breather/New()
	. = ..()
	gas = list(
		GAS_CO2 = 100)

/datum/gas_mixture/belly_air/methane_breather
	volume = 2500
	temperature = 293.150
	total_moles = 104

/datum/gas_mixture/belly_air/methane_breather/New()
	. = ..()
	gas = list(
		GAS_CH4 = 100)*/

/mob/living/proc/feed_grabbed_to_self_falling_nom(var/mob/living/user, var/mob/living/prey)
	var/belly = user.vore_selected
	return begin_instant_nom(user, prey, user, belly)

/mob/living/proc/get_current_spont_belly(atom/movable/preything)
	var/direction_diff = angle2dir_cardinal(dir2angle(get_dir(src, preything)) - dir2angle(dir))
	var/spont_belly_name
	switch(direction_diff)
		if(NORTH)
			if(spont_belly_front)
				spont_belly_name = spont_belly_front
		if(SOUTH)
			if(spont_belly_rear)
				spont_belly_name = spont_belly_rear
		if(EAST)
			if(spont_belly_right)
				spont_belly_name = spont_belly_right
		if(WEST)
			if(spont_belly_left)
				spont_belly_name = spont_belly_left
	for(var/obj/belly/lookup_belly in vore_organs)
		if(lookup_belly.name == spont_belly_name)
			return lookup_belly
	return vore_selected

/*/mob/living/proc/glow_toggle() //Caustic - Commenting out Glow for now, might not be worth bothering with
	set name = "Glow (Toggle)"
	set category = "Abilities.General"
	set desc = "Toggle your glowing on/off!"

	if(stat || IsParalyzed() || IsImmobilized() || IsStun() || IsKnockdown() || world.time < last_special)
		to_chat(src, span_warning("You can't do that in your current state."))
		return

	//I don't really see a point to any sort of checking here.
	//If they're passed out, the light won't help them. Same with buckled. Really, I think it's fine to do this whenever.
	glow_toggle = !glow_toggle

	to_chat(src,span_notice("You " + span_bold("[glow_toggle ? "en" : "dis"]") + "able your body's glow."))

/mob/living/proc/glow_color()
	set name = "Glow (Set Color)"
	set category = "Abilities.Settings"
	set desc = "Pick a color for your body's glow."

	//Again, no real need for a check on this. I'm unsure how it could be somehow abused.
	//Even if they open the box 900 times, who cares, they get the wrong color and do it again.
	var/new_color = tgui_color_picker(src,"Select a new color","Body Glow",glow_color)
	if(new_color)
		glow_color = new_color*/

/mob/living/proc/get_digestion_nutrition_modifier()
	return 1

/mob/living/proc/get_digestion_efficiency_modifier()
	return 1

/mob/living/verb/eat_trash()
	set name = "Eat object"
	set category = "Vore" //OV EDIT
	set desc = "Consume held object into currently selected belly."

	//on chomp it worked off a whitelist of items you could devour, hope is that here it can be replaced by a long windup before eating something

	if(stat || world.time < last_special) //probably needs a look over for CC specific states but probably should be fine ?
		to_chat(src, span_warning("You can't do that in your current state."))
		return

	if(!vore_selected)
		to_chat(src,span_warning("You either don't have a belly selected, or don't have a belly!"))
		return

	var/obj/item/I = get_active_held_item()
	if(!I)
		to_chat(src, span_notice("You are not holding anything."))
		return
	
	//OV edit
	if(I.mob_possession)
		if(!I.mob_possession.devourable)
			to_chat(src, span_notice("Their preferences do not allow them to be eaten."))
			return
	//OV edit end

	//if(I.) //Caustic - Potential Whitelist can go here.

	if(!(I.grid_height <= world.icon_size || I.grid_width <= world.icon_size)) //OV EDIT
		to_chat(src,span_warning("You can't eat such a large thing !"))//yet <-- YET???
		return

	if(do_after(src, 10 SECONDS)){
		if(!dropItemToGround(I))
			to_chat(src,span_warning("You can't eat that!"))
			return
		vore_selected.nom_atom(I)
		updateVRPanel()
		log_admin("VORE: [src] used Eat Trash to swallow [I].")

		visible_message(span_warning(src.vore_selected.belly_format_string(src.vore_selected.trash_eater_in, I, item=I)))
	}else{
		to_chat(src,span_warning("You need to stay still to eat that!"))
	}

	return

/* //Caustic - Do we enable this?
/mob/living/proc/toggle_trash_catching() //Ported from chompstation
	set name = "Toggle Trash Catching"
	set category = "Vore" //OV EDIT
	set desc = "Toggle Trash Eater throw vore abilities."
	trash_catching = !trash_catching
	to_chat(src, span_warning("Trash catching [trash_catching ? "enabled" : "disabled"]."))*/

/*
/mob/living/proc/eat_minerals() //Actual eating abstracted so the user isn't given a prompt due to an argument in this verb.
	set name = "Eat Minerals"
	set category = "Vore" //OV EDIT
	set desc = "Consume held raw ore, gems and refined minerals. Snack time!"

	handle_eat_minerals()

/mob/living/proc/handle_eat_minerals(obj/item/snack, mob/living/user)
	var/mob/living/feeder = user ? user : src //Whoever's doing the feeding - us or someone else.
	var/mob/living/carbon/human/H = src
	if(!(adminbus_eat_minerals || (istype(H) && H.species.eat_minerals))) //Am I awesome enough to eat a shiny rock?
		return

	if(!vore_selected)
		to_chat(src, span_warning("You either don't have a belly selected, or don't have a belly!"))
		return

	var/obj/item/I = (snack ? snack : feeder.get_active_held_item())
	if(!I)
		to_chat(feeder, span_notice("You look longingly at your empty hands, imagining if they held something edible..."))
		return

	if(!istype(I))
		to_chat(src, span_notice("You pause for a moment to examine [I] and realize it's not even worth the energy to chew."))
		return

	var/list/nom = null
	var/datum/material/M = null
	if(istype(I, /obj/item/ore)) //Raw unrefined ore. Some things are just better untempered!
		var/obj/item/ore/O = I
		//List in list, define by material property of ore in code/mining/modules/ore.dm.
		//50 nutrition = 5 ore to get 250 nutrition. 250 is the beginning of the 'well fed' range.
		var/list/rock_munch = list(
			ORE_URANIUM		= list("nutrition" = 30, "remark" = "Crunching [O] in your jaws almost makes you wince, a horribly tangy and sour flavour radiating through your mouth. It goes down all the same.", "WTF" = FALSE),
			ORE_HEMATITE	= list("nutrition" = 15, "remark" = "The familiar texture and taste of [O] does the job but leaves little to the imagination and hardly sates your appetite.", "WTF" = FALSE),
			ORE_CARBON		= list("nutrition" = 15, "remark" = "Utterly bitter, crunching down on [O] only makes you long for better things. But a snack's a snack...", "WTF" = FALSE),
			ORE_MARBLE		= list("nutrition" = 40, "remark" = "A fitting dessert, the sweet and savoury [O] lingers on the palate and satisfies your hunger.", "WTF" = FALSE),
			ORE_SAND		= list("nutrition" = 0,  "remark" = "You crunch on [O] but its texture is almost gag-inducing. Stifling a cough, you somehow manage to swallow both [O] and your regrets.", "WTF" = FALSE),
			ORE_PHORON		= list("nutrition" = 30, "remark" = "Crunching [O] to dust between your jaw you find pleasant, comforting warmth filling your mouth that briefly spreads down the throat to your chest as you swallow.", "WTF" = FALSE),
			ORE_SILVER		= list("nutrition" = 40, "remark" = "[O] tastes quite nice indeed as you munch on it. A little tarnished, but that's just fine aging.", "WTF" = FALSE),
			ORE_GOLD		= list("nutrition" = 40, "remark" = "You taste supreme richness that exceeds expectations and satisfies your hunger.", "WTF" = FALSE),
			ORE_DIAMOND		= list("nutrition" = 50, "remark" = "The heavenly taste of [O] almost brings a tear to your eye. Its glimmering gloriousness is even better on the tongue than you imagined, so you savour it fondly.", "WTF" = FALSE),
			ORE_PLATINUM	= list("nutrition" = 40, "remark" = "A bit tangy but elegantly balanced with a long faintly sour finish. Delectable.", "WTF" = FALSE),
			ORE_MHYDROGEN	= list("nutrition" = 30, "remark" = "Quite sweet on the tongue, you savour the light and easy to chew [O], finishing it quickly.", "WTF" = FALSE),
			ORE_RUTILE		= list("nutrition" = 50, "remark" = "A little... angular, you savour the light but chewy [O], finishing it quickly.", "WTF" = FALSE),
			ORE_VERDANTIUM	= list("nutrition" = 50, "remark" = "You taste scientific mystery and a rare delicacy. Your tastebuds tingle pleasantly as you eat [O] and the feeling warmly blossoms in your chest for a moment.", "WTF" = FALSE),
			ORE_LEAD		= list("nutrition" = 40, "remark" = "It takes some work to break down [O] but you manage it, unlocking lasting tangy goodness in the process. Yum.", "WTF" = FALSE)
		)
		if(O.material in rock_munch)
			nom	= rock_munch[O.material]
			M 	= name_to_material[O.material]
		else if(istype(O, /obj/item/ore/slag))
			nom	= list("nutrition" = 15, "remark" = "You taste dusty, crunchy mistakes. This is a travesty... but at least it is an edible one.",  "WTF" = FALSE)
		else //Random rock.
			nom = list("nutrition" = 0,  "remark" = "You taste stony, gravelly goodness - but you crave something with actual nutritional value.", "WTF" = FALSE)

	else if(istype(I, /obj/item/stack/material)) //The equivalent of a cooked meal I guess. Stuff that is compressed during refinement has had nutrition bumped up by 5.
		var/obj/item/stack/material/O = I
		var/list/refined_taste = list(
			MAT_URANIUM						= list("nutrition" = 30,  "remark" = "Crunching [O] in your jaws almost makes you wince, a horribly tangy and sour flavour radiating through your mouth. It goes down all the same.", "WTF" = FALSE),
			MAT_DIAMOND						= list("nutrition" = 55,  "remark" = "After significant effort to crumble the gem, you unlock heavenly flavour that almost brings a tear to your eye. Its glimmering gloriousness is even better on the tongue than you imagined, so you savour it fondly.", "WTF" = FALSE),
			MAT_GOLD						= list("nutrition" = 40,  "remark" = "You taste supreme richness that exceeds expectations and satisfies your hunger.", "WTF" = FALSE),
			MAT_SILVER						= list("nutrition" = 40,  "remark" = "[O] tastes quite nice indeed as you munch on it. A little tarnished, but that's just fine aging.", "WTF" = FALSE),
			MAT_PHORON						= list("nutrition" = 35,  "remark" = "Crunching [O] to dust between your jaw you find pleasant, comforting warmth filling your mouth that briefly spreads down the throat to your chest as you swallow.", "WTF" = FALSE),
			MAT_SANDSTONE					= list("nutrition" = 0,   "remark" = "You crumble [O] easily in your jaws but its texture is almost gag-inducing. Stifling a cough, you somehow manage to swallow both [O] and your regrets.", "WTF" = FALSE),
			MAT_MARBLE						= list("nutrition" = 40,  "remark" = "A fitting dessert, the sweet and savoury [O] lingers on the palate and satisfies your hunger.", "WTF" = FALSE),
			MAT_STEEL						= list("nutrition" = 20,  "remark" = "Rending the [O] apart with ease, you briefly enjoy a classic but unremarkable taste. You need something more substantial.", "WTF" = FALSE),
			MAT_PLASTEEL					= list("nutrition" = 40,  "remark" = "The elegant taste of a fine richly-augmented alloy, chewing away on [O] yields lasting and satisfying flavour with a traditional metallic tang.", "WTF" = FALSE),
			MAT_DURASTEEL					= list("nutrition" = 65,  "remark" = "After much grinding the [O] eventually yields a sublime rush of flavours dominated by glorious diamond, further improved by the rich balance platinum and tang carbonic steel both bring to the mix: A supremely full bodied and savoury experience.", "WTF" = FALSE),
			MAT_TITANIUM					= list("nutrition" = 45,  "remark" = "The trademark bite and density of [O], somehow light on the palate with a refreshing coolness that lasts. Much improved with refinement, it certainly hits the spot.", "WTF" = FALSE),
			MAT_TITANIUMGLASS				= list("nutrition" = 20,  "remark" = "Grinding [O] down with a satisfying crunch, you quickly feel a cool and refreshing rush of flavour. It almost makes you even hungrier...", "WTF" = FALSE),
			MAT_PLASTITANIUM				= list("nutrition" = 60,  "remark" = "A glorious marriage of richness and mildly sour with cool refreshing finish. [O] practically begs to be savoured, lingering on the palate long enough to tempt another bite.", "WTF" = FALSE),
			MAT_PLASTITANIUMGLASS			= list("nutrition" = 25,  "remark" = "After some work, you grind [O] down with a satisfying crunch to unleash a sublime mixture of mildly sour richness and cooling refreshment. It readily entices you for another bite.", "WTF" = FALSE),
			MAT_GLASS						= list("nutrition" = 0,   "remark" = "All crunch and nothing more, you effortlessly grind [O] down to find it only wets your appetite and dries the throat.", "WTF" = FALSE),
			MAT_RGLASS						= list("nutrition" = 5,   "remark" = "With a satisfying crunch, you grind [O] down with ease. It is barely palatable with a subtle metallic tang.", "WTF" = FALSE),
			MAT_PGLASS						= list("nutrition" = 10,  "remark" = "With a satisfying crunch, you grind [O] down with ease and find it somewhat palatable due to a subtle but familiar rush of phoronic warmth.", "WTF" = FALSE),
			MAT_RPGLASS						= list("nutrition" = 15,  "remark" = "With a satisfying crunch, you grind [O] down. It is quite palatable due to a subtle metallic tang and familiar rush of phoronic warmth.", "WTF" = FALSE),
			MAT_GRAPHITE					= list("nutrition" = 30,  "remark" = "Satisfyingly metallic with a mildly savoury tartness, you chew [O] until its flavour is no more but are left longing for another.", "WTF" = FALSE),
			MAT_OSMIUM						= list("nutrition" = 45,  "remark" = "Successive bites serve to almost chill your palate, a rush of rich and mildly sour flavour unlocked with the grinding of your powerful jaws. Delectable.", "WTF" = FALSE),
			MAT_METALHYDROGEN				= list("nutrition" = 35,  "remark" = "Quite sweet on the tongue, you savour the light and easy to chew [O], finishing it quickly.", "WTF" = FALSE),
			MAT_PLATINUM					= list("nutrition" = 40,  "remark" = "A bit tangy but elegantly balanced with a long faintly sour finish. Delectable.", "WTF" = FALSE),
			MAT_IRON						= list("nutrition" = 15,  "remark" = "The familiar texture and taste of [O] does the job but leaves little to the imagination and hardly sates your appetite.", "WTF" = FALSE),
			MAT_LEAD						= list("nutrition" = 40,   "remark" = "It takes some work to break down [O] but you manage it, unlocking lasting tangy goodness in the process. Yum.", "WTF" = FALSE),
			MAT_VERDANTIUM					= list("nutrition" = 55,  "remark" = "You taste scientific mystery and a rare delicacy. Your tastebuds tingle pleasantly as you eat [O] and the feeling warmly blossoms in your chest for a moment.", "WTF" = FALSE),
			MAT_MORPHIUM					= list("nutrition" = 75,  "remark" = "The question, the answer and the taste: It all floods your mouth and your mind to momentarily overwhelm the senses. What the hell was that? Your mouth and throat are left tingling for a while.", "WTF" = 10),
			MAT_ALIENALLOY					= list("nutrition" = 120, "remark" = "Working hard for so long to rend the material apart has left your jaw sore, but a veritable explosion of mind boggling indescribable flavour is unleashed. Completely alien sensations daze and overwhelm you while it feels like an interdimensional rift opened in your mouth, briefly numbing your face.", "WTF" = 15)
		)
		if(O.default_type in refined_taste)
			var/obj/item/stack/material/stack = O.split(1) //A little off the top.
			I	= stack
			nom	= refined_taste[O.default_type]
			M	= name_to_material[O.default_type]
	else if(istype(I, /obj/item/entrepreneur/crystal))
		nom = list("nutrition" = 100,  "remark" = "The crytal was particularly brittle and not difficult to break apart, but the inside was incredibly flavoursome. Though devoid of any actual healing power, it seems to be very nutritious!", "WTF" = FALSE)

	if(nom) //Ravenous 1-4, snackage confirmed. Clear for chowdown, over.
		playsound(src, 'sound/items/eatfood.ogg', rand(10,50), 1)
		var/T = (istype(M) ? M.hardness/40 : 1) SECONDS //1.5 seconds to eat a sheet of metal. 2.5 for durasteel and diamond & 1 by default (applies to some ores like raw carbon, slag, etc.
		to_chat(src, span_notice("You start crunching on [I] with your powerful jaws, attempting to tear it apart..."))
		if(do_after(feeder, T, target = src, timed_action_flags = IGNORE_USER_LOC_CHANGE)) //Eat on the move, but not multiple things at once.
			if(feeder != src)
				to_chat(feeder, span_notice("You feed [I] to [src]."))
				log_admin("VORE: [feeder] fed [src] [I].")
			else
				log_admin("VORE: [src] used Eat Minerals to swallow [I].")
			//Eat the ore using the vorebelly for the sound then get rid of the ore to prevent infinite nutrition.
			dropItemToGround(I, vore_selected) //Never touches the ground - straight to the gut.
			visible_message("[src] crunches [I] to pieces and swallows it down.",
				span_notice("[nom["remark"]]"),
				span_notice("You hear the gnashing of jaws with some ominous grinding and crunching noises, then... Swallowing?"))

			adjust_nutrition(nom["nutrition"])
			qdel(I)

			if(nom["WTF"]) //Bites back.
				H.Weaken(2)
				H.Confuse(nom["WTF"])
				H.apply_effect(nom["WTF"], STUTTER)
				H.make_jittery(nom["WTF"])
				H.make_dizzy(nom["WTF"])
				H.druggy = max(H.druggy, nom["WTF"])

			return TRUE
		else
			to_chat(src, span_notice("You were interrupted while gnawing on [I]!"))

	else //Not the droids we're looking for.
		to_chat(src, span_notice("You pause for a moment to examine [I] and realize it's not even worth the energy to chew.")) //If it ain't ore or the type of sheets we can eat, bugger off!
*/

/*/mob/living/verb/toggle_stuffing_mode() <-- Pains me so fucking much to comment this out but this is for later //Caustic - Enable this as well sometime?
	set name = "Toggle feeding mode"
	set category = "Vore" //OV EDIT
	set desc = "Switch whether you will try to feed other people food whole or normally, bite by bite."

	stuffing_feeder = !stuffing_feeder
	to_chat(src, span_notice("You will [stuffing_feeder ? "now" : "no longer"] try to feed food whole."))*/

/*/mob/living/proc/switch_scaling()
	set name = "Switch scaling mode"
	set category = "Preferences.Game"
	set desc = "Switch sharp/fuzzy scaling for current mob."
	appearance_flags ^= PIXEL_SCALE
	fuzzy = !fuzzy
	update_transform()*/

/*/mob/living/proc/center_offset()
	set name = "Switch center offset mode"
	set category = "Preferences.Game"
	set desc = "Switch sprite center offset to fix even/odd symmetry."
	offset_override = !offset_override
	update_transform()*/

/*/mob/living/examine(mob/user, infix, suffix)
	. = ..()
	if(custom_link)
		. += "Custom link: " + span_linkify("[custom_link]")
	if(ooc_notes)
		. += "OOC Notes: <a href='byond://?src=\ref[src];ooc_notes=1'>\[View\]</a> - <a href='byond://?src=\ref[src];print_ooc_notes_chat=1'>\[Print\]</a>"
	. += "<a href='byond://?src=\ref[src];vore_prefs=1'>\[Mechanical Vore Preferences\]</a>"
*/


/*/mob/living/Topic(href, href_list)	//Can't find any instances of Topic() being overridden by /mob/living in polaris' base code, even though /mob/living/carbon/human's Topic() has a ..() call
	if(href_list["vore_prefs"])
		display_voreprefs(usr)
	if(href_list["ooc_notes"])
		do_examine_ooc(usr)
	if(href_list["edit_ooc_notes"])
		if(usr == src)
			set_metainfo_panel(usr)
	if(href_list["edit_ooc_note_likes"])
		if(usr == src)
			set_metainfo_likes(usr)
	if(href_list["edit_ooc_note_dislikes"])
		if(usr == src)
			set_metainfo_dislikes(usr)
	if(href_list["save_ooc_panel"])
		if(usr == src)
			save_ooc_panel(usr)
	if(href_list["print_ooc_notes_chat"])
		print_ooc_notes_chat(usr)
	if(href_list["edit_ooc_note_favs"])
		if(usr == src)
			set_metainfo_favs(usr)
	if(href_list["edit_ooc_note_maybes"])
		if(usr == src)
			set_metainfo_maybes(usr)
	if(href_list["set_metainfo_ooc_style"])
		set_metainfo_ooc_style(usr)
	if(href_list["save_private_notes"])
		if(usr == src)
			save_private_notes(usr)
	if(href_list["edit_private_notes"])
		if(usr == src)
			set_metainfo_private_notes(usr)
	return ..()*/

/mob/living/proc/display_voreprefs(mob/user)	//Called by Topic() calls on instances of /mob/living (and subtypes) containing vore_prefs as an argument
	if(!user)
		CRASH("display_voreprefs() was called without an associated user.")
	var/dat = "<br>" + span_bold("[src]'s vore preferences") + "<br><br>"
	/*if(!client?.prefs?.read_preference(/datum/preference/toggle/show_ooc))
		dat += span_red(span_bold("OOC DISABLED")) + "<br>"
	if(!client?.prefs?.read_preference(/datum/preference/toggle/show_looc))
		dat += span_red(span_bold("LOOC DISABLED")) + "<br>"*/
	dat += span_bold("Devourable:") + " [devourable ? span_green("Enabled") : span_red("Disabled")]<br>"
	if(devourable)
		dat += span_bold("Healbelly permission:") + " [permit_healbelly ? span_green("Allowed") : span_red("Disallowed")]<br>"
		dat += span_bold("Digestable:") + " [digestable ? span_green("Enabled") : span_red("Disabled")]<br>"
		dat += span_bold("Absorption Permission:") + " [absorbable ? span_green("Allowed") : span_red("Disallowed")]<br>"
		dat += span_bold("Selective Mode Pref:") + " [src.selective_preference]<br>"
		dat += span_bold("Mob Vore:") + " [allowmobvore ? span_green("Enabled") : span_red("Disabled")]<br>"
		dat += span_bold("Affected by temperature:") + " [allowtemp ? span_green("Enabled") : span_red("Disabled")]<br>"
		dat += span_bold("Autotransferable:") + " [autotransferable ? span_green("Enabled") : span_red("Disabled")]<br>"
		dat += span_bold("Can be stripped:") + " [strip_pref ? span_green("Allowed") : span_red("Disallowed")]<br>"
		dat += span_bold("Applying reagents:") + " [apply_reagents ? span_green("Allowed") : span_red("Disallowed")]<br>"
		dat += span_bold("Leaves Remains:") + " [digest_leave_remains ? span_green("Enabled") : span_red("Disabled")]<br>"
	dat += span_bold("Spontaneous vore prey:") + " [can_be_drop_prey ? span_green("Enabled") : span_red("Disabled")]<br>"
	dat += span_bold("Spontaneous vore pred:") + " [can_be_drop_pred ? span_green("Enabled") : span_red("Disabled")]<br>"
	if(can_be_drop_prey || can_be_drop_pred)
		dat += span_bold("Drop Vore:") + " [drop_vore ? span_green("Enabled") : span_red("Disabled")]<br>"
		dat += span_bold("Slip Vore:") + " [slip_vore ? span_green("Enabled") : span_red("Disabled")]<br>"
		dat += span_bold("Stumble Vore:") + " [stumble_vore ? span_green("Enabled") : span_red("Disabled")]<br>"
		dat += span_bold("Throw vore:") + " [throw_vore ? span_green("Enabled") : span_red("Disabled")]<br>"
		dat += span_bold("Food Vore:") + " [food_vore ? span_green("Enabled") : span_red("Disabled")]<br>"
		dat += span_bold("Phase Vore:") + " [phase_vore ? span_green("Enabled") : span_red("Disabled")]<br>"
	dat += span_bold("Can be stepped on/over:") + " [step_mechanics_pref ? span_green("Allowed") : span_red("Disallowed")]<br>"
	dat += span_bold("Can be picked up:") + " [pickup_pref ? span_green("Allowed") : span_red("Disallowed")]<br>"
	dat += span_bold("Can be resized:") + " [resizable ? span_green("Allowed") : span_red("Disallowed")]<br>"
	dat += span_bold("Spontaneous transformation:") + " [allow_spontaneous_tf ? span_green("Enabled") : span_red("Disabled")]<br>"
	dat += span_bold("Mind transfer:") + " [allow_mind_transfer ? span_green("Allowed") : span_red("Disallowed")]<br>"
	dat += span_bold("Allow Mimicry:") + " [allow_mimicry ? span_green("Yes") : span_red("No")]<br>"
	dat += span_bold("Feedable:") + " [feeding ? span_green("Enabled") : span_red("Disabled")]<br>"
	dat += span_bold("Receiving liquids:") + " [receive_reagents ? span_green("Enabled") : span_red("Disabled")]<br>"
	dat += span_bold("Giving liquids:") + " [give_reagents ? span_green("Enabled") : span_red("Disabled")]<br>"
	dat += span_bold("Consuming liquids:") + " [consume_liquid_belly ? span_green("Enabled") : span_red("Disabled")]<br>"
	dat += span_bold("Late join spawn point belly:") + " [latejoin_vore ? span_green("Enabled") : span_red("Disabled")]<br>"
	if(latejoin_vore)
		dat += span_bold("Late join spawn auto accept:") + " [no_latejoin_vore_warning ? span_green("Enabled") : span_red("Disabled")]<br>"
	dat += span_bold("Can be late join prey:") + " [latejoin_prey ? span_green("Enabled") : span_red("Disabled")]<br>"
	if(latejoin_prey)
		dat += span_bold("Late join prey auto accept:") + " [no_latejoin_prey_warning ? span_green("Enabled") : span_red("Disabled")]<br>"
	dat += span_bold("Global Vore Privacy is:") + " [eating_privacy_global ? span_green("Subtle") : span_red("Loud")]<br>"
	dat += span_bold("Current active belly:") + " [vore_selected ? vore_selected.get_belly_name(TRUE) : "None"]<br>"
	dat += span_bold("Belly rub target:") + " [belly_rub_target ? belly_rub_target : (vore_selected ? vore_selected.get_belly_name(TRUE) : "None")]<br>"
	var/datum/browser/popup = new(user, "[name]mvp", "Vore Prefs: [src]", 300, 700, src)
	popup.set_content(dat)
	popup.open()

// Full screen belly overlays!
/atom/movable/screen/fullscreen/belly
	icon = 'modular_causticcove/icons/mob/vore_fullscreens/screen_full_vore_list.dmi'

/atom/movable/screen/fullscreen/belly/fixed
	icon = 'modular_causticcove/icons/mob/vore_fullscreens/screen_full_vore.dmi'
	icon_state = ""

/mob/living/proc/vorebelly_printout() //Spew the vorepanel belly messages into chat window for copypasting.
	set name = "X-Print Vorebelly Settings"
	set category = "Preferences.Vore"
	set desc = "Print out your vorebelly messages into chat for copypasting."

	var/result = tgui_alert(src, "Would you rather open the export panel?", "Selected Belly Export", list("Open Panel", "Print to Chat"))
	if(!result)
		return
	if(result == "Open Panel")
		var/mob/living/user = usr
		if(!user)
			to_chat(user,span_notice("Mob undefined: [user]"))
			return FALSE

		var/datum/vore_look/export_panel/exportPanel
		if(!exportPanel)
			exportPanel = new(user)

		if(!exportPanel)
			to_chat(user,span_notice("Export panel undefined: [exportPanel]"))
			return

		exportPanel.ui_interact(user)
	else
		for(var/belly in vore_organs)
			if(isbelly(belly))
				var/obj/belly/B = belly
				to_chat(src, span_info(span_bold("Belly name:") + " [B.name]"))
				to_chat(src, span_info(span_bold("Belly desc:") + " [B.desc]"))
				to_chat(src, span_info(span_bold("Belly absorbed desc:") + " [B.absorbed_desc]"))
				to_chat(src, span_info(span_bold("Vore verb:") + " [B.vore_verb]"))
				to_chat(src, span_info(span_bold("Struggle messages (outside):")))
				for(var/msg in B.struggle_messages_outside)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Struggle messages (inside):")))
				for(var/msg in B.struggle_messages_inside)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Absorbed struggle messages (outside):")))
				for(var/msg in B.absorbed_struggle_messages_outside)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Absorbed struggle messages (inside):")))
				for(var/msg in B.absorbed_struggle_messages_inside)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Escape attempt messages (owner):")))
				for(var/msg in B.escape_attempt_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Escape attempt messages (prey):")))
				for(var/msg in B.escape_attempt_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Escape messages (owner):")))
				for(var/msg in B.escape_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Escape messages (prey):")))
				for(var/msg in B.escape_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Escape messages (outside):")))
				for(var/msg in B.escape_messages_outside)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Escape item messages (owner):")))
				for(var/msg in B.escape_item_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Escape item messages (prey):")))
				for(var/msg in B.escape_item_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Escape item messages (outside):")))
				for(var/msg in B.escape_item_messages_outside)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Escape fail messages (owner):")))
				for(var/msg in B.escape_fail_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Escape fail messages (prey):")))
				for(var/msg in B.escape_fail_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Absorbed escape attempt messages (owner):")))
				for(var/msg in B.escape_attempt_absorbed_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Absorbed escape attempt messages (prey):")))
				for(var/msg in B.escape_attempt_absorbed_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Absorbed escape messages (owner):")))
				for(var/msg in B.escape_absorbed_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Absorbed escape messages (prey):")))
				for(var/msg in B.escape_absorbed_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Absorbed escape messages (outside):")))
				for(var/msg in B.escape_absorbed_messages_outside)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Absorbed escape fail messages (owner):")))
				for(var/msg in B.escape_fail_absorbed_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Absorbed escape fail messages (prey):")))
				for(var/msg in B.escape_fail_absorbed_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Primary transfer messages (owner):")))
				for(var/msg in B.primary_transfer_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Primary transfer messages (prey):")))
				for(var/msg in B.primary_transfer_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Secondary transfer messages (owner):")))
				for(var/msg in B.secondary_transfer_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Secondary transfer messages (prey):")))
				for(var/msg in B.secondary_transfer_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Digest chance messages (owner):")))
				for(var/msg in B.digest_chance_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Digest chance messages  (prey):")))
				for(var/msg in B.digest_chance_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Absorb chance messages (owner):")))
				for(var/msg in B.absorb_chance_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Absorb chance messages  (prey):")))
				for(var/msg in B.absorb_chance_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Digest messages (owner):")))
				for(var/msg in B.digest_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Digest messages (prey):")))
				for(var/msg in B.digest_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Absorb messages (owner):")))
				for(var/msg in B.absorb_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Absorb messages (prey):")))
				for(var/msg in B.absorb_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Unabsorb messages (owner):")))
				for(var/msg in B.unabsorb_messages_owner)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Unabsorb messages (prey):")))
				for(var/msg in B.unabsorb_messages_prey)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Examine messages (when full):")))
				for(var/msg in B.examine_messages)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Examine messages (with absorbed targets):")))
				for(var/msg in B.examine_messages_absorbed)
					to_chat(src, span_info("[msg]"))
				to_chat(src, span_info(span_bold("Emote lists:")))
				for(var/EL in B.emote_lists)
					to_chat(src, span_info(span_bold("[EL]:")))
					for(var/msg in B.emote_lists[EL])
						to_chat(src, span_info("[msg]"))

/**
 * Small helper component to manage the vore panel HUD icon
 */
/datum/component/vore_panel
	var/obj/screen/vore_panel/screen_icon

/datum/component/vore_panel/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()




//
// Returns examine messages for how much reagents are in bellies
//
/mob/living/proc/examine_reagent_bellies()
	if(!show_pudge()) //Some clothing or equipment can hide this. Reagent inflation is not very different in this aspect.
		return ""

	var/message = ""
	for (var/belly in vore_organs)
		var/obj/belly/B = belly

		var/fill_percentage = round((B.custom_max_volume > 0 ? B.reagents.total_volume / B.custom_max_volume : 0) * 100)

		if(B.show_fullness_messages)
			switch(fill_percentage)
				if(0 to 20)
					if(B.liquid_fullness1_messages)
						message += B.get_reagent_examine_msg1()
				if(20 to 40)
					if(B.liquid_fullness2_messages)
						message += B.get_reagent_examine_msg2()
				if(40 to 60)
					if(B.liquid_fullness3_messages)
						message += B.get_reagent_examine_msg3()
				if(60 to 80)
					if(B.liquid_fullness4_messages)
						message += B.get_reagent_examine_msg4()
				if(80 to 100)
					if(B.liquid_fullness5_messages)
						message += B.get_reagent_examine_msg5()

	return message

/mob/living/verb/vore_check_reagents()
	set name = "Check Belly Liquid (Vore)"
	set category = "Vore" //OV EDIT
	set desc = "Check the amount of liquid in your belly."

	var/obj/belly/RTB = tgui_input_list(src, "Choose which vore belly to check", "Select Belly", vore_organs)
	if(!RTB)
		return FALSE

	var/total_report = span_notice("[RTB] has [RTB.reagents.total_volume] units of liquid.")
	if(RTB.reagents.total_volume > 0)
		for(var/datum/reagent/R in RTB.reagents.reagent_list)
			total_report += "<br>"
			total_report += span_info("  -[R.name]: [R.volume]u")
	to_chat(src, total_report)

/mob/living/verb/vore_transfer_reagents()
	set name = "Transfer Liquid (Vore)"
	set category = "Vore" //OV EDIT
	set desc = "Transfer liquid from an organ to another or stomach, or into another person or container."
	set popup_menu = FALSE

	if(!checkClickCooldown() || incapacitated(INCAPACITATION_KNOCKOUT))
		return FALSE

	var/mob/living/user = src

	var/list/transfer_from = get_hearers_in_view(1,user)
	for(var/obj/belly/B in vore_organs)
		for(var/mob/living/L in B.contents)
			transfer_from |= L
	var/mob/living/TG = tgui_input_list(user, "Choose who to transfer from", "Transfer From", transfer_from)
	if(!TG)
		return FALSE
	if(TG.give_reagents == FALSE && user != TG) //User isnt forced to allow giving in prefs if they are the one doing it
		to_chat(user, span_warning("This person's prefs dont allow that!"))
		return FALSE

	if(!LAZYLEN(TG.vore_organs))
		return FALSE

	var/obj/belly/RTB = tgui_input_list(user, "Choose which vore belly to transfer from", "Select Belly", TG.vore_organs)
	if(!RTB)
		return FALSE

	var/transfer_amount = tgui_input_list(user, "How much to transfer?", "Transfer Amount", list(1,5,10,25,50,100,200,500,1000))
	if(!transfer_amount)
		return FALSE

	switch(tgui_input_list(user,"Choose what to transfer to","Select Target", list("Vore belly", "Stomach", "Container", "Floor", "Cancel")))
		if("Cancel")
			return FALSE
		if("Vore belly")
			var/list/transfer_to = get_hearers_in_view(1,user)
			for(var/obj/belly/B in vore_organs)
				for(var/mob/living/L in B.contents)
					transfer_to |= L
			var/mob/living/TR = tgui_input_list(user,"Choose who to transfer to","Select Target", transfer_to)
			if(!TR)  return FALSE

			if(TR == user) //Proceed, we dont need to have prefs enabled for transfer within user
				var/obj/belly/TB = tgui_input_list(user, "Choose which organ to transfer to", "Select Belly", user.vore_organs)
				if(!TB)
					return FALSE
				if(!Adjacent(TR) || !Adjacent(TG))
					return //No long distance transfer
				if(!TB.reagents?.get_free_space())
					to_chat(user, span_notice("[TB] is full!"))
					return FALSE

				if(TG == user)
					user.emote(1, span_notice("[RTB.reagent_transfer_verb] [RTB.reagent_name] from their [RTB.get_belly_name()] into their [TB.get_belly_name()]."))
				else
					user.emote(1, span_notice("[RTB.reagent_transfer_verb] [RTB.reagent_name] from [TG]'s [RTB.get_belly_name()] into their [TB.get_belly_name()]."))
				RTB.reagents.vore_trans_to_mob(TR, transfer_amount, CHEM_VORE, 1, 0, TB)
				if(RTB.count_liquid_for_sprite || TB.count_liquid_for_sprite)
					handle_belly_update()

			else if(TR.receive_reagents == FALSE)
				to_chat(user, span_warning("This person's prefs dont allow that!"))
				return FALSE

			else
				var/obj/belly/TB = tgui_input_list(user, "Choose which organ to transfer to", "Select Belly", TR.vore_organs)
				if(!TB)
					return FALSE
				if(!Adjacent(TR) || !Adjacent(TG))
					return //No long distance transfer
				if(!TB.reagents?.get_free_space())
					to_chat(user, span_notice("[TR]'s [TB.get_belly_name()] is full!"))
					return FALSE

				if(TG == user)
					user.emote(1, span_notice("[RTB.reagent_transfer_verb] [RTB.reagent_name] from their [RTB.get_belly_name()] into [TR]'s [TB.get_belly_name()]."))
				else
					user.emote(1, span_notice("[RTB.reagent_transfer_verb] [RTB.reagent_name] from [TG]s [RTB.get_belly_name()] into [TR]'s [TB.get_belly_name()]."))

				RTB.reagents.vore_trans_to_mob(TR, transfer_amount, CHEM_VORE, 1, 0, TB)
				if(RTB.count_liquid_for_sprite)
					handle_belly_update()
				if(TB.count_liquid_for_sprite)
					TR.handle_belly_update()


		if("Stomach")
			var/list/transfer_to = get_hearers_in_view(1,user)
			for(var/obj/belly/B in vore_organs)
				for(var/mob/living/L in B.contents)
					transfer_to |= L
			var/mob/living/TR = tgui_input_list(user,"Choose who to transfer to","Select Target", transfer_to)
			if(!TR)  return
			if(!Adjacent(TR) || !Adjacent(TG))
				return //No long distance transfer

			if(TR == user) //Proceed, we dont need to have prefs enabled for transfer within user
				if(TG == user)
					user.emote(1, span_notice("[RTB.reagent_transfer_verb] [RTB.reagent_name] from their [RTB.get_belly_name()] into their stomach."))
				else
					user.emote(1, span_notice("[RTB.reagent_transfer_verb] [RTB.reagent_name] from [TG]'s [RTB.get_belly_name()] into their stomach."))
				RTB.reagents.vore_trans_to_mob(TR, transfer_amount, CHEM_INGEST, 1, 0, null)
				if(RTB.count_liquid_for_sprite)
					handle_belly_update()

			else if(TR.receive_reagents == FALSE)
				to_chat(user, span_warning("This person's prefs dont allow that!"))
				return FALSE

			else
				if(TG == user)
					user.emote(1, span_notice("[RTB.reagent_transfer_verb] [RTB.reagent_name] from their [RTB.get_belly_name()] into [TR]'s stomach."))
				else
					user.emote(1, span_notice("[RTB.reagent_transfer_verb] [RTB.reagent_name] from [TG]'s [RTB.get_belly_name()] into [TR]'s stomach."))

				RTB.reagents.vore_trans_to_mob(TR, transfer_amount, CHEM_INGEST, 1, 0, null)
				log_combat(user,TR,"Transfered [RTB.reagent_name] from [TG]'s [RTB] to [TR]'s Stomach")	//Bonus for staff so they can see if people have abused transfer and done pref breaks
				if(RTB.count_liquid_for_sprite)
					handle_belly_update()

		if("Container")
			if(RTB.reagentid == REAGENT_ID_STOMACID)
				return
			var/list/choices = list()
			for(var/obj/item/reagent_containers/rc in view(1,user.loc))
				choices += rc
			var/obj/item/reagent_containers/arc = user.get_active_held_item()
			if(istype(arc,/obj/item/reagent_containers))
				choices += arc
			var/obj/item/reagent_containers/irc = user.get_inactive_held_item()
			if(istype(irc,/obj/item/reagent_containers))
				choices += irc

			var/obj/item/reagent_containers/T = tgui_input_list(user,"Choose what to transfer to","Select Target", choices)
			if(!T)
				return FALSE
			if(!Adjacent(T) || !Adjacent(TG))
				return //No long distance transfer

			if(TG == user)
				user.emote(1, span_notice("[RTB.reagent_transfer_verb] [RTB.reagent_name] from their [RTB.get_belly_name()] into [T]."))
			else
				user.emote(1, span_notice("[RTB.reagent_transfer_verb] [RTB.reagent_name] from [TG]'s [RTB.get_belly_name()] into [T]."))

			RTB.reagents.vore_trans_to_con(T, transfer_amount, 1, 0)
			log_combat(user, T,"Transfered [RTB.reagent_name] from [TG]'s [RTB] to a [T]")	//Bonus for staff so they can see if people have abused transfer and done pref breaks
			if(RTB.count_liquid_for_sprite)
				handle_belly_update()
		if("Floor")
			if(RTB.reagentid == REAGENT_ID_WATER)
				return
			var/amount_removed = RTB.reagents.remove_any(transfer_amount)
			if(RTB.count_liquid_for_sprite)
				handle_belly_update()
			var/puddle_amount = round(amount_removed/5)

			if(puddle_amount == 0)
				to_chat(user,span_notice("[RTB.reagent_name] dripples from the [RTB.get_belly_name()], not enough to form a puddle."))
				return

			if(TG == user)
				user.emote(1, span_notice("spills [RTB.reagent_name] from their [RTB.get_belly_name()] onto the floor!"))
			else
				user.emote(1, span_notice("spills [RTB.reagent_name] from [TG]'s [RTB.get_belly_name()] onto the floor!"))

			/*if (RTB.custom_reagentcolor)
				new /obj/effect/decal/cleanable/blood/reagent(TG.loc, RTB.reagent_name, RTB.custom_reagentcolor, RTB.reagentid, puddle_amount, user.ckey, TG.ckey)
			else
				new /obj/effect/decal/cleanable/blood/reagent(TG.loc, RTB.reagent_name, RTB.reagentcolor, RTB.reagentid, puddle_amount, user.ckey, TG.ckey)*/

			var/soundfile
			if(!RTB.fancy_vore)
				soundfile = GLOB.classic_release_sounds[RTB.release_sound]
			else
				soundfile = GLOB.fancy_release_sounds[RTB.release_sound]
			if(soundfile)
				playsound(src, soundfile, vol = 100, vary = 1, falloff = VORE_SOUND_FALLOFF, pref_toggle = "eating_noises")

/mob/living/proc/vore_bellyrub(var/mob/living/T in view(1,src))

	if(!T)
		return FALSE

	if(!(T in view(1,src)))
		return FALSE
	if(T.vore_selected)
		var/obj/belly/B = T.vore_selected
		if(istype(B))
			if(T == src)
				emote(1, "rubs their [belly_rub_target ? belly_rub_target : B.get_belly_name()].")
			else
				emote(1, "gives some rubs over [T]'s [T.belly_rub_target ? T.belly_rub_target : B.get_belly_name()].")
			B.quick_cycle()
			return TRUE
	to_chat(src, span_warning("There is no suitable belly for rubs."))
	return FALSE

/mob/living/proc/mute_entry()
	set name = "Mute Vorgan Entrance"
	set category = "Preferences.Vore"
	set desc = "Mute the chatlog messages when something enters a vore belly."
	mute_entry = !mute_entry
	to_chat(src, span_warning("Entrance logs [mute_entry ? "disabled" : "enabled"]."))

/mob/living/proc/restrict_trasheater()
	set name = "Restrict Trash Eater"
	set category = "Vore" //OV EDIT
	set desc = "Toggle Trash Eater restriction level."
	adminbus_trash = !adminbus_trash
	to_chat(src, span_warning("Trash Eater restriction level set to [adminbus_trash ? "everything not blacklisted" : "only whitelisted items"]."))

/mob/living/proc/liquidbelly_visuals()
	set name = "Toggle Liquidbelly Visuals"
	set category = "Preferences.Vore"
	set desc = "Toggle liquidbelly fullscreen visual effect."
	liquidbelly_visuals = !liquidbelly_visuals
	to_chat(src, span_warning("Liquidbelly overlays [liquidbelly_visuals ? "enabled" : "disabled"]."))

/mob/living/proc/fix_vore_effects()
	set name = "Fix Vore Effects"
	set category = "OOC.Debug"
	set desc = "Fix certain vore effects lingering after you've exited a belly."

	if(!isbelly(src.loc))
		if(alert(src, "Only use this verb if you are affected by certain vore effects outside of a belly, such as muffling or a stuck belly fullscreen.", "Clear Vore Effects", "Continue", "Nevermind") != "Continue")
			return

		absorbed = FALSE
		muffled = FALSE
		clear_fullscreen("belly")
		clear_fullscreen(ATOM_BELLY_FULLSCREEN)
		stop_sound_channel(CHANNEL_PREYLOOP)

/mob/living/verb/vore_check_nutrition()
	set name = "Check Nutrition"
	set category = "Vore" //OV EDIT
	set desc = "Check your current nutrition level."
	to_chat(src, span_notice("Current nutrition level: [nutrition]."))

// This proc will either return the first belly the mob is in or return null if they're not in one
/mob/living/proc/surrounding_belly()
	var/atom/curloc = src.loc
	while(curloc && !isbelly(curloc))
		if(istype(curloc, /turf)) break
		if(!curloc.loc || curloc == curloc.loc) break
		curloc = curloc.loc
	if(isbelly(curloc)) return curloc

/mob/living/verb/toggle_afk()
	set name = "Toggle AFK"
	set category = "IC"
	set desc = "Mark yourself as Away From Keyboard, or clear that status!"
	if(away_from_keyboard)
		//remove_status_indicator("afk")
		to_chat(src, span_notice("You are no longer marked as AFK."))
		away_from_keyboard = FALSE
		manual_afk = FALSE
	else
		//add_status_indicator("afk")
		to_chat(src, span_notice("You are now marked as AFK."))
		away_from_keyboard = TRUE
		manual_afk = TRUE

/mob/living/proc/absorb_langs()		//This should be called on the predator in the exchange
	if(!mind || !mind.language_holder)
		return

	var/list/langlist = list()

	mind.language_holder.languages -= temp_languages
	LAZYCLEARLIST(src.temp_languages)
	src.temp_languages = list()
	for(var/b in vore_organs)
		for(var/mob/living/L in b)
			if(isliving(L))
				if(L.ckey)
					langlist |= L.mind.language_holder.languages
	if(langlist.len)
		langlist -= mind.language_holder.languages
		/*for(var/datum/language/L in langlist)
			if(L.flags & HIVEMIND)
				add_verb(src, /mob/proc/adjust_hive_range)*/
		temp_languages |= langlist
		mind.language_holder.languages |= langlist

/mob/living/proc/on_throw_vore_special(var/pred = TRUE, var/mob/living/target)
	return
