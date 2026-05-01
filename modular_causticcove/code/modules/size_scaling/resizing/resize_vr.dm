//Size change stripping options
#define SIZESTRIP_NONE 				0							//Default, no dropping items on size change
#define SIZESTRIP_ITEMS				1							//Drop all inventory slots on size change
#define SIZESTRIP_ALL 				2							//Drop all inventory and remove underwear on size change

// Adding needed defines to /mob/living
// Note: Polaris had this on /mob/living/carbon/human We need it higher up for animals and stuff.
/mob
	var/step_mechanics_pref = TRUE		// Allow participation in macro-micro step mechanics
	var/pickup_pref = TRUE				// Allow participation in macro-micro pickup mechanics
	var/center_offset = 0//.5				// Center offset for uneven scaling symmetry.
	var/offset_override = FALSE			// Pref toggle for center offset.

/mob/living
	var/holder_default
	var/pickup_active = TRUE			// Toggle whether your help intent picks up micros or pets them

// Define holder_type on types we want to be scoop-able
/mob/living/carbon/human
	holder_type = /obj/item/holder/micro

// Let the robots have some fun too
/*/mob/living/silicon/robot //Caustic - We don't really have silicons? Closest is constructs so...
	holder_type = /obj/item/holder/micro*/

// The reverse lookup of player_sizes_list, number to name.
/proc/player_size_name(var/size_multiplier)
	// (This assumes list is sorted big->small)
	for(var/N in GLOB.player_sizes_list)
		. = N // So we return the smallest if we get to the end
		if(size_multiplier >= GLOB.player_sizes_list[N])
			return N

/**
 * Scale up the size of a mob's icon by the size_multiplier.
 * NOTE: mob/living/carbon/human/update_icons() has a more complicated system and
 * 	is already applying this transform.   BUT, it does not call ..()
 *	as long as that is true, we should be fine.  If that changes we need to
 *	re-evaluate.
 */
/mob/living/update_icons()
	. = ..()
	ASSERT(!ishuman(src))
	var/cent_offset = center_offset
	if(fuzzy || offset_override || dir == EAST || dir == WEST)
		cent_offset = 0
	var/matrix/M = matrix()
	M.Scale(size_multiplier, size_multiplier)
	M.Translate(cent_offset * size_multiplier, (vis_height/2)*(size_multiplier-1))
	transform = M

/**
 * Get the effective size of a mob.
 * Currently this is based only on size_multiplier for micro/macro stuff,
 * but in the future we may also incorporate the "mob_size", so that
 * a macro mouse is still only effectively "normal" or a micro dragon is still large etc.
 */
/mob/proc/get_effective_size(var/micro = FALSE)
	return 100000 //Whatever it is, it's too big to pick up, or it's a ghost, or something.

/mob/living/get_effective_size(var/micro = FALSE)
	return size_multiplier

//This whole thing appears to be for differenciating Macro-Micro stuff based on default Species Size? This kinda gets wildly confusing if we did all that... Not even sure if we want to bother?
/*/mob/living/carbon/human/get_effective_size(var/micro = FALSE)		// Set micro to TRUE for interactions where you're small, to FALSE for ones where you're large.
	var/effective_size = size_multiplier
	if(micro)
		effective_size += species.micro_size_mod
	else
		effective_size += species.macro_size_mod
	return size_multiplier //effective_size
*/
/atom/movable/proc/size_range_check(size_select) //both objects and mobs needs to have that -- Caustic: This is what allows people to bypass the size limits when in specific areas, IE the Dorms in Chomp/Virgo. Commented out for now, since we don't have area flags for this. Lets get it running first.
												 // -- All the extremes bells and whistles can come after
	//var/area/A = get_area(src) //Get the atom's area to check for size limit.
	size_select = size_select / 100
	if(/*(!A?.flag_check(AREA_ALLOW_LARGE_SIZE) && */(size_select > RESIZE_MAXIMUM || size_select < RESIZE_MINIMUM)/*) || (size_select > RESIZE_MAXIMUM_DORMS || size_select < RESIZE_MINIMUM_DORMS)*/)
		return FALSE
	return TRUE

/*/atom/movable/proc/has_large_resize_bounds()
	var/area/A = get_area(src) //Get the atom's area to check for size limit.
	return A ? A.flag_check(AREA_ALLOW_LARGE_SIZE) : FALSE

/proc/is_extreme_size(size)
	return (size < RESIZE_MINIMUM || size > RESIZE_MAXIMUM)*/


/**
 * Resizes the mob immediately to the desired mod, animating it growing/shrinking.
 * It can be used by anything that calls it.
 *
 * Arguments:
 * * new_size - CHANGE_ME.
 * * animate - CHANGE_ME. Default: TRUE
 * * uncapped - CHANGE_ME. Default: FALSE
 * * ignore_prefs - CHANGE_ME. Default: FALSE
 * * aura_animation - CHANGE_ME. Default: TRUE
 * * allow_stripping - CHANGE_ME.  Default: FALSE
 */
/mob/living/proc/resize(var/new_size, var/animate = TRUE, var/uncapped = FALSE, var/ignore_prefs = FALSE, var/aura_animation = FALSE, var/allow_stripping = FALSE, var/forced = FALSE) //CHOMPEdit - Disable aura_animation. Too expensive for something you can't even see.
	/*if(!uncapped) //This part handles uncapping the size limits based on area... Potentially add it back later?
		if((z in using_map.station_levels) && CONFIG_GET(flag/pixel_size_limit))
			var/size_diff = ((runechat_y_offset() / size_multiplier) * new_size) // This returns 32 multiplied with the new size
			var/size_cap = world.icon_size * RESIZE_MAXIMUM //Grace for non-humanoids so they don't get forcibly shrunk.
			if(size_diff - size_cap  > 0)
				var/real_diff = size_cap / size_diff // Returns our diff based on the offset to world size
				new_size *= real_diff // Applies our diff to the new size
				new_size = clamp(new_size, RESIZE_MINIMUM, RESIZE_MAXIMUM) //If the sprite is below 32, we clamp it to only go to the resize max.
		else
			new_size = clamp(new_size, RESIZE_MINIMUM, RESIZE_MAXIMUM)
		var/datum/component/resize_guard/guard = GetComponent(/datum/component/resize_guard)
		if(guard)
			qdel(guard)*/
	/*else if(has_large_resize_bounds())
		if(is_extreme_size(new_size))
			AddComponent(/datum/component/resize_guard)
		else
			var/datum/component/resize_guard/guard = GetComponent(/datum/component/resize_guard)
			if(guard)
				qdel(guard)*/

	new_size = clamp(new_size, RESIZE_MINIMUM, RESIZE_MAXIMUM) //Removed the above cause it mainly handles the Dorms oversize stuff. Not really needed yet?

	if((size_multiplier == new_size) && !forced)
		return 1

	if(animate)
		var/change = new_size - size_multiplier
		size_multiplier = new_size //Change size_multiplier so that other items can interact with them
		var/duration = (abs(change)+0.25) SECONDS
		var/matrix/resize = matrix() // Defines the matrix to change the player's size
		//var/special_x = 1
		//var/special_y = 1
		//if(ishuman(src))
			/*var/mob/living/carbon/human/H = src
			var/datum/species/S = H.species
			special_x = S.icon_scale_x
			special_y = S.icon_scale_y*/
			//if(fuzzy || offset_override)
			//	center_offset = 0
			/*else
				center_offset = S.center_offset*/
		resize.Scale(new_size /** icon_scale_x * special_x*/, new_size /** icon_scale_y * special_y*/) //Change the size of the matrix
		resize.Translate(center_offset * size_multiplier /** icon_scale_x * special_x*/, (vis_height/2) * (new_size - 1)) //Move the player up in the tile so their feet align with the bottom
		resize.Turn(lying)
		animate(src, transform = resize, time = duration) //Animate the player resizing

		/*if(aura_animation) //Chomp disabled this according to above, so, lets just comment it out for now.
			var/aura_grow_to = change > 0 ? 2 : 0.5
			var/aura_anim_duration = 5
			var/aura_offset = change > 0 ? 0 : 10
			var/aura_color = size_multiplier > new_size ? "#FF2222" : "#2222FF"
			var/aura_loops = round((duration)/aura_anim_duration)

			animate_aura(src, color = aura_color, offset = aura_offset, anim_duration = aura_anim_duration, loops = aura_loops, grow_to = aura_grow_to)*/
	else
		size_multiplier = new_size //Change size_multiplier so that other items can interact with them
		update_transform() //Lame way
	
	//Get the old Sizecat on someone, trigger it's removal, and then apply the new one! So that buffs/debuffs are based on your size at the time!
	remove_sizecat(src)

	//OV edit
	if(new_size < 0.5) //From RESIZE_MINIMUM to 0.5 is Micro
		apply_sizecat(src, new /datum/sizecat/micro)
	else if(new_size < 0.85) //From 0.5 to 0.85 is Small
		apply_sizecat(src, new /datum/sizecat/small)
	else if(new_size < 1.15) //From 0.85 to 1.15 is None (to account for the scale being different on each end cause it's a multiplier)
		apply_sizecat(src, new /datum/sizecat/none)
	else if(new_size < 1.5) //From 1.15 to 1.5 is Large
		apply_sizecat(src, new /datum/sizecat/large)
	else //From 1.5 to 2 is Macro
		apply_sizecat(src, new /datum/sizecat/macro)
	//OV edit end

/mob/living/carbon/human/resize(var/new_size, var/animate = TRUE, var/uncapped = FALSE, var/ignore_prefs = FALSE, var/aura_animation = FALSE, var/allow_stripping = FALSE, var/forced = FALSE) //CHOMPEdit - Disable aura_animation. Too expensive for something you can't even see.
	if(!resizable && !ignore_prefs)
		return 1
	var/previous_scale = size_multiplier
	. = ..()
	var/size_difference = previous_scale - size_multiplier
	if((allow_stripping == TRUE) && (size_difference >= 0.3) || (size_difference <= -0.3))
		if(size_strip_preference == SIZESTRIP_ITEMS)
			unequip_everything()
		else if(size_strip_preference == SIZESTRIP_ALL)
			unequip_everything()
			if(underwear)
				var/obj/item/bodypart/chest = get_bodypart(BODY_ZONE_CHEST)
				chest.remove_bodypart_feature(underwear.undies_feature)
				underwear.forceMove(loc)
				underwear = null
			if(legwear_socks)
				var/obj/item/bodypart/chest = get_bodypart(BODY_ZONE_CHEST)
				chest.remove_bodypart_feature(legwear_socks.legwears_feature)
				legwear_socks.forceMove(loc)
				legwear_socks = null
	/*if(!ishuman(temporary_form) && isliving(temporary_form)) //Seems to be for Protean self-transform stuff? Likely the blob form I think? But a generic use of it. Not implemented yet. Perhaps this code might be good for fixing Druid Wildshape!!
		var/mob/living/temp_form = temporary_form
		temp_form.resize(new_size, animate, uncapped, ignore_prefs, aura_animation)*/
	/*if(LAZYLEN(hud_list) && has_huds) //I believe this is where it offsets the HUDs over mobs from Sec/Med Goggles and such
		var/new_y_offset = vis_height * (size_multiplier - 1)
		for(var/index = 1 to hud_list.len)
			var/image/HI = grab_hud(index)
			HI.pixel_y = new_y_offset
			apply_hud(index, HI)*/

// Optimize mannequins - never a point to animating or doing HUDs on these.
/mob/living/carbon/human/dummy/mannequin/resize(var/new_size, var/animate = TRUE, var/uncapped = FALSE, var/ignore_prefs = FALSE, var/aura_animation = TRUE, var/allow_stripping = FALSE, var/forced = FALSE)
	size_multiplier = new_size

/**
 * Verb proc for a command that lets players change their size OOCly.
 */

/mob/living/proc/set_size()
	set name = "Adjust Size"
	set category = "OOC" //Seeing as prometheans have an IC reason to be changing mass. <-- Leftover from Chomp!

	var/nagmessage = "Adjust your size to be a size between 25 to 200%. (For OOC/Scene purposes!)" //(or 1% to 600% in dormitories)
	var/default = size_multiplier * 100
	var/new_size = tgui_input_number(src, nagmessage, "Pick a Size", default, 600, 1)
	if(size_range_check(new_size))
		resize(new_size/100,/* uncapped = has_large_resize_bounds(),*/ ignore_prefs = TRUE)
		/*if(temporary_form) //Again the species-specific transformation options, used in Protean's Blob form likely.
			var/mob/living/L = temporary_form
			L.resize(new_size/100, uncapped = has_large_resize_bounds(), ignore_prefs = TRUE)*/
		// log_admin("[key_name(src)] used the resize command in-game to be [new_size]% size. [src ? ADMIN_JMP(src) : "null"]") // CHOMPRemove

/mob/living/Crossed(var/atom/movable/AM)
	..()
	var/mob/living/target = AM
	if(!cmode && istype(target) && !target.cmode && src.lying && target.loc && target.buckled != src)
		// src.lying being true means that in theory this code shouldn't run at the same time as the existing code for this in Bump. Probably.
		// And optionally, this could be gated behind another preference, to prevent stunlock being abused.
		if((/*mob_always_swap || */(istype(a_intent, INTENT_HELP) || get_active_held_item() || src.restrained()) && (istype(target.a_intent, INTENT_HELP) || target.get_active_held_item() || target.restrained())) && !target.IsImmobilized() && target.handle_micro_bump_helping(src))
			return
		if(!(istype(target.a_intent, INTENT_HELP) || target.get_active_held_item() || target.restrained()))
			if(src.step_mechanics_pref && target.step_mechanics_pref)
				target.handle_micro_bump_other(src)
			else
				target.handle_micro_bump_other(src, 1)

/**
 * Attempt to scoop up this mob up into M's hands, if the size difference is large enough.
 * @return false if normal code should continue, 1 to prevent normal code.
 */
/*/mob/living/proc/attempt_to_scoop(mob/living/M, mob/living/G, ignore_size = FALSE) //second one is for the Grabber, only exists for animals to self-grab //OV Edit - Temp Disable Pending Optimization
	if(src == M)
		return FALSE
	if(!(pickup_pref && M.pickup_pref && M.pickup_active))
		return FALSE
	if(!(istype(M.a_intent, INTENT_HELP)))
		return FALSE
	var/size_diff = M.get_effective_size(FALSE) - get_effective_size(TRUE)
	if(!holder_default && holder_type)
		holder_default = holder_type
	if(!istype(M))
		return FALSE
	if(isanimal(M))
		var/mob/living/simple_animal/SA = M
		if(!SA.has_hands())
			return FALSE
		if(mob_size < MOB_SMALL && src == M)
			return FALSE
	if(size_diff >= 0.50 || mob_size < MOB_SMALL || size_diff >= get_effective_size() || ignore_size)
		if(buckled)
			to_chat(src,span_notice("You have to unbuckle \the [src] before you pick them up."))
			return FALSE
		holder_type = /obj/item/holder/micro
		var/obj/item/holder/m_holder = get_scooped(M, G)
		if (m_holder)
			return TRUE
		else
			return FALSE; // Unable to scoop, let other code run
*/
#define STEP_TEXT_OWNER(x) "[replacetext(x,"%prey",tmob)]"
#define STEP_TEXT_PREY(x) "[replacetext(x,"%owner",src)]"
/**
 * Handle bumping into someone with helping intent.
 * Called from /mob/living/Bump() in the 'brohugs all around' section.
 * @return false if normal code should continue, true to prevent normal code.
 */
/mob/living/proc/handle_micro_bump_helping(mob/living/tmob)
	//Riding and being moved to us or something similar
	if(tmob in buckled_mobs)
		return TRUE

	//Both small! Go ahead and go.
	if(get_effective_size(TRUE) <= RESIZE_A_SMALLTINY && tmob.get_effective_size(TRUE) <= RESIZE_A_SMALLTINY)		// For help intent interaction just assume both are 'smol'
		return TRUE

	//Worthy of doing messages at all
	if(abs(get_effective_size(TRUE) - tmob.get_effective_size(TRUE)) >= 0.50)
		var/src_message = null
		var/tmob_message = null

		//Smaller person being stepped onto
		if(get_effective_size(TRUE) > tmob.get_effective_size(TRUE) && ishuman(src))
			src_message = "You carefully step over [tmob]."
			tmob_message = "[src] steps over you carefully!"
			//var/mob/living/carbon/human/H = src
			/*if(H.flying) //Caustic - Flight is... fucky in Roguecode. Will have to address it better.
				return TRUE*/ //Silently pass without a message.
			/*if(istaurtail(H.tail_style)) //Caustic - I don't believe we have these messages on our taur-parts
				var/datum/sprite_accessory/tail/taur/tail = H.tail_style
				src_message = tail.msg_owner_help_run
				tmob_message = tail.msg_prey_help_run*/

		//Smaller person stepping under larger person
		else if(get_effective_size(TRUE) < tmob.get_effective_size(TRUE) && ishuman(tmob))
			src_message = "You run between [tmob]'s legs."
			tmob_message = "[src] runs between your legs."
			/*var/mob/living/carbon/human/H = tmob //Caustic - Same as the comment block above!
			if(istaurtail(H.tail_style))
				var/datum/sprite_accessory/tail/taur/tail = H.tail_style
				src_message = tail.msg_prey_stepunder
				tmob_message = tail.msg_owner_stepunder*/

		if(src_message)
			to_chat(src, span_notice("[src_message]"))
		if(tmob_message)
			to_chat(tmob, span_notice("[tmob_message]"))
		return TRUE
	return FALSE

/**
 * Handle bumping into someone without mutual help intent.
 * Called from /mob/living/Bump()
 *
 * @return false if normal code should continue, 1 to prevent normal code.
 */
/mob/living/proc/handle_micro_bump_other(mob/living/tmob, nofetish = 0) //CHOMPEDIT - changed a lot in this whole proc tbh, to bring back micro combat balance //Caustic Edit - This should ONLY get called IF their hand is empty!
	ASSERT(istype(tmob))
	//If we're flying, don't do any special interactions.
	/*if(flying)
		return*/
	//If the prey is flying, don't smush them. //Caustic - For when we want proper flying integration. It's only harpies now.
	/*if(tmob.flying)
		return*/
	//We can't be stepping on anyone
	if(IsParalyzed() || IsKnockdown() || IsStun() || IsImmobilized() || buckled)
		return
	/*if(is_incorporeal() || tmob.is_incorporeal())
		return*/

	//Riding and being moved to us or something similar
	if(tmob in buckled_mobs)
		return TRUE

	//Test/set if human
	var/mob/living/carbon/human/pred = src
	if(!istype(pred))
		//If we're not human, can't do the steppy
		return FALSE

	var/mob/living/carbon/human/prey = tmob
	var/can_pass = TRUE
	var/size_ratio_needed = (istype(a_intent, INTENT_DISARM) || istype(a_intent, INTENT_HARM)) ? 0.75 : (istype(a_intent, INTENT_GRAB) ? 0.5 : 0)
	if (isturf(prey.loc))
		for (var/atom/movable/M in prey.loc)
			if (prey == M || pred == M)
				continue
			if (isliving(M))
				var/mob/living/L = M
				if (!M.CanPass(src, prey.loc) && !(get_effective_size(FALSE) - L.get_effective_size(TRUE) >= size_ratio_needed || L.lying))
					can_pass = FALSE
				continue
			if (!M.CanPass(src, prey.loc))
				can_pass = FALSE
	if(!istype(prey) || !can_pass)
		//If they're not human, steppy shouldn't happen
		return FALSE

	// We need to be above a certain size ratio in order to do anything to the prey.
	// For DISARM and HURT intent, this is >=0.75, for GRAB it is >=0.5
	var/size_ratio = get_effective_size(FALSE) - tmob.get_effective_size(TRUE)
	if((istype(a_intent, INTENT_GRAB) || istype(a_intent, INTENT_DISARM)) && size_ratio < 0.5) //CHOMPEDIT - more step changes
		return FALSE
	if(istype(a_intent, INTENT_HARM) && size_ratio < 0.75)
		return FALSE
	if(istype(a_intent, INTENT_HELP) || get_active_held_item()) // Theoretically not possible, but just in case.
		return FALSE

	//CHOMPEdit - removed chance to dodge steppies. Get rng out of my combat.
	now_pushing = 0
	forceMove(tmob.loc)
	if(!istype(a_intent, INTENT_HELP) && !get_active_held_item())
		if(tmob.size_multiplier > 0.75 && nofetish) //So we can stun micros with step mechanics off, but prevent macros from stunning regular heights
			to_chat(pred, span_danger("You pass over [tmob.name]."))
			to_chat(prey, span_danger("[src.name] passes over you."))
			return FALSE
		tmob.resting = 1
		tmob.Knockdown(8)
		if(nofetish)
			to_chat(pred, span_danger("You casually knock [tmob.name] over."))
			to_chat(prey, span_danger("[src.name] casually knocks you over."))
			return TRUE

	var/size_damage_multiplier = size_multiplier - tmob.size_multiplier
	// This technically means that I_GRAB will set this value to the same as I_HARM, but
	// I_GRAB won't ever trigger the damage-giving code, so it doesn't matter.
	// I_HARM: Rand 1-3 multiplied by 1 min or 1.75 max. 1 min 5.25 max damage to each limb.
	// I_DISARM: Perform some HALLOSS damage to the smaller.
	//           Since stunned is broken, let's do this. Rand 15-30 multiplied by 1 min or 1.75 max. 15 holo to 52.5 holo, depending on RNG and size differnece.
	var/damage = (istype(a_intent, INTENT_DISARM)) ? (rand(15, 30) * size_damage_multiplier) : (rand(1, 3) * size_damage_multiplier)
	// I_HARM only
	var/calculated_damage = damage / 2 //This will sting, but not kill. Does .5 to 2.625 damage, randomly, to each limb.

	var/message_pred = null
	var/message_prey = null
	/*var/datum/sprite_accessory/tail/taur/tail = null
	if(istaurtail(pred.tail_style))
		tail = pred.tail_style*/
	if(!nofetish)	//CHOMPedit - Brings back mandatory step mechanics, circumvents the fetish stuff if no pref match
		if(istype(a_intent, INTENT_GRAB))
			// You can only grab prey if you have no shoes on. And both of you are cool with it.
			if(pred.shoes || !(pred.pickup_pref && prey.pickup_pref))
				message_pred = "You step down onto [prey], squishing them and forcing them down to the ground!"
				message_prey = "[pred] steps down and squishes you with their foot, forcing you down to the ground!"
				/*if(tail)
					message_pred = STEP_TEXT_OWNER(tail.msg_owner_grab_fail)
					message_prey = STEP_TEXT_PREY(tail.msg_prey_grab_fail)*/
				log_combat(pred, prey,"Grabbed underfoot (with shoes)")
			else
				message_pred = "You pin [prey] down onto the floor with your foot and curl your toes up around their body, trapping them inbetween them!"
				message_prey = "[pred] pins you down to the floor with their foot and curls their toes up around your body, trapping you inbetween them!"
				/*if(tail)
					message_pred = STEP_TEXT_OWNER(tail.msg_owner_grab_success)
					message_prey = STEP_TEXT_PREY(tail.msg_prey_grab_success)*/
				equip_to_slot_if_possible(prey.get_scooped(pred), SLOT_SHOES, 0, 1)
				log_combat(pred, prey, "Grabbed underfoot (without shoes)")

		if(m_intent == MOVE_INTENT_RUN)
			if(istype(a_intent, INTENT_DISARM))
				message_pred = "You quickly push [prey] to the ground with your foot!"
				message_prey = "[pred] pushes you down to the ground with their foot!"
				/*if(tail)
					message_pred = STEP_TEXT_OWNER(tail.msg_owner_disarm_run)
					message_prey = STEP_TEXT_PREY(tail.msg_prey_disarm_run)*/
				log_combat(pred, prey, "Pinned underfoot (run, no halloss)")
			else //It should only hit this if it's "Harm" Intent
				message_pred = "You carelessly step down onto [prey], crushing them!"
				message_prey = "[pred] steps carelessly on your body, crushing you!"
				/*if(tail)
					message_pred = STEP_TEXT_OWNER(tail.msg_owner_harm_run)
					message_prey = STEP_TEXT_PREY(tail.msg_prey_harm_run)*/

				for(var/obj/item/bodypart/B in prey.bodyparts)
					B.receive_damage(calculated_damage, 0, calculated_damage) // 5 damage min, 26.25 damage max, depending on size & RNG. If they're only stepped on once, the damage will (probably not...) heal over time.
				prey.bleed(0.3)
				log_combat(pred, prey, "Crushed underfoot (run, about [calculated_damage] damage)")
		else
			if(istype(a_intent, INTENT_DISARM))
				message_pred = "You firmly push your foot down on [prey], painfully but harmlessly pinning them to the ground!"
				message_prey = "[pred] firmly pushes their foot down on you, quite painfully but harmlessly pinning you to the ground!"
				/*if(tail)
					message_pred = STEP_TEXT_OWNER(tail.msg_owner_disarm_walk)
					message_prey = STEP_TEXT_PREY(tail.msg_prey_disarm_walk)*/
				log_combat(pred, prey, "Pinned underfoot (walk, knocked over for a short moment)")
				tmob.Knockdown(2 SECONDS)
			else //It should only hit this if it's "Harm" Intent
				message_pred = "You methodically place your foot down upon [prey]'s body, slowly applying pressure, crushing them against the floor below!"
				message_prey = "[pred] methodically places their foot upon your body, slowly applying pressure, crushing you against the floor below!"
				/*if(tail)
					message_pred = STEP_TEXT_OWNER(tail.msg_owner_harm_walk)
					message_prey = STEP_TEXT_PREY(tail.msg_prey_harm_walk)*/
				// Multiplies the above damage by 3.5. This means a min of 1.75 damage, or a max of 9.1875. damage to each limb, depending on size and RNG. //Caustic - This seems harsher???
				calculated_damage *= 3.5
				for(var/obj/item/bodypart/B in prey.bodyparts)
					B.receive_damage(calculated_damage, 0, calculated_damage)
				prey.bleed(0.8)
				log_combat(pred, prey, "Crushed underfoot (walk, about [calculated_damage] damage)")

		to_chat(pred, span_danger("[message_pred]"))
		to_chat(prey, span_danger("[message_prey]"))
		return TRUE

/mob/living/verb/toggle_pickups()
	set name = "Toggle Micro Pick-up"
	set desc = "Toggles whether your help-intent action attempts to pick up the micro or pet/hug/help them. Does not disable participation in pick-up mechanics entirely, refer to Vore Panel preferences for that."
	set category = "IC"

	pickup_active = !pickup_active
	to_chat(src, span_notice("You will [pickup_active ? "now" : "no longer"] attempt to pick up mobs when clicking them with help intent."))

#undef STEP_TEXT_OWNER
#undef STEP_TEXT_PREY
