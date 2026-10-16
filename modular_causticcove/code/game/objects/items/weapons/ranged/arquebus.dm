/// AMMO BOX
/obj/item/ammo_box/magazine/internal/arquebus
	name = "arquebus internal magazine"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet
	caliber = "musketball"
	max_ammo = 1
	start_empty = TRUE

/// ITEMS

/obj/item/ramrod
	name = "arquebus ramrod" // OV edit - Looks like Azure might add a mortar with its own ramrod, and I don't want players confused. -Ace
	icon = 'modular_causticcove/icons/items/arquebus_items.dmi'
	desc = "A ramrod used for reloading a firearm."
	icon_state = "ramrod"
	item_state = "ramrod"
	slot_flags = SLOT_BELT_L | SLOT_BELT_R | ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_SMALL
	grid_height = 64
	grid_width = 32

/obj/item/powderflask
	name = "powderflask"
	icon = 'modular_causticcove/icons/items/arquebus_items.dmi'
	desc = "A flask of gunpowder used for reloading a firearm."
	icon_state = "powderflask"
	item_state = "powderflask"
	slot_flags = SLOT_BELT_L | SLOT_BELT_R | ITEM_SLOT_NECK | ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_SMALL
	grid_height = 64
	grid_width = 32

/obj/item/quiver/bulletpouch
	name = "arquebus bullet pouch"
	desc = "A pouch carrying bullets for firearms."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "slingpouch"
	item_state = "slingpouch"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_NECK
	max_storage = 20
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 64
	grid_width = 64 // OV Edit
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet //OV Add: Lets bullet pouches bullet

/obj/item/quiver/bulletpouch/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/bullet in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(bullet))
				break

/obj/item/quiver/bulletpouch/attack_right(mob/user)
	if(arrows.len)
		var/obj/O = arrows[arrows.len]
		arrows -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/quiver/bulletpouch/update_icon()
	return

/obj/item/quiver/bulletpouch/iron/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bullet/A = new()
		arrows += A
	update_icon()

/// MUZZLE

/obj/effect/particle_effect/sparks/muzzle
	name = "sparks"
	icon = 'icons/effects/64x64.dmi'
	icon_state = "sparks"
	anchored = TRUE
	light_system = MOVABLE_LIGHT
	light_power = 1.5
	light_color = LIGHT_COLOR_FIRE
	pixel_x = -16
	pixel_y = -16
	layer = ABOVE_LIGHTING_LAYER
	plane = ABOVE_LIGHTING_PLANE
