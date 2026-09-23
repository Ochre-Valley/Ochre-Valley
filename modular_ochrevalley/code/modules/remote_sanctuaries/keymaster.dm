#define KEYMASTER_DESC "A queer device that allows one to purchase and access expensive private residences in far off locations. It's a little too enthusiastic - and LOUD - about serving its function."
#define KEYMASTER_PORTAL_DISCLAIMER "Remote sanctuaries are private sleep rooms akin to inn rooms. You may potentially stumble into a scene. Remote sanctuaries are also not to be abused as a means to escape IC consequences."

/obj/item/roguemachine/keymaster
	name = "KEYMASTER"
	desc = KEYMASTER_DESC
	icon = 'modular_ochrevalley/icons/misc/machines.dmi'
	icon_state = "keymaster"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC
	bigboy = TRUE
	/// Associated list of which ckeys have how much money stored here, storing money on a per-client basis. This allows multiple players to use the KEYMASTER without worrying about overlapping money from others.
	///
	/// Key is the player's ckey, value is the amount of mammon stored by that player.
	var/list/stored_money = alist()
	/// Associated list. key is the player's ckey, value is the ID of the sanctuary the player had last selected.
	var/list/selected_sanctaury = alist()
	/// A list of ckeys detailing which players we are currently generating a sanctuary for.
	var/list/generating_for = list()
	/// A list of ckeys detailing which players are seeing the CONFIRM prompt.
	var/list/showing_confirm_prompt_for = list()
	/// Is this KEYMASTER intended to be used by wretches (AKA it SHOULD be in the wretch coast)?
	var/for_wretches = FALSE
	/// A list of lines that the KEYMASTER will yell when it successfully creates a portal.
	var/list/portal_lines = list(
		"THY PORTAL ART READY! PRITHEE, TAKE BUT ONE STEP WITHIN TO TRAVEL FAR BEYOND!!",
		"I HATH RENT A GATEWAY FOR THEE! THY DESTINATION AWAITS!!",
		"FOR THEE, YONDER PORTAL!! THY TRAVEL, STREAMLINED!! THE DISTANCE BETWEEN ME'S CUT FROM MILES TO INCHES IN ONE CLEAVE!!",
		"THE ME OF THERE HAS SPOKEN WITH THE ME OF HERE!! WE HATH AGREED TO YIELD TO THEE A PORTAL!!",
		"FOR THEE; A DOOR WHERE THERE WAS MOTES AGO AIR!! ON ITS OTHER SIDE; SANCTUARY!!",
		"A PORTAL HATH BEEN OPENED FOR THEE!! WAHOO!!"
	)
	/// An alternative list of lines that the wretch coast variant of the KEYMASTER will yell when it successfully creates a portal.
	var/list/portal_lines_wretches = list(
		"HERE IS YOUR PORTAL. GET IN BEFORE I HAVE TO LISTEN TO THE ME ON THE OTHER SIDE PRATTLE FURTHER.",
		"YEP, THAT KEY SEEMS GOOD ENOUGH. HERE'S YOUR PORTAL. BRING YOUR FRIENDS. OR DON'T.",
		"I CAN CLEAVE THROUGH DISTANCE ITSELF, CREATING A MAGICK DISTORTION OF THE SPACE BETWEEN THE ME OF HERE AND THE ME OF THERE. I AM A MARVEL OF ARTIFICING. AND THIS IS HOW I AM BEING USED. JOY. ANYWAYS, YOUR PORTAL IS READY.",
		"A GATEWAY OPENS. UNTIL YOU STEP ON THE OTHER SIDE, YOU WON'T KNOW FOR SURE WHETHER IT LEADS TO THE PROPER SANCTUARY OR ANOTHER ME POSITIONED OVER A VOLCANO.",
		"PORTAL. ONE MINUTE. DON'T FEEL LIKE SAYING MORE.",
	)

/obj/item/roguemachine/keymaster/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info(span_blue("These can be used to purchase remote sanctuaries: <b>EXPENSIVE</b>, private residences in far-off lands that are accessed via portals."))
	. += span_info(span_blue("LEFT CLICK with an empty hand to browse through a selection of remote sanctuaries."))
	. += span_info(span_blue("LEFT CLICK on it with a remote sanctuary key to open a portal to the sanctuary that the key was forged for. The portal will linger for one minute and cannot be prematurely closed."))
	. += span_info(span_blue("If you already own a remote sanctuary, you can RIGHT CLICK the KEYMASTER with an empty hand to obtain a spare key to your sanctuary."))
	. += span_info(span_blue("Money inserted into the KEYMASTER is stored on a per-player basis: That means multiple people can use the machine at once without having to worry about accidentally using someone else's money. This also means money inserted into it cannot be withdrawn by anyone else but the player who put it in."))

/obj/item/roguemachine/keymaster/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	ui_interact(user)

/obj/item/roguemachine/keymaster/attack_right(mob/user)
	. = ..()
	handle_spare_keys(user)

/obj/item/roguemachine/keymaster/Initialize(mapload)
	. = ..()
	if(for_wretches)
		SSremote_sanctuaries.keymaster_wretchcoast = src
	else
		SSremote_sanctuaries.keymaster_town = src

/obj/item/roguemachine/keymaster/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(!user)
		return
	if(!ishuman(user))
		return
	if(istype(I, /obj/item/roguecoin/aalloy) || istype(I, /obj/item/roguecoin/inqcoin))
		return
	if(istype(I, /obj/item/roguekey/remote_sanctuary))
		var/obj/item/roguekey/remote_sanctuary/K = I
		user.visible_message(span_notice("\The [user] sticks the pronged teeth of [K] against the KEYMASTER. Its glassy surface begins to glow and swirl..."), span_notice("I stick the pronged teeth of [K] against the KEYMASTER. Its glassy surface begins to glow and swirl. The artificed metal begins to tremble in my grasp..."))
		playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
		if(do_after(user, 5 SECONDS, target = src))
			key_act(user, K.sanctuary_owner_ckey)
	if(istype(I, /obj/item/roguecoin))
		stored_money[user.ckey] = (stored_money[user.ckey] || 0) + I.get_real_price()
		qdel(I)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		update_user_ui(user)

/obj/item/roguemachine/keymaster/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		ui = new(user, src, "Keymaster", name)
		ui.open()
		ui.set_autoupdate(FALSE)

/obj/item/roguemachine/keymaster/ui_static_data(mob/user)
	var/list/data = list()
	data["can_read"] = (ishuman(user) && user.can_read(src, TRUE)) ? TRUE : FALSE
	var/list/available_sanctuaries = list()
	for(var/a_key, a_val in SSmapping.remote_sanctuary_templates)
		available_sanctuaries += get_sanctuary_payload(a_key)
	data["available_sanctuaries_data"] = available_sanctuaries
	return data

/obj/item/roguemachine/keymaster/ui_data(mob/user)
	var/list/data = list()
	var/list/sanctuary_data = list()
	var/datum/map_template/remote_sanctuary/S = get_currently_selected_sanctuary(user)
	if(S)
		sanctuary_data["name"] = S.name
		sanctuary_data["id"] = S.sanctuary_id
		sanctuary_data["description"] = S.description
		sanctuary_data["width"] = S.width
		sanctuary_data["height"] = S.height
		sanctuary_data["floors"] = S.floors
		sanctuary_data["price"] = S.price
		sanctuary_data["subtitle"] = S.subtitle
	data["stored_money"] = stored_money[user.ckey] || 0
	data["selected_sanctuary"] = sanctuary_data
	data["is_generating_for_us"] = (user.ckey in generating_for)
	data["already_owns_sanctuary"] = SSremote_sanctuaries.get_claimed_sanctuary(user.ckey) ? TRUE : FALSE
	data["is_showing_confirm_option"] = (user.ckey in showing_confirm_prompt_for)
	return data

/obj/item/roguemachine/keymaster/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	var/datum/map_template/remote_sanctuary/S = get_currently_selected_sanctuary(usr)
	if(!S)
		return
	switch(action)
		if("select_sanctuary")
			var/selected_id = params["selected_id"]
			if(!selected_id || !istext(selected_id) || !length(selected_id))
				return
			var/datum/map_template/remote_sanctuary/new_select = SSmapping.remote_sanctuary_templates[selected_id]
			if(!new_select)
				return
			selected_sanctaury[usr.ckey] = new_select.sanctuary_id
			showing_confirm_prompt_for.Remove(usr.ckey)
			update_user_ui(usr)
			return FALSE
		if("purchase_sanctuary")
			var/our_monies = stored_money[usr.ckey]
			if(isnum(our_monies) && our_monies >= S.price)
				if(usr.ckey in generating_for || SSremote_sanctuaries.get_claimed_sanctuary(usr.ckey))
					return
				purchase_sanctuary(usr, S.sanctuary_id)
				our_monies -= S.price
				stored_money[usr.ckey] = our_monies
				showing_confirm_prompt_for.Remove(usr.ckey)
				update_user_ui(usr)
			return FALSE
		if("refund_money")
			refund_money(usr)
			showing_confirm_prompt_for.Remove(usr.ckey)
			update_user_ui(usr)
			return FALSE
		if("open_confirm_choice")
			if(usr.ckey in showing_confirm_prompt_for)
				return
			showing_confirm_prompt_for.Add(usr.ckey)
			update_user_ui(usr)
			return FALSE

// Please do not drag around the funny machine
/obj/item/roguemachine/keymaster/MouseDrop(atom/over)
	return

/obj/item/roguemachine/keymaster/proc/get_currently_selected_sanctuary(mob/user)
	return SSmapping.remote_sanctuary_templates[selected_sanctaury[user.ckey] || "cozy_homestead"]

/obj/item/roguemachine/keymaster/proc/update_user_ui(mob/user)
	var/datum/tgui/ui = SStgui.get_open_ui(user, src)
	ui?.send_update()

/obj/item/roguemachine/keymaster/proc/refund_money(mob/user)
	if(!user?.ckey)
		return
	var/our_monies = stored_money[user.ckey]
	if(!our_monies || our_monies <= 0)
		return
	stored_money[user.ckey] = 0
	budget2change(our_monies, user)
	playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)

/obj/item/roguemachine/keymaster/proc/get_sanctuary_payload(sanctuary_id)
	var/datum/map_template/remote_sanctuary/S = SSmapping.remote_sanctuary_templates[sanctuary_id]
	if(!S)
		return null
	var/list/data = list(list(
		"name" = S.name,
		"id" = S.sanctuary_id,
		"description" = S.description,
		"width" = S.width,
		"height" = S.height,
		"floors" = S.floors,
		"price" = S.price,
		"subtitle" = S.subtitle,
	))
	return data

/obj/item/roguemachine/keymaster/proc/purchase_sanctuary(mob/living/carbon/human/user, sanctuary_id)
	// We first spawn the key in nullspace to ensure that a lockhash with its ID exists before
	// the player's sanctuary is generated. This way all the lockable things in there will be
	// usable with the key!
	to_chat(user, span_notice("\The [src] begins to whirr and CLANK loudly. I'll need to wait a mote..."))
	generating_for.Add(user.ckey)
	// Update so the UI tells the user their key is being made
	update_user_ui(user)
	balloon_alert_to_viewers("<font color='[GLOW_COLOR_ARCANE]'>*WHIRR, CLANK*</font>")
	var/obj/item/roguekey/remote_sanctuary/key = regurgitate_key(user)
	var/datum/sanctuary_data/data = SSremote_sanctuaries.claim_sanctuary(user, sanctuary_id, for_wretches)
	qdel(key)
	generating_for.Remove(user.ckey)
	// Update again to account for the fact that they're now a land owner
	update_user_ui(user)
	balloon_alert_to_viewers("*<font color='[GLOW_COLOR_ARCANE]'>*FWOOSH!*</font>*")
	user.put_in_hands(key)
	playsound(loc, 'sound/magic/swap.ogg', 100, TRUE, -1)
	if(for_wretches)
		keymaster_say(pick(data.used_template.purchase_lines_wretch))
	else
		keymaster_say(pick(data.used_template.purchase_lines))
	to_chat(user, span_notice("\The [src] has completed its archaic, arcane task. I can now retreive my key from it."))

/// Dispenses a remote sanctuary key to the user
/obj/item/roguemachine/proc/regurgitate_key(mob/living/carbon/human/user)
	return new /obj/item/roguekey/remote_sanctuary(null, user)

/// Dispenses a remote sanctuary key to the user
/obj/item/roguemachine/proc/handle_spare_keys(mob/user)
	if(!user || !ishuman(user))
		return
	var/datum/sanctuary_data/D = SSremote_sanctuaries.get_claimed_sanctuary(user.ckey)
	if(!D)
		playsound(loc, 'sound/misc/machineno.ogg', 100, TRUE, -1)
		if(D.is_wretch_made())
			say("IS THIS A JOKE? PURCHASE A SANCTUARY FIRST BEFORE TRYING TO GET A SPARE KEY, FOOL.")
		else
			say("MINE APOLOGIES, I CANST NOT PROVIDE THEE WITH A SPARE SANCTUARY KEY UNTIL THOU FIRST PURCHASE A SANCTUARY!!")
	else if(D.spare_keys_remaining > 0)
		D.spare_keys_remaining--
		var/obj/item/roguekey/remote_sanctuary/K = regurgitate_key(user)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		balloon_alert(user, "[D.spare_keys_remaining] spare keys left...")
		user.put_in_hands(K)
	else
		playsound(loc, 'sound/misc/machineno.ogg', 100, TRUE, -1)
		if(D.is_wretch_made())
			say("NO MORE... I REFUSE TO COUGH UP ANY MORE SPARE KEYS FOR YOU.")
		else
			say("MINE APOLOGIES, DISCERNER, BUT I CANST NOT PROVIDE THEE WITH ANY MORE SPARE KEYS!!")

/obj/item/roguemachine/keymaster/proc/key_act(mob/living/carbon/human/user, sanctuary_owner_ckey)
	var/datum/sanctuary_data/D = SSremote_sanctuaries.get_claimed_sanctuary(sanctuary_owner_ckey)
	if(for_wretches && !D.is_wretch_made())
		say("THAT KEY WASN'T FORGED BY ME. I CAN'T ACCESS ITS SANCTUARY, FOOL. SHOW IT TO THE OTHER, LOUDER, MORE ANNOYING ORB IN TOWN.")
		playsound(loc, 'sound/misc/machineno.ogg', 100, TRUE, -1)
		return
	if(!for_wretches && D.is_wretch_made())
		say("HUH!! I DOTH NOT RECOGNIZE THIS KEY!! MINE APOLOGIES, BUT I CANST NOT TAKE THEE TO A SANCTUARY WHOSE KEY I DID NOT FORGE!!")
		playsound(loc, 'sound/misc/machineno.ogg', 100, TRUE, -1)
		return
	var/portal_attempt = SSremote_sanctuaries.try_create_portals(sanctuary_owner_ckey)
	if(isnum(portal_attempt))
		switch(portal_attempt)
			if(SANCTUARY_PORTAL_SUCCESSFUL)
				playsound(loc, 'sound/misc/machineno.ogg', 100, TRUE, -1)
				if(for_wretches)
					keymaster_say(pick(portal_lines_wretches))
				else
					keymaster_say(pick(portal_lines))
			if(SANCTUARY_PORTAL_ERROR_OBSTRUCTEDTURFS)
				say("AN ISSUE ARISES: THE SANCTUARY HATH TOO MANY OBSTRUCTIONS AROUND MINE ORB ON THE OTHER SIDE! I CANST NOT CONJURE A PORTAL FOR THEE UNTIL THE SPACE IS CLEARED!! MINE APOLOGIES!!")
				playsound(loc, 'sound/misc/machineno.ogg', 100, TRUE, -1)
			if(SANCTUARY_PORTAL_ERROR_MOBSINWAY)
				say("AN ISSUE ARISES: THE SANCTUARY HATH TOO MANY LIVING MEATBAGS IN THE WAY! I CANST NOT CONJURE A PORTAL FOR THEE UNTIL THEY MOVE!! WAIT UNTIL THEY MOVE AND TRY AGAIN!!")
				playsound(loc, 'sound/misc/machineno.ogg', 100, TRUE, -1)
			if(SANCTUARY_PORTAL_ERROR_PORTALSALREADYEXIST)
				playsound(loc, 'sound/misc/machineno.ogg', 100, TRUE, -1)
				if(for_wretches)
					say("THERE'S ALREADY AN OPEN PORTAL LEADING TO THAT SANCTUARY. IT'S RIGHT HERE NEXT TO US, FOOL.")
				else
					say("UH. SIRE, THERE ART ALREADY A PORTAL TO THAT SANCTUARY NEXT TO US!!")

/obj/item/roguemachine/keymaster/proc/keymaster_say(var/line)
	var/soundfile = pick('sound/misc/machinetalk.ogg', 'sound/misc/machinelong.ogg')
	playsound(loc, soundfile, 100, TRUE, -1)
	say(line)

/// This variant just exists to specify that it's meant to be the OTHER keymaster located in the wretch coast
/obj/item/roguemachine/keymaster/wretch_coast
	for_wretches = TRUE

/// KEYMASTER variant that exists to take the player back out of a sanctuary.
/obj/item/roguemachine/keymaster_exit
	name = "KEYMASTER"
	desc = KEYMASTER_DESC
	icon = 'modular_ochrevalley/icons/misc/machines.dmi'
	icon_state = "keymaster"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC
	bigboy = TRUE
	/// Data of the sanctuary we belong to.
	var/datum/sanctuary_data/data
	var/list/portal_lines = list(
		"I HOPE THOU HATH ENJOYED THY STAY!!",
		"THE PORTAL BACK HATH OPENED!!",
		"A GATEWAY FROM WHENCE THOU CAME!",
		"PRITHEE, TREAD CAREFULLY THROUGH YONDER PORTAL!!",
	)
	var/list/portal_lines_wretches = list(
		"LEAVING SO SOON? ALRIGHT THEN.",
		"NO REST FOR THE WICKED. YOUR PORTAL IS READY.",
		"GO ON, THEN. GET BACK OUT THERE.",
		"UGH, PLEASE GO THROUGH QUICK. HATE HEARING WHAT THE ME ON THE OTHER SIDE IS THINKING.",
	)

/obj/item/roguemachine/keymaster_exit/attack_hand(mob/user)
	. = ..()
	to_chat(user, span_notice("I place my hand upon the KEYMASTER..."))
	if(!do_after(user, 5 SECONDS, target = src))
		return
	var/portal_attempt = SSremote_sanctuaries.try_create_portals(data.owner_ckey)
	if(isnum(portal_attempt))
		switch(portal_attempt)
			if(SANCTUARY_PORTAL_SUCCESSFUL)
				playsound(loc, 'sound/misc/machinetalk.ogg', 100, TRUE, -1)
				if(data.is_wretch_made())
					say(pick(portal_lines_wretches))
				else
					say(pick(portal_lines))
			if(SANCTUARY_PORTAL_ERROR_OBSTRUCTEDTURFS)
				say("AN ISSUE ARISES: THE WAE BACK HATH TOO MANY OBSTRUCTIONS AROUND MINE ORB ON THE OTHER SIDE! I CANST NOT CONJURE A PORTAL FOR THEE UNTIL THE SPACE IS CLEARED!! MINE APOLOGIES!!")
				playsound(loc, 'sound/misc/machineno.ogg', 100, TRUE, -1)
			if(SANCTUARY_PORTAL_ERROR_MOBSINWAY)
				say("AN ISSUE ARISES: THE WAE BACK HATH TOO MANY LIVING MEATBAGS IN THE WAY! I CANST NOT CONJURE A PORTAL FOR THEE UNTIL THEY MOVE!! WAIT UNTIL THEY MOVE AND TRY AGAIN!!")
				playsound(loc, 'sound/misc/machineno.ogg', 100, TRUE, -1)
			if(SANCTUARY_PORTAL_ERROR_PORTALSALREADYEXIST)
				playsound(loc, 'sound/misc/machineno.ogg', 100, TRUE, -1)
				if(data.is_wretch_made())
					say("THERE'S ALREADY AN OPEN PORTAL LEADING BACK. IT'S RIGHT HERE NEXT TO US, FOOL.")
				else
					say("UH. SIRE, THERE ART ALREADY A PORTAL BACK NEXT TO US!!")
			if(SANCTUARY_PORTAL_ERROR_DANGEROUSTURFS)
				playsound(loc, 'sound/misc/machineno.ogg', 100, TRUE, -1)
				if(data.is_wretch_made())
					say("I CANNOT MAKE THE PORTAL. THE ONLY UNOBSTRUCTED PLACES I CAN CREATE PORTALS AROUND ONE OR BOTH ME'S ARE TOO DANGEROUS. I'M NOT MAKING PORTALS ON TOP OF DEATH TRAPS.")
				else
					say("AN ISSUE ARISES: THE ONLY UNOBSTRUCTED PLACES I CAN CREATE PORTALS AROUND ONE OR BOTH ME'S ARE TOO DANGEROUS!! I SHAN'T MAKE THE PORTALS FOR THY SAFETY UNTIL THE DANGERS ARE CLEARED!!")

/obj/item/roguemachine/keymaster_exit/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/roguekey/remote_sanctuary))
		playsound(loc, 'sound/misc/machineno.ogg', 100, TRUE, -1)
		if(data.is_wretch_made())
			say("YOU DO NOT NEED TO USE A KEY TO RETURN TO [uppertext(SSticker.realm_name)], FOOL. JUST PLACE YOUR EMPTY HAND UPON MY ORB.")
		else
			say("OH, THOU NEED NOT USE A KEY TO RETURN TO [uppertext(SSticker.realm_name)]!! JUST PLACE THY EMPTY HAND UPON MINE ORB!!")

/obj/item/roguemachine/keymaster_exit/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info(span_blue("Left click this with an empty hand to create a portal that will take you back to [SSticker.realm_name]."))
	. += span_info(span_blue("If you already own a remote sanctuary, you can RIGHT CLICK the KEYMASTER with an empty hand to obtain a spare key to your sanctuary."))

/obj/item/roguemachine/keymaster_exit/attack_right(mob/user)
	. = ..()
	handle_spare_keys(user)


/obj/structure/fluff/traveltile/sanctuary_portal
	name = "sanctuary portal"
	desc = "A marvel of magicks automated by artifice. I cannot see the other side, but wherever it will take me, I can be sure I will be traveling for miles in but a single step..."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "underworldportal"
	travel_message = span_blue("The magickal gateway requires a mote to carry me to my destination...")
	light_inner_range = 4
	light_outer_range = 5
	light_color = "#79ecfc"
	light_on = TRUE
	var/shows_disclaimer = FALSE

/// Alerts `user` that this travel tile may take them to the middle of a scene due to the intention of remote sanctuaries.
///
/// #### Returns:
/// `TRUE` if they click "I Understand" on the popup while still in range of the portal. `FALSE` in all other cases.
/obj/structure/fluff/traveltile/proc/is_mob_okay_with_the_sex(mob/user)
	if(tgui_alert(user, KEYMASTER_PORTAL_DISCLAIMER, "DISCLAIMER", list("Get Me Outta Here", "I Understand")) != "I Understand")
		return FALSE
	// The portal could despawn by the time they accept the popup so...
	if(!src?.loc)
		return FALSE
	// Make sure they're still in a legal range to access the portal by this point
	var/list/turfs_in_range = RANGE_TURFS(1, src.loc)
	for(var/turf/T in turfs_in_range)
		if(user in T.contents)
			return TRUE
	// If we didn't find them, they aren't in a legal spot to use the portal, bye-bye
	return FALSE


/obj/structure/fluff/traveltile/proc/shows_remote_sanctuary_disclaimer()
	return FALSE

/obj/structure/fluff/traveltile/sanctuary_portal/shows_remote_sanctuary_disclaimer()
	return shows_disclaimer

/obj/structure/fluff/traveltile/sanctuary_portal/Initialize(mapload, shows_disclaimer)
	src.shows_disclaimer = shows_disclaimer
	if(loc)
		playsound(loc, 'sound/misc/portalactivate.ogg', 100, TRUE, -1)
		visible_message(span_blue("\The [src] appears in a brilliant cerulean flash!"))
	. = ..(mapload)

/obj/structure/fluff/traveltile/sanctuary_portal/perform_travel(obj/structure/fluff/traveltile/T, mob/living/L)
	playsound(loc, 'sound/misc/portalenter.ogg', 100, TRUE, -1)
	L.visible_message(span_notice("\The [L] enters \the [src] and vanishes inside in a single step."), span_blue("I feel a violent and sudden pull at the core of my being. By the time I am standing on stable ground again, I feel as though I have been falling for ages... Or was it only a fraction of a second?"))
	T.visible_message(span_notice("\The [L] emerges from the shimmering portal!"))
	playsound(T, 'sound/misc/portalenter.ogg', 100, TRUE, -1)
	. = ..()

/obj/structure/fluff/traveltile/sanctuary_portal/proc/expire()
	visible_message("\The [src] dissolves into cerulean sparks that waver and fizzle out like dying embers.")
	qdel(src)

// The keys the KEYMASTER spits out
/obj/item/roguekey/remote_sanctuary
	name = "remote sanctuary key"
	icon = 'modular_ochrevalley/icons/roguetown/items/keys.dmi'
	icon_state = "sanctuary_key"
	desc = "Mana and metal married and became as one to fit in a keyhole that did not exist until their conception. When I squeeze its handle, bright cerulean arcs flare and dance betwixt the azure teeth."
	/// Ckey of the player whose sanctuary this key leads to.
	var/sanctuary_owner_ckey

/obj/item/roguekey/remote_sanctuary/Initialize(mapload, mob/living/carbon/human/owner)
	sanctuary_owner_ckey = owner.ckey
	lockid = "sanctuary_[owner.ckey]"
	name = "[name] ([owner.real_name])"
	aura_color = owner.voice_color
	. = ..(mapload)

/obj/item/roguekey/remote_sanctuary/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info(span_blue("Use this on the KEYMASTER to create a portal that will allow you to enter the remote sanctuary it was made for."))
	. += span_info(span_blue("This key will also work as a regular key does for any and all doors, chests, and closets within the sanctuary it was made for."))

#undef KEYMASTER_DESC
#undef KEYMASTER_PORTAL_DISCLAIMER
