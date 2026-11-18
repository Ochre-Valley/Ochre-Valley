/mob/living/proc/glamourize_sprite(mob/living/target, noglamour = FALSE, retain_scale = TRUE)
	if(currentlycopyglamoured) //remove past glamour first
		remove_alt_appearance("glamoursprite_OVcode" + src.ckey)

	if(!noglamour && target)
		var/matrix/resize = matrix()
		//var/image/I = image(icon = target.icon, icon_state = target.icon_state, loc = src, layer = target.layer, pixel_x = target.pixel_x, pixel_y = target.pixel_y)
		var/image/I = image(icon = target.icon, icon_state = target.icon_state, loc = src, layer = target.layer, pixel_x = target.pixel_x, pixel_y = target.pixel_y)
		I.override = TRUE

		if(retain_scale)
			resize.Scale(src.size_multiplier /** icon_scale_x * special_x*/, size_multiplier /** icon_scale_y * special_y*/) //Change the size of the matrix
			resize.Translate(center_offset * src.size_multiplier /** icon_scale_x * special_x*/, (vis_height/2) * (size_multiplier - 1)) //Move the player up in the tile so their feet align with the bottom
			resize.Turn(src.lying)
			animate(I, transform = resize, time = 5)
		I.copy_overlays(target)
		I.layer = src.layer
		I.plane = src.plane
		add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/glamour/, "glamoursprite_OVcode" + src.ckey, I)
		currentlycopyglamoured = TRUE
		regenerate_icons()
	else
		remove_alt_appearance("glamoursprite_OVcode" + src.ckey) //just in case, always make sure we work to remove
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

	for(var/mob in GLOB.mob_list)
		if(mobShouldSee(mob))
			add_hud_to(mob)

/datum/atom_hud/alternate_appearance/basic/glamour/mobShouldSee(mob/M)
	return TRUE //may change this to excluding observers, buuuut admins should be able to tell very easily anyway

/atom/proc/get_alt_appearance(key)
	if(alternate_appearances)
		for(var/K in alternate_appearances)
			var/datum/atom_hud/alternate_appearance/AA = alternate_appearances[K]
			if(AA.appearance_key == key)
				return AA

/mob/living
	var/currentlycopyglamoured = FALSE

/mob/living/proc/refresh_glamourized_sprite() //currently unused so we'll see what happens?
	regenerate_icons()
	if(!currentlycopyglamoured)
		return
	var/datum/atom_hud/alternate_appearance/basic/currentappearance = get_alt_appearance("glamoursprite_OVcode" + src.ckey)
	if(currentappearance)
		regenerate_icons()
		var/image/I = currentappearance.theImage
		I.override = TRUE
		I.layer = src.layer
		I.plane = src.plane
		remove_alt_appearance("glamoursprite_OVcode" + src.ckey)
		add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/glamour/, "glamoursprite_OVcode" + src.ckey, I)


