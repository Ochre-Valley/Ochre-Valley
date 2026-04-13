// Micro Holders - Extends /obj/item/holder
/obj/item/holder/micro
	name = "micro"
	desc = "Another crewmember, small enough to fit in your hand."
	icon_state = "micro"
	//icon_override = 'icons/inventory/head/mob.dmi' //Caustic - We'd need new sprites for these, possibly.
	slot_flags = ITEM_SLOT_SHOES|ITEM_SLOT_HEAD|ITEM_SLOT_HIP|ITEM_SLOT_BACK_L|ITEM_SLOT_BACK_R|ITEM_SLOT_MOUTH //OV EDIT - Adds ability to put micros in the mouth slot
	w_class = WEIGHT_CLASS_SMALL
	lefthand_file = null // No in-hand sprites (for now, anyway, we could totally add some)
	righthand_file = null
	pixel_y = 0		  // Override value from parent.

/*/obj/item/holder/micro/Initialize(mapload, mob/held) //This might not be needed, it was for handling Teshari before on Chomp
	. = ..()
	var/mob/living/carbon/human/H = held_mob

/obj/item/holder/micro/make_worn_icon(var/body_type,var/slot_name,var/inhands,var/default_icon,var/default_layer,var/icon/clip_mask = null) //Might not be needed at all? Just, whenever we figure how to render worn players...
	var/mob/living/carbon/human/H = held_mob
	. = ..()*/

/obj/item/holder/examine(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	. = list()
	for(var/mob/living/M in contents)
		. += M.examine(user)

/obj/item/holder/MouseDrop(mob/M)
	..()
	if(M != usr) return
	if(usr == src) return
	if(!Adjacent(usr)) return
	for(var/mob/living/carbon/human/O in contents)
		O.show_inv(usr)

/obj/item/holder/micro/attack_self(mob/living/carbon/user) //reworked so it works w/ nonhumans
	. = ..(user)
	if(.)
		return TRUE
	user.setClickCooldown(CLICK_CD_MELEE)
	for(var/L in contents)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.help_shake_act(user)
		if(isanimal(L))
			var/mob/living/simple_animal/S = L
			user.visible_message(span_notice("[user] [S.response_help_continuous] \the [S]."))

//Egg features.
/obj/item/holder/attack_hand(mob/living/user as mob)
	if(istype(src.loc, /obj/item/storage/vore_egg)) //Don't scoop up the egged mob
		src.pickup(user)
		user.dropItemToGround(src)
		return
	..()

/obj/item/holder/container_resist(mob/living/held)
	if(!istype(src.loc, /obj/item/storage/vore_egg))
		..()
	else
		var/obj/item/storage/vore_egg/E = src.loc
		if(isbelly(E.loc))
			var/obj/belly/B = E.loc
			B.relay_resist(held, E)
			return
		E.hatch(held)
		return
