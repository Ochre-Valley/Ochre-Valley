/obj/effect/proc_holder/spell/targeted/touch/glamourother
	name = "Copy Glamour"
	desc = "A spell favoured by Xylixians and other tricksters to cause a bit of mischief, among other things. (( Abuse of this spell for OOC reasons will lead to consequences from staff. ))"
	clothes_req = FALSE
	spell_tier = 1
	recharge_time = 1 MINUTES
	drawmessage = "I prepare to perform a arcyne incantation."
	dropmessage = "I release my arcyne focus."
	overlay_state = "size-change"
	castdrain = 50
	chargetime = 10
	cost = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/glamourother
	sound = 'sound/magic/whiteflame.ogg'

/obj/item/melee/touch_attack/glamourother
	name = "\improper magic touch"
	desc = "Swirling magics ready to copy a person's appearance."
	catchphrase = null
	possible_item_intents = list(INTENT_HELP)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#87d6f0"

/obj/item/melee/touch_attack/glamourother/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(!isliving(target))
		return
	if(!ishuman(target))
		to_chat(user, span_userdanger("<span class='warning'>I need a humen-esque body to copy!</span>"))
		return

	var/mob/living/target_live = target
	if(user.cmode || target_live.cmode) // per request of staff, no using this while in combat
		to_chat(user, span_userdanger("<span class='warning'>These magicks refuse to work while in combat!</span>"))
		return

	if(target_live?.client && !target_live.allow_mimicry)
		to_chat(user, span_userdanger("<span class='warning'>The magicks fly away, refusing to copy from this one...</span>"))
		return

	user.apply_status_effect(/datum/status_effect/buff/glamourapplied)
	user.glamourize_sprite(target_live)

	qdel(src)

/datum/status_effect/buff/glamourapplied
	var/removable = FALSE
	var/last_check = 0

	id = "glamourapplied"
	alert_type = /atom/movable/screen/alert/status_effect/buff/glamourapplied

/datum/status_effect/buff/glamourapplied/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	spawn(300) //is that how it work? i remember there being a better wait timer but i forgor
		if(owner && istype(owner, /mob/living))
			to_chat(owner, span_userdanger("<span class='big'>You feel like you might be able to return to your original appearance by pressing on the status effect!</span>"))
			removable = TRUE

/datum/status_effect/buff/glamourapplied/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	owner.glamourize_sprite(null,TRUE)
	. = ..()

/atom/movable/screen/alert/status_effect/buff/glamourapplied
	name = "Appearance Altered"
	desc = "I've taken on the guise of someone else! (After 30 seconds, you can press this button to return to your original size.)"
	icon_state = "debuff"

/atom/movable/screen/alert/status_effect/buff/glamourapplied/Click()
	. = ..()
	var/mob/living/L = usr
	if(!istype(L)) // how though
		return
	var/datum/status_effect/buff/glamourapplied/effect = L.has_status_effect(/datum/status_effect/buff/glamourapplied)
	if(!effect.removable)
		to_chat(L, span_userdanger("<span class='warning'>I can't turn back yet!</span>"))
		return
	L.remove_status_effect(/datum/status_effect/buff/glamourapplied)

/datum/status_effect/buff/glamourapplied/proc/on_life()
	SIGNAL_HANDLER
	if(world.time < last_check + 10 SECONDS)
		return
	last_check = world.time
	var/mob/living/carbon/human/human_user = owner //Cast to human!
	if(!istype(human_user))
		return

	if(human_user.cmode) //Check if the player is in combat mode
		human_user.remove_status_effect(/datum/status_effect/buff/glamourapplied)

/mob/living
	var/currentlycopyglamoured = FALSE

/mob/living/proc/refresh_glamourized_sprite() //currently unused so we'll see what happens?
	regenerate_icons()
	if(!currentlycopyglamoured)
		return
	var/datum/atom_hud/alternate_appearance/basic/currentappearance = get_alt_appearance("glamoursprite_OVcode")
	if(currentappearance)
		regenerate_icons()
		var/image/I = currentappearance.theImage
		I.override = TRUE
		//I.layer = ABOVE_ALL_MOB_LAYER
		remove_alt_appearance("glamoursprite_OVcode")
		add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/glamour/, "glamoursprite_OVcode", I)
	//var/image/I = image(icon = glamappearance.icon, icon_state = glamappearance.icon_state, loc = glamappearance, layer = glamappearance.layer, pixel_x = glamappearance.pixel_x, pixel_y = glamappearance.pixel_y)
	//I.override = TRUE
	//I.overlays += overlays
	//add_alt_appearance(/datum/atom_hud/alternate_appearance/basic, "glamoursprite_OVcode", I)


//might want to split these into other .dms but eh
/obj/item/book/granter/spell/bonechill/glamourcopy
	name = "Scroll of Copy Glamour"
	spell = /obj/effect/proc_holder/spell/targeted/touch/glamourother
	spellname = "Copy Glamour"
	icon_state ="scrolldarkred"
	oneuse = TRUE
	remarks = list()

/obj/item/book/granter/spell/bonechill/glamourcopy/loadout // Loadout specific ones!
	needLit = FALSE
	pages_to_mastery = 0 //OV Edit: reads faster


/datum/loadout_item/copyglamour //I'd have this even further up the list if I could, but I don't want to needlessly edit the Azure loadouts
	name = "Scroll of Copy Glamour"
	path = /obj/item/book/granter/spell/bonechill/glamourcopy/loadout

/datum/supply_pack/rogue/kink_toy/copy_glamour
	name = "Scroll of Copy Glamour"
	cost = 20
	contains = list(/obj/item/book/granter/spell/bonechill/glamourcopy)

/datum/supply_pack/rogue/luxury/copyglamour
	name = "Scroll of Copy Glamour"
	cost = 15
	contains = list(/obj/item/book/granter/spell/bonechill/glamourcopy)

/mob/living/proc/glamourize_sprite(mob/living/target, noglamour = FALSE)
	if(currentlycopyglamoured) //remove past glamour first
		remove_alt_appearance("glamoursprite_OVcode")

	if(!noglamour && target)
		var/matrix/resize = matrix()
		//var/image/I = image(icon = target.icon, icon_state = target.icon_state, loc = src, layer = target.layer, pixel_x = target.pixel_x, pixel_y = target.pixel_y)
		var/image/I = image(icon = target.icon, icon_state = target.icon_state, loc = src, layer = target.layer, pixel_x = target.pixel_x, pixel_y = target.pixel_y)
		I.override = TRUE
		resize.Scale(src.size_multiplier /** icon_scale_x * special_x*/, size_multiplier /** icon_scale_y * special_y*/) //Change the size of the matrix
		resize.Translate(center_offset * src.size_multiplier /** icon_scale_x * special_x*/, (vis_height/2) * (size_multiplier - 1)) //Move the player up in the tile so their feet align with the bottom
		resize.Turn(src.lying)
		animate(I, transform = resize, time = 5)
		I.copy_overlays(target)
		//I.layer = ABOVE_ALL_MOB_LAYER
		add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/glamour/, "glamoursprite_OVcode", I)
		currentlycopyglamoured = TRUE
		regenerate_icons()
	else
		remove_alt_appearance("glamoursprite_OVcode") //just in case, always make sure we work to remove
		currentlycopyglamoured = FALSE


/datum/atom_hud/alternate_appearance/basic/glamour/New(key, image/I, options = AA_TARGET_SEE_APPEARANCE)
	..()

	theImage = I
	target = I.loc
	//I.copy_overlays(target) //keeping this all commented out so I have a reminder of what I changed to get this whole thing working

	hud_icons = list(appearance_key)
	add_to_hud(target, I)
//	if((options & AA_TARGET_SEE_APPEARANCE) && ismob(target))
//		add_hud_to(target)
	if(add_ghost_version)
		var/image/ghost_image = image(icon = I.icon , icon_state = I.icon_state, loc = I.loc)
		ghost_image.override = FALSE
		ghost_image.alpha = 128
		ghost_appearance = new /datum/atom_hud/alternate_appearance/basic/observers(key + "_observer", ghost_image, NONE)


/atom/proc/get_alt_appearance(key)
	if(alternate_appearances)
		for(var/K in alternate_appearances)
			var/datum/atom_hud/alternate_appearance/AA = alternate_appearances[K]
			if(AA.appearance_key == key)
				return AA

