/obj/item/rogueweapon/mace/donator_flybrokenwings_parasol/ochre
	name = "pale cap parasol"
	icon_state = "parasol_skikuldic_ov"
	item_state = "parasol_skikuldic_ov"
	icon = 'modular_ochrevalley/icons/obj/items/donor_weapons_64.dmi'

/obj/item/clothing/neck/roguetown/psicross/kerse
	name = "enduring psycross"
	icon_state = "psicrossblood"
	icon = 'modular_ochrevalley/icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'modular_ochrevalley/icons/roguetown/clothing/onmob/neck.dmi'
	desc = "'Let His name be naught but forgot. The alloy is familiar, aged and bare, but no word can be sired to describe it. The cracks have finally coagulated; The stains of blood remain, a reminder of all you have experienced. Make something of this decaying world, Child of Psydon. Be certain the Archdevil weeps.'"

/obj/item/clothing/neck/roguetown/psicross/kerse/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(slot == SLOT_WRISTS || (wrist_display && slot != SLOT_NECK))
		mob_overlay_icon = 'modular_ochrevalley/icons/roguetown/clothing/onmob/wrists.dmi'
		sleeved = 'modular_ochrevalley/icons/roguetown/clothing/onmob/wrists.dmi'
	else
		mob_overlay_icon = initial(mob_overlay_icon)
		sleeved = initial(sleeved)

	return ..()

/obj/item/clothing/neck/roguetown/psicross/kerse/attack_right(mob/user)
	if(!ismob(loc))
		return ..()

	wrist_display = !wrist_display
	to_chat(user, span_info("You adjust \the [src] to [wrist_display ? "display on your wrists" : "display around your neck"]."))
	if(wrist_display)
		mob_overlay_icon = 'modular_ochrevalley/icons/roguetown/clothing/onmob/wrists.dmi'
		sleeved = 'modular_ochrevalley/icons/roguetown/clothing/onmob/wrists.dmi'
	else
		mob_overlay_icon = initial(mob_overlay_icon)
		sleeved = initial(sleeved)

	if(isliving(loc))
		var/mob/living/L = loc
		L.regenerate_clothes()
	return ..()
