GLOBAL_LIST_INIT(gurgled_overlays, list(
								"green" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "green"),
								"white" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "white"),
								"black" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "black"),
								"grey" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "grey"),
								"yellow" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "yellow"),
								"red" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "red"),
								"blue" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "blue"),
								"orange" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "orange"),
								"purple" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "purple"),
								"lime" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "lime"),
								"brown" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "brown"),
								"darkred" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "darkred"),
								"cyan" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "cyan"),
								"beige" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "beige"),
								"pink" = icon('modular_causticcove/icons/effects/sludgeoverlay_vr.dmi', icon_state = "pink")
								))

/obj/item/proc/gurgle_contaminate(atom/movable/item_storage = null, contamination_flavor = "Generic", contamination_color = "green")
	if(!can_gurgle())
		return FALSE

	if(gurgled && !(gurgled_color == contamination_color))
		wash_atom(src,CLEAN_STRONG)

	if(!gurgled)
		gurgled = TRUE
		gurgled_color = contamination_color
		var/list/pickfrom = GLOB.contamination_flavors[contamination_flavor]
		var/gurgleflavor = pick(pickfrom)

		if(!isbelly(src.loc)) //Moved non-worn overlay stuff to belly_obj_vr.dm Exited proc. No need to add overlays to things that won't make it out.
			src.LoadComponent(/datum/component/decal/contamination, _color=gurgleflavor, _flavor=contamination_flavor)

		//add_overlay(GLOB.gurgled_overlays[gurgled_color]) //Caustic TODO - Change this from an Overlay to a Decal like Blood is. /datum/component/decal/blood This might be why it doesn't work?

		//cleanname = src.name
		//cleandesc = src.desc
		//name = "[gurgleflavor] [cleanname]"
		//desc = "[cleandesc] It seems to be covered in ominously foul residue and needs a wash."
//		for(var/obj/item/O in contents)			//Yeah, no. This contaminates stuff that should never be contaminated in places that should not be reached. Handle it for specific cases instead.
//			O.gurgle_contaminate(item_storage, contamination_flavor, contamination_color)
		return TRUE

/obj/item/proc/can_gurgle() //Caustic - Perhaps an item blacklist to prevent it from getting contaminated here?
	return TRUE

//////////////
// Special handling of gurgle_contaminate
//////////////


/obj/item/pda/gurgle_contaminate(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/reagent_containers/food/gurgle_contaminate(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/storage/vore_egg/gurgle_contaminate(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/holder/gurgle_contaminate(var/atom/movable/item_storage = null)
	if(isbelly(loc))
		digest_act(item_storage)
		return TRUE
	return FALSE

/obj/item/organ/gurgle_contaminate(var/atom/movable/item_storage = null)
	return FALSE

/*/obj/item/cell/gurgle_contaminate(var/atom/movable/item_storage = null)
	if(!gurgled)
	//Don't make them wet, just drain
		var/obj/item/cell/C = src
		C.charge = 0
	return TRUE
*/
/obj/item/storage/box/gurgle_contaminate(var/atom/movable/item_storage = null)
	if((. = ..()))
		name = "soggy [cleanname]"
		desc = "This soggy box is about to fall apart any time."

//Storages that contaminate contents
/obj/item/storage/backpack/gurgle_contaminate(var/atom/movable/item_storage = null, var/contamination_flavor = "Generic", var/contamination_color = "green")
	if(contents)
		for(var/obj/item/O in contents)
			O.gurgle_contaminate(item_storage, contamination_flavor, contamination_color)
	..()

/obj/item/storage/belt/gurgle_contaminate(var/atom/movable/item_storage = null, var/contamination_flavor = "Generic", var/contamination_color = "green")
	if(contents)
		for(var/obj/item/O in contents)
			O.gurgle_contaminate(item_storage, contamination_flavor, contamination_color)
	..()

/obj/item/storage/belt/gurgle_contaminate(var/atom/movable/item_storage = null, var/contamination_flavor = "Generic", var/contamination_color = "green")
	if(contents)
		for(var/obj/item/O in contents)
			O.gurgle_contaminate(item_storage, contamination_flavor, contamination_color)
	..()

/*/obj/item/clothing/suit/storage/gurgle_contaminate(var/atom/movable/item_storage = null, var/contamination_flavor = "Generic", var/contamination_color = "green")
	if(pockets)
		if(pockets.contents)
			for(var/obj/item/O in pockets.contents)
				O.gurgle_contaminate(item_storage, contamination_flavor, contamination_color)
	..()*/

/obj/item/clothing/cloak/gurgle_contaminate(var/atom/movable/item_storage = null, var/contamination_flavor = "Generic", var/contamination_color = "green")
	if(contents)
		for(var/obj/item/O in contents)
			O.gurgle_contaminate(item_storage, contamination_flavor, contamination_color)
	..()

// OV Add Start: Add washing off gurgles
/*/obj/item/wash_act(clean = CLEAN_WEAK)
	. = ..()
	if(cleanname)
		name = cleanname
	if(cleandesc)
		desc = cleandesc
	if(gurgled)
		gurgled = FALSE
		cut_overlay(GLOB.gurgled_overlays[gurgled_color])*/
// OV Add End
