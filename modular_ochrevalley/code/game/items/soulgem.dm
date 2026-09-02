/obj/item/soulgem
	name = "luxseal gem"
	desc = "A strange arcyne gem, designed to entrap the lux and spirit of a target within itself, leaving the body behind."
	icon = 'icons/roguetown/items/gems.dmi'
	icon_state = "necro_crystal_dormant"
	drop_sound = 'modular_ochrevalley/sounds/capture_crystal/drop_ring.ogg'
	pickup_sound = 'modular_ochrevalley/sounds/capture_crystal/pickup_ring.ogg'
	throwforce = 0
	force = 0
	w_class = WEIGHT_CLASS_TINY

	var/datum/weakref/body_tracker
	var/mob/living/carbon/human/trapped
	var/originalDead = FALSE
/obj/item/soulgem/examine()
	. = ..()
	if(trapped)
		. += "</br><span class='notice'>Upon closer examination, the presence of [trapped] can be seen within the crystal.</span>"

/obj/item/soulgem/attack(mob/living/M, mob/living/user)
	if(trapped && body_tracker.resolve() == M)
		if(tgui_alert(user, "Release the [trapped] back into their body?", "Release Lux",list("No","Yes")) == "Yes")
			var/datum/beam/transfer_beam = M.Beam(user, icon_state = "drain_life", time = 5 SECONDS)
			user.visible_message(span_warning("The light within [src] begins to fade, filtering back into [M]"), vision_distance = 1)
			if(!do_after(user, 5 SECONDS, target = M))
				qdel(transfer_beam)
				return
			user.visible_message(span_warning("[src]'s ominous light fades, as [M] begins to stir..."), vision_distance = 1)
			UnregisterSignal(M, COMSIG_MOB_DIGESTION_DEATH)
			clear_gem()
			set_icon(FALSE)
	else if(ishuman(M) && !trapped)
		var/mob/living/carbon/human/H = M
		if(tgui_alert(M, "Are you certain you'd like your lux trapped by [user]? You will be unable to return to your body by yourself without OOC escape", "Become Entrapped",list("No","Yes")) == "Yes")
			user.visible_message(span_warning("[user]'s [src] begins drawing in [H]'s lyfeforce..."), span_warning("The [src] begins to siphon [H]'s lux into itself..."), vision_distance = 1)
			var/datum/beam/transfer_beam = user.Beam(H, icon_state = "drain_life", time = 5 SECONDS)
			if(!do_after(user, 5 SECONDS, target = H))
				qdel(transfer_beam)
				return
			user.visible_message(span_warning("[user]'s [src] glows ominously as [H] falls still."), span_warning("The [src] glows brilliantly as [H]'s lux fills it"), vision_distance = 1)
			log_admin("[key_name(M)] has had their lux trapped by [key_name(user)].")
			body_tracker = WEAKREF(M)
			trapped = new /mob/living/carbon/human(src)
			copy_to_trapped(H)
			VORE_PREF_TRANSFER(trapped, H) //So prefs properly transfer over
			trapped.key = H.key
			RegisterSignal(H, COMSIG_MOB_DIGESTION_DEATH, PROC_REF(handle_vore_death))
			set_icon(TRUE)
			H.set_resting(TRUE, FALSE)
			H.eyesclosed = 1
			if(M == user) //Drop the crystal if we trapped ourselves
				user.dropItemToGround(src)

/obj/item/soulgem/pickup(mob/user)
	if(user == trapped)
		return
	. = ..()

/obj/item/soulgem/proc/clear_gem()
	var/mob/living/carbon/human/H = body_tracker.resolve()
	if(H && trapped)
		H.key = trapped.key
		qdel(trapped)
		body_tracker = null
		originalDead = FALSE

/obj/item/soulgem/proc/handle_vore_death()
	to_chat(trapped, span_warning("I feel my link to my body weaken..."))
	originalDead = TRUE

/obj/item/soulgem/proc/copy_to_trapped(mob/living/carbon/human/source)
	var/list/items_to_copy = source.get_equipped_items(TRUE)
	trapped.copy_physical_features(source)
	for(var/obj/item/I in items_to_copy)
		var/obj/item/copy = new I.type()
		
		// Check each possible slot
		if(source.head == I)
			trapped.equip_to_slot_or_del(copy, SLOT_HEAD)
		else if(source.wear_mask == I)
			trapped.equip_to_slot_or_del(copy, SLOT_WEAR_MASK)
		else if(source.wear_neck == I)
			trapped.equip_to_slot_or_del(copy, SLOT_NECK)
		else if(source.back == I)
			trapped.equip_to_slot_or_del(copy, SLOT_BACK)
		else if(source.wear_armor == I)
			trapped.equip_to_slot_or_del(copy, SLOT_ARMOR)
		else if(source.wear_shirt == I)
			trapped.equip_to_slot_or_del(copy, SLOT_SHIRT)
		else if(source.wear_pants == I)
			trapped.equip_to_slot_or_del(copy, SLOT_PANTS)
		else if(source.belt == I)
			trapped.equip_to_slot_or_del(copy, SLOT_BELT)
		else if(source.beltl == I)
			trapped.equip_to_slot_or_del(copy, SLOT_BELT_L)
		else if(source.beltr == I)
			trapped.equip_to_slot_or_del(copy, SLOT_BELT_R)
		else if(source.gloves == I)
			trapped.equip_to_slot_or_del(copy, SLOT_GLOVES)
		else if(source.shoes == I)
			trapped.equip_to_slot_or_del(copy, SLOT_SHOES)
		else if(source.cloak == I)
			trapped.equip_to_slot_or_del(copy, SLOT_CLOAK)
		else if(source.backr == I)
			trapped.equip_to_slot_or_del(copy, SLOT_BACK_R)
		else if(source.backl == I)
			trapped.equip_to_slot_or_del(copy, SLOT_BACK_L)

/obj/item/soulgem/Del()
	if(body_tracker && trapped)
		var/mob/living/carbon/human/H = body_tracker.resolve()
		if(H)
			H.key = trapped.key
			if(originalDead) //Handle vore death stuff in post
				var/mob/dead/observer/G = H.ghostize(TRUE)
				if(G)
					G.forceMove(loc)
					G.vore_death = TRUE
		else
			log_and_message_admins("was trapped in a soulgem and had their body destroyed, freeing trapped copy.", trapped)
			trapped.forceMove(loc)

//Helper function so the effigy can use the same code.
/obj/item/soulgem/proc/set_icon(filled)
	if(filled)
		icon_state = "necro_crystal"
	else
		icon_state = "necro_crystal_dormant"

/obj/item/soulgem/effigy
	name = "luxseal effigy"
	desc = "A strange doll, designed to entrap one's lux and take on their appearance."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainstatueraw"

/obj/item/soulgem/effigy/examine()
	. = ..()
	if(trapped)
		. += "</br><span class='notice'>The effigy bears a striking resemblance to [trapped].</span>"

/obj/item/soulgem/effigy/set_icon(filled)
	if(!trapped)
		return
	if(filled)
		trapped.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
		vis_contents += trapped
		icon_state = null
	else
		vis_contents -= trapped
		icon_state = "clayporcelainstatueraw"

/datum/crafting_recipe/roguetown/arcana/soulgem
	name = "luxseal gem"
	result = /obj/item/soulgem
	reqs = list(/obj/item/roguegem/amethyst = 1,
				/obj/item/magic/infernal/ash = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/soulgemeffigy
	name = "luxseal effigy"
	result = /obj/item/soulgem/effigy
	reqs = list(/obj/item/natural/clay = 1,
				/obj/item/roguegem/amethyst = 1,
				/obj/item/magic/infernal/ash = 2)
	craftdiff = 2
