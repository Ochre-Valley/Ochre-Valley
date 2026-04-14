//Originally created by VerySoft on VoreStation

/obj/item/capture_crystal
	name = "capture crystal"
	desc = "A silent, unassuming crystal in what appears to be some kind of steel housing."
	icon = 'modular_ochrevalley/icons/roguetown/items/capture_crystal_vr.dmi'
	icon_state = "inactive"
	drop_sound = 'modular_ochrevalley/sounds/capture_crystal/drop_ring.ogg'
	pickup_sound = 'modular_ochrevalley/sounds/capture_crystal/pickup_ring.ogg'
	throwforce = 0
	force = 0
	actions_types = list(/datum/action/item_action/command)
	w_class = WEIGHT_CLASS_TINY

	var/active = FALSE					//Is it set up?
	var/mob/living/owner				//Reference to the owner
	var/mob/living/bound_mob			//Reference to our bound mob
	var/spawn_mob_type					//The kind of mob an inactive crystal will try to spawn when activated
	var/activate_cooldown = 30 SECONDS	//How long do we wait between unleashing and recalling
	var/last_activate					//Automatically set by things that try to move the bound mob or capture things
	var/empty_icon = "empty"
	var/full_icon = "full"
	var/spawn_mob_name = "A mob"
	var/capture_chance_modifier = 1		//So we can have special subtypes with different capture rates!
	var/loadout = FALSE
	sellprice = 100

/obj/item/capture_crystal/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/capture_crystal/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Touch this to a player to give them the option to be capture, or throw it at a non-player mob to attempt to capture them.")
	. += span_info("Captured creatures can be released by using the crystal inhand or tossing it on the ground, they will be set to an allied faction.")
	. += span_info("Released creatures can be recalled to the crystal by using it inhand. There is a 30 second cooldown between releasing, capturing and recalling.")
	. += span_info("Use middle mouse on the crystal inhand to destroy it, releasing any creatures inside from your control.")
	. += span_info("Whilst holding the crystal, you can send commands using a new spell to player controlled mobs.")


//Let's make sure we clean up our references and things if the crystal goes away (such as when it's digested)
/obj/item/capture_crystal/Destroy()
	if(bound_mob)
		if(bound_mob in contents)
			unleash()
		to_chat(bound_mob, span_notice("You feel like yourself again. You are no longer under the influence of \the [src]'s command."))
		UnregisterSignal(bound_mob, COMSIG_QDELETING)
		bound_mob.capture_caught = FALSE
		bound_mob = null
	if(owner)
		UnregisterSignal(owner, COMSIG_QDELETING)
		owner = null
	return ..()

/obj/item/capture_crystal/examine(user)
	. = ..()
	if(user == owner && bound_mob)
		. += span_notice("[bound_mob]'s crystal")
		if(isanimal(bound_mob))
			. += span_notice("[bound_mob.health / bound_mob.getMaxHealth() * 100]%")
		if(ishuman(bound_mob))
			var/mob/living/carbon/human/bound_human = bound_mob
			if(bound_human.ooc_notes)
				. += span_notice("OOC Notes:") + " <a href='byond://?src=\ref[bound_mob];ooc_notes=1'>\[View\]</a> - <a href='byond://?src=\ref[src];print_ooc_notes_chat=1'>\[Print\]</a>"
			. += span_notice("<a href='byond://?src=\ref[bound_mob];vore_prefs=1'>\[Mechanical Vore Preferences\]</a>")

//Command! This lets the owner toggle hostile on AI controlled mobs, or send a silent command message to your bound mob, wherever they may be.
/obj/item/capture_crystal/ui_action_click(mob/user, actiontype)
	if(!ismob(loc))
		return
	var/mob/living/M = src.loc
	if(M != owner)
		to_chat(M, span_notice("\The [src] emits an unpleasant tone... It does not respond to your command."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
	else if(!bound_mob)
		to_chat(M, span_notice("\The [src] emits an unpleasant tone... There is nothing to command."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
	else if(bound_mob.client)
		var/transmit_msg = tgui_input_text(user, "What is your command?", "Command")
		if(length(transmit_msg) >= MAX_MESSAGE_LEN)
			to_chat(M, span_danger("Your message was TOO LONG!:[transmit_msg]"))
			return
		transmit_msg = sanitize(transmit_msg)
		if(isnull(transmit_msg))
			to_chat(M, span_notice("You decided against it."))
			return
		to_chat(bound_mob, span_notice("\The [owner] commands, '[transmit_msg]'"))
		to_chat(M, span_notice("Your command has been transmitted, '[transmit_msg]'"))
		log_admin("[key_name_admin(M)] sent the command, '[transmit_msg]' to [bound_mob].")
	else
		to_chat(M, span_notice("\The [src] emits an unpleasant tone... \The [bound_mob] is unresponsive."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)

//Lets the owner get AI controlled bound mobs to follow them, or tells player controlled mobs to follow them.
/*
/obj/item/capture_crystal/verb/follow_owner()
	set name = "Toggle Follow"
	set category = "Object"
	set src in usr
	if(!ismob(loc))
		return
	var/mob/living/M = src.loc
	if(M != owner)
		to_chat(M, span_notice("\The [src] emits an unpleasant tone... It does not respond to your command."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
	else if(bound_mob.stat != CONSCIOUS)
		to_chat(M, span_notice("\The [src] emits an unpleasant tone... \The [bound_mob] is not able to hear your command."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
	else if(bound_mob.client)
		to_chat(bound_mob, span_notice("\The [owner] wishes for you to follow them."))
	/*
	else if(bound_mob in contents)
		if(!bound_mob.ai_controller)
			to_chat(M, span_notice("\The [src] emits an unpleasant tone... \The [bound_mob] is not able to follow your command."))
			playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
			return
		var/datum/ai_controller/AI = bound_mob.ai_controller
		if(AI.leader)
			to_chat(M, span_notice("\The [src] chimes~ \The [bound_mob] stopped following [AI.leader]."))
			AI.lose_follow(AI.leader)
		else
			AI.set_follow(M)
			to_chat(M, span_notice("\The [src] chimes~ \The [bound_mob] started following following [AI.leader]."))
	else if(!(bound_mob in view(M)))
		to_chat(M, span_notice("\The [src] emits an unpleasant tone... \The [bound_mob] is not able to hear your command."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
		if(!bound_mob.ai_controller)
			to_chat(M, span_notice("\The [src] emits an unpleasant tone... \The [bound_mob] is not able to follow your command."))
			playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
			return
		var/datum/ai_holder/AI = bound_mob.ai_controller
		if(AI.leader)
			to_chat(M, span_notice("\The [src] chimes~ \The [bound_mob] stopped following [AI.leader]."))
			AI.lose_follow(AI.leader)
		else
			AI.set_follow(M)
			to_chat(M, span_notice("\The [src] chimes~ \The [bound_mob] started following following [AI.leader]."))
	*/
*/

//Don't really want people 'haha funny' capturing and releasing one another willy nilly. So! If you wanna release someone, you gotta destroy the thingy.
//(Which is consistent with how it works with digestion anyway.)
/obj/item/capture_crystal/proc/destroy_crystal()
	//set name = "Destroy Crystal"
	//set category = "Object"
	//set src in usr
	if(!ismob(loc))
		return
	var/mob/living/M = src.loc
	if(M != owner)
		to_chat(M, span_notice("\The [src] is too hard for you to break."))
	else
		M.visible_message("\The [M] crushes \the [src] into dust...", "\The [src] cracks and disintegrates in your hand.")
		qdel(src)

/obj/item/capture_crystal/MiddleClick(mob/user, params)
	. = ..()
	if(user == owner)
		var/confirm = tgui_alert(user, "Are you sure you wish to destroy the crystal?", "Destroy Crystal", list("Destroy", "Cancel"))
		if(confirm != "Destroy")
			return
		destroy_crystal()


//If you catch something/someone and want to give it to someone else though, that's fine.
/obj/item/capture_crystal/proc/release_ownership()
	//set name = "Release Ownership"
	//set category = "Object"
	//set src in usr
	if(!ismob(loc))
		return
	var/mob/living/M = src.loc
	if(M != owner)
		to_chat(M, span_notice("\The [src] emits an unpleasant tone... It does not respond to your command."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
	else
		M.visible_message("\The [src] flickers in \the [M]'s hand and emits a little tone.", "\The [src] flickers in your hand and emits a little tone.")
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-out.ogg', 75, 1, -1)
		UnregisterSignal(owner, COMSIG_QDELETING)
		owner = null

/obj/item/capture_crystal/attack_right(mob/user)
	. = ..()
	if(user == owner)
		var/confirm = tgui_alert(user, "Are you sure you wish to release ownership of the crystal?", "Destroy Crystal", list("Release", "Cancel"))
		if(confirm != "Release")
			return
		release_ownership()

//Let's make inviting ghosts be an option you can do instead of an automatic thing!
/*
/obj/item/capture_crystal/verb/invite_ghost()
	set name = "Enhance (Toggle Ghost Join)"
	set category = "Object"
	set src in usr
	if(!ismob(loc))
		return
	var/mob/living/U = src.loc
	if(!bound_mob)
		to_chat(U, span_notice("\The [src] emits an unpleasant tone... There is nothing to enhance."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
		return
	else if(U != owner)
		to_chat(U, span_notice("\The [src] emits an unpleasant tone... It does not respond to your command."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
		return
	else if(bound_mob.client || !isanimal(bound_mob))
		to_chat(U, span_notice("\The [src] emits an unpleasant tone... \The [bound_mob] is not eligable for enhancement."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-problem.ogg', 75, 1, -1)
		return		//Need to type cast the mob so it can detect ghostjoin
	/*
	var/mob/living/simple_animal/M = bound_mob
	if(M.ghostjoin)
		M.ghostjoin = FALSE
		to_chat(U, span_notice("\The [bound_mob] is no longer eligable to be joined by ghosts."))
	else if(tgui_alert(U, "Do you want to offer your [bound_mob] up to ghosts to play as? There is no way undo this once a ghost takes over.", "Invite ghosts?",list("No","Yes")) == "Yes")
		M.ghostjoin = TRUE
		to_chat(U, span_notice("\The [bound_mob] is now eligable to be joined by ghosts. It will need to be out of the crystal to be able to be joined."))
	else
		to_chat(U, span_notice("You decided against it."))
	*/
*/

/obj/item/capture_crystal/update_icon()
	. = ..()
	if(spawn_mob_type)
		icon_state = full_icon
	else if(!bound_mob)
		icon_state = "inactive"
	else if(bound_mob in contents)
		icon_state = full_icon
	else
		icon_state = empty_icon
	if(!cooldown_check())
		icon_state = "[icon_state]-busy"
		spawn(activate_cooldown)		//If it's busy then we want to wait a bit to fix the sprite after the cooldown is done.
		update_icon()

/obj/item/capture_crystal/proc/cooldown_check()
	if(world.time < last_activate + activate_cooldown)
		return FALSE
	else return TRUE

/obj/item/capture_crystal/attack(mob/living/M, mob/living/user)
	if(bound_mob)
		if(!bound_mob.devourable)	//Don't eat if prefs are bad
			return
		if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)	//Click while targetting the mouth and you eat/feed the stored mob to whoever you clicked on
			if(bound_mob in contents)
				user.visible_message("\The [user] moves \the [src] to [M]'s [M.vore_selected]...")
				M.perform_the_nom(M, bound_mob, M, M.vore_selected)
	else if(M == user)		//You don't have a mob, you ponder the orb instead of trying to capture yourself
		user.visible_message("\The [user] ponders \the [src]...", "You ponder \the [src]...")
	else if (cooldown_check())	//Try to capture someone without throwing
		user.visible_message("\The [user] taps \the [M] with \the [src].")
		activate(user, M)
	else
		to_chat(user, span_notice("\The [src] emits an unpleasant tone... It is not ready yet."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)

//Tries to unleash or recall your stored mob
/obj/item/capture_crystal/attack_self(mob/living/user)
	. = ..(user)
	if(.)
		return TRUE
	if(loadout && !bound_mob)
		to_chat(user, span_notice("\The [src] emits an unpleasant tone... It is not ready yet."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-problem.ogg', 75, 1, -1)
		return
	if(bound_mob && !owner)
		if(bound_mob == user)
			to_chat(user, span_notice("\The [src] emits an unpleasant tone... It does not activate for you."))
			playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
			return
		if(tgui_alert(user, "\The [src] hasn't got an owner. It has \the [bound_mob] registered to it. Would you like to claim this as yours?", "Claim ownership", list("No","Yes")) == "Yes")
			owner = user
	if(!cooldown_check())
		to_chat(user, span_notice("\The [src] emits an unpleasant tone... It is not ready yet."))
		if(bound_mob)
			playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-problem.ogg', 75, 1, -1)
		else
			playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
	else if(user == bound_mob)	//You can't recall yourself
		to_chat(user, span_notice("\The [src] emits an unpleasant tone... It does not activate for you."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
	else if(!active)
		activate(user)
	else
		determine_action(user)

//Make it so the crystal knows if its mob references get deleted to make sure things get cleaned up
/obj/item/capture_crystal/proc/knowyoursignals(mob/living/M, mob/living/U)
	RegisterSignal(M, COMSIG_QDELETING, PROC_REF(mob_was_deleted), TRUE)
	RegisterSignal(U, COMSIG_QDELETING, PROC_REF(owner_was_deleted), TRUE)

//The basic capture command does most of the registration work.
/obj/item/capture_crystal/proc/capture(mob/living/M, mob/living/U)
	if(!M.capture_crystal || M.capture_caught)
		to_chat(U, span_warning("This creature is not suitable for capture."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
		return
	knowyoursignals(M, U)
	owner = U
	//if(isanimal(M))
		//var/mob/living/simple_animal/S = M
		//S.revivedby = U.name
	if(!bound_mob)
		bound_mob = M
		bound_mob.capture_caught = TRUE
		bound_mob.faction = U.faction
		//persist_storable = FALSE
	desc = "A glowing crystal in what appears to be some kind of steel housing."

//Determines the capture chance! So you can't capture AI mobs if they're perfectly healthy and all that
/obj/item/capture_crystal/proc/capture_chance(mob/living/M, user)
	if(capture_chance_modifier >= 100)		//Master crystal always work
		return 100
	var/capture_chance = ((1 - (M.health / M.getMaxHealth())) * 100)	//Inverted health percent! 100% = 0%
	//So I don't know how this works but here's a kind of explanation
	//Basic chance + ((Mob's max health - minimum calculated health) / (Max allowed health - Min allowed health)*(Chance at Max allowed health - Chance at minimum allowed health)
	capture_chance += 35 + ((M.getMaxHealth() - 5)/ (300-5)*(-100 - 35))
	//Basically! Mobs over 300 max health will be unable to be caught without using status effects.
	//Thanks Aronai!
	var/effect_count = 0	//This will give you a smol chance to capture if you have applied status effects, even if the chance would ordinarily be <0
	if(M.stat == UNCONSCIOUS)
		capture_chance += 0.1
		effect_count += 1
	else if(M.stat == CONSCIOUS)
		capture_chance *= 0.9
	else
		capture_chance = 0
	/*
	if(M.weakened)			//Haha you fall down
		capture_chance += 0.1
		effect_count += 1
	*/
	if(M.IsStun())			//What's the matter???
		capture_chance += 0.1
		effect_count += 1
	if(M.on_fire)			//AAAAAAAA
		capture_chance += 0.1
		effect_count += 1
	if(M.IsParalyzed())			//Oh noooo
		capture_chance += 0.1
		effect_count += 1
	/*
	if(M.ai_holder.stance == STANCE_IDLE)	//SNEAK ATTACK???
		capture_chance += 0.1
		effect_count += 1
	*/

	capture_chance = (capture_chance/M.capture_difficulty)

	capture_chance *= capture_chance_modifier

	if(capture_chance <= 0)
		capture_chance = 0 + effect_count
		if(capture_chance <= 0)
			capture_chance = 0
			to_chat(user, span_notice("There's no chance... It needs to be weaker."))

	last_activate = world.time
	log_admin("[user] threw a capture crystal at [M] and got [capture_chance]% chance to catch.")
	return capture_chance

//Handles checking relevent bans, preferences, and asking the player if they want to be caught
/obj/item/capture_crystal/proc/capture_player(mob/living/M, mob/living/U)
	/*
	if(jobban_isbanned(M, JOB_GHOSTROLES))
		to_chat(U, span_warning("This creature is not suitable for capture."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
	*/
	if(!M.capture_crystal || M.capture_caught)
		to_chat(U, span_warning("This creature is not suitable for capture."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
	else if(tgui_alert(M, "Would you like to be caught by in [src] by [U]? You will be bound to their will.", "Become Caught",list("No","Yes")) == "Yes")
		if(tgui_alert(M, "Are you really sure? The only way to undo this is to OOC escape while you're in the crystal.", "Become Caught", list("No","Yes")) == "Yes")
			log_admin("[key_name(M)] has agreed to become caught by [key_name(U)].")
			capture(M, U)
			recall(U)
			return
	to_chat(U, span_warning("This creature is too strong willed to be captured."))
	playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)

//The clean up procs!
/obj/item/capture_crystal/proc/mob_was_deleted()
	SIGNAL_HANDLER
	UnregisterSignal(bound_mob, COMSIG_QDELETING)
	UnregisterSignal(owner, COMSIG_QDELETING)
	bound_mob.capture_caught = FALSE
	bound_mob = null
	owner = null
	active = FALSE
	//persist_storable = TRUE
	update_icon()

/obj/item/capture_crystal/proc/owner_was_deleted()
	SIGNAL_HANDLER
	UnregisterSignal(owner, COMSIG_QDELETING)
	owner = null
	active = FALSE
	update_icon()

//If the crystal hasn't been set up, it does this
/obj/item/capture_crystal/proc/activate(mob/living/user, target)
	if(!cooldown_check())		//Are we ready to do things yet?
		to_chat(user, span_notice("\The [src] clicks unsatisfyingly... It is not ready yet."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
		return
	if(spawn_mob_type && !bound_mob)			//We don't already have a mob, but we know what kind of mob we want
		bound_mob = new spawn_mob_type(src)		//Well let's spawn it then!
		bound_mob.faction = user.faction
		spawn_mob_type = null
		capture(bound_mob, user)
	if(bound_mob)								//We have a mob! Let's finish setting up.
		user.visible_message("\The [src] clicks, and then emits a small chime.", "\The [src] grows warm in your hand, something inside is awake.")
		active = TRUE
		if(!owner)								//Do we have an owner? It's pretty unlikely that this would ever happen! But it happens, let's claim the crystal.
			owner = user
			//if(isanimal(bound_mob))
				//var/mob/living/simple_mob/S = bound_mob
				//S.revivedby = user.name
		determine_action(user, target)
		return
	else if(isliving(target))						//So we don't have a mob, let's try to claim one! Is the target a mob?
		var/mob/living/M = target
		last_activate = world.time
		if(M.capture_caught)					//Can't capture things that were already caught.
			playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
			to_chat(user, span_notice("\The [src] clicks unsatisfyingly... \The [M] is already under someone else's control."))
			return
		else if(M.stat == DEAD)						//Is it dead? We can't influence dead things.
			playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
			to_chat(user, span_notice("\The [src] clicks unsatisfyingly... \The [M] is not in a state to be captured."))
			return
		else if(M.client)							//Is it player controlled?
			capture_player(M, user)				//We have to do things a little differently if so.
			return
		else if(!isanimal(M))						//So it's not player controlled, but it's also not a simplemob?
			to_chat(user, span_warning("This creature is not suitable for capture."))
			playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
			return
		var/mob/living/simple_animal/S = M
		if(!S.ai_controller)						//We don't really want to capture simplemobs that don't have an AI
			to_chat(user, span_warning("This creature is not suitable for capture."))
			playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
		else if(prob(capture_chance(S, user)))				//OKAY! So we have an NPC simplemob with an AI, let's calculate its capture chance! It varies based on the mob's condition.
			capture(S, user)					//We did it! Woo! We capture it!
			user.visible_message("\The [src] clicks, and then emits a small chime.", "Alright! \The [S] was caught!")
			recall(user)
			active = TRUE
		else									//Shoot, it didn't work and now it's mad!!!
			//S.ai_controller.GiveTarget(user)
			//user.visible_message("\The [src] bonks into \the [S], angering it!")
			playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
			to_chat(user, span_notice("\The [src] clicks unsatisfyingly."))
		update_icon()
		return
	//The target is not a mob, so let's not do anything.
	playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
	to_chat(user, span_notice("\The [src] clicks unsatisfyingly."))

//We're using the crystal, but what will it do?
/obj/item/capture_crystal/proc/determine_action(mob/living/U, T)
	if(!cooldown_check())	//Are we ready yet?
		to_chat(U, span_notice("\The [src] clicks unsatisfyingly... It is not ready yet."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
		return				//No
	if(bound_mob in contents)	//Do we have our mob?
		if(T)
			unleash(U, T)		//Yes, let's let it out!
		else
			unleash(U)
	else if (bound_mob)			//Do we HAVE a mob?
		recall(U)				//Yes, let's try to put it back in the crystal
	else						//No we don't have a mob, let's reset the crystal.
		to_chat(U, span_notice("\The [src] clicks unsatisfyingly."))
		active = FALSE
		update_icon()
		owner = null
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)

//Let's try to call our mob back!
/obj/item/capture_crystal/proc/recall(mob/living/user)
	if(bound_mob in view(user))		//We can only recall it if we can see it
		var/turf/turfmemory = get_turf(bound_mob)
		/*
		if(isanimal(bound_mob) && bound_mob.ai_holder)
			var/mob/living/simple_mob/M = bound_mob
			M.ai_holder.go_sleep()	//AI doesn't need to think when it's in the crystal
		*/
		bound_mob.forceMove(src)
		last_activate = world.time
		bound_mob.visible_message("\The [user]'s [src] flashes, disappearing [bound_mob] in an instant!!!", "\The [src] pulls you back into confinement in a flash of light!!!")
		animate_action(turfmemory)
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-in.ogg', 75, 1, -1)
		update_icon()
	else
		to_chat(user, span_notice("\The [src] clicks and emits a small, unpleasant tone. \The [bound_mob] cannot be recalled."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)

//Let's let our mob out!
/obj/item/capture_crystal/proc/unleash(mob/living/user, atom/target)
	if(!user && !target)			//We got thrown but we're not sure who did it, let's go to where the crystal is
		var/drop_loc = get_turf(src)
		if (drop_loc)
			bound_mob.forceMove(drop_loc)
		return
	if(!target)						//We know who wants to let us out, but they didn't say where, so let's drop us on them
		bound_mob.forceMove(user.drop_location())
	else							//We got thrown! Let's go where we got thrown
		bound_mob.forceMove(target.drop_location())
	last_activate = world.time
	/*
	if(isanimal(bound_mob))
		var/mob/living/simple_mob/M = bound_mob
		M.ai_holder.go_wake()		//Okay it's time to do work, let's wake up!
	*/
	bound_mob.faction = owner.faction	//Let's make sure we aren't hostile to our owner or their friends
	bound_mob.visible_message("\The [user]'s [src] flashes, \the [bound_mob] appears in an instant!!!", "The world around you rematerialize as you are unleashed from the [src] next to \the [user]. You feel a strong compulsion to enact \the [owner]'s will.")
	animate_action(get_turf(bound_mob))
	playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-out.ogg', 75, 1, -1)
	update_icon()

//Let's make a flashy sparkle when someone appears or disappears!
/obj/item/capture_crystal/proc/animate_action(atom/thing)
	var/image/coolanimation = image('modular_ochrevalley/icons/roguetown/items/capture_crystal_vr.dmi', null, "animation")
	coolanimation.plane = GAME_PLANE_HIGHEST
	thing.overlays += coolanimation
	addtimer(CALLBACK(src, PROC_REF(animate_action_finished),thing,coolanimation), 1.1 SECONDS, TIMER_DELETE_ME)

/obj/item/capture_crystal/proc/animate_action_finished(atom/thing,var/image/coolanimation)
	SHOULD_NOT_OVERRIDE(TRUE)
	PROTECTED_PROC(TRUE)
	thing.overlays -= coolanimation
	qdel(coolanimation)

//IF the crystal somehow ends up in a tummy and digesting with a bound mob who doesn't want to be eaten, let's move them to the ground
/obj/item/capture_crystal/digest_act(var/atom/movable/item_storage = null)
	if(bound_mob)
		if((bound_mob in contents) && !bound_mob.devourable)
			bound_mob.forceMove(src.drop_location())
	return ..()

//We got thrown! Let's figure out what to do
/obj/item/capture_crystal/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, datum/callback/callback)
	. = ..()
	if(target == bound_mob && thrower != bound_mob)		//We got thrown at our bound mob (and weren't thrown by the bound mob) let's ignore the cooldown and just put them back in
		recall(thrower)
	else if(!cooldown_check())		//OTHERWISE let's obey the cooldown
		to_chat(thrower, span_notice("\The [src] emits an soft tone... It is not ready yet."))
		if(bound_mob)
			playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-problem.ogg', 75, 1, -1)
		else
			playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
	else if(!active)					//The ball isn't set up, let's try to set it up.
		if(isliving(target))	//We're hitting a mob, let's try to capture it.
			addtimer(CALLBACK(src, PROC_REF(activate), thrower, target), 10, TIMER_DELETE_ME)
			return
		addtimer(CALLBACK(src, PROC_REF(activate), thrower, src), 10, TIMER_DELETE_ME)
	else if(!bound_mob)				//We hit something else, and we don't have a mob, so we can't really do anything!
		to_chat(thrower, span_notice("\The [src] clicks unpleasantly..."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)
	else if(bound_mob in contents)	//We have our mob! Let's try to let it out.
		addtimer(CALLBACK(src, PROC_REF(unleash), thrower, src), 10, TIMER_DELETE_ME)
	else						//Our mob isn't here, we can't do anything.
		to_chat(thrower, span_notice("\The [src] clicks unpleasantly..."))
		playsound(src, 'modular_ochrevalley/sounds/capture_crystal/capture-crystal-negative.ogg', 75, 1, -1)

/obj/item/capture_crystal/basic

/obj/item/capture_crystal/great
	name = "great capture crystal"
	capture_chance_modifier = 1.5
	sellprice = 150

/obj/item/capture_crystal/ultra
	name = "ultra capture crystal"
	capture_chance_modifier = 2
	sellprice = 200

/obj/item/capture_crystal/master
	name = "master capture crystal"
	capture_chance_modifier = 100
	sellprice = 500

/mob/living
	var/capture_crystal = TRUE		//If TRUE, the mob is capturable. Otherwise it isn't.
	var/capture_caught = FALSE		//If TRUE, the mob has already been caught, and so cannot be caught again.
	var/capture_difficulty = 1		//Difficulty to capture mobs in capture crystals

/datum/action/item_action/command
	name = "Command"

//Crafting!

/datum/crafting_recipe/roguetown/arcana/capture_crystal_basic
	name = "capture crystal"
	result = /obj/item/capture_crystal/basic
	reqs = list(/obj/item/ingot/iron = 1,
				/obj/item/roguegem/amethyst = 1,
				/obj/item/magic/melded/t1 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/capture_crystal_great
	name = "capture crystal (great)"
	result = /obj/item/capture_crystal/great
	reqs = list(/obj/item/ingot/iron = 1,
				/obj/item/roguegem/yellow = 1,
				/obj/item/magic/melded/t2 = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/capture_crystal_ultra
	name = "capture crystal (ultra)"
	result = /obj/item/capture_crystal/ultra
	reqs = list(/obj/item/ingot/iron = 1,
				/obj/item/roguegem/green = 1,
				/obj/item/magic/melded/t3 = 1)
	craftdiff = 4
