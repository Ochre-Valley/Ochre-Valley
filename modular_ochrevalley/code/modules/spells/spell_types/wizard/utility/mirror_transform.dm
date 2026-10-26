/datum/action/cooldown/spell/mirror_transform_ov
	name = "Mirror Transform"
	desc = "Temporarily grants you the ability to use mirrors to change your appearance."
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "mirror"
	sound = 'sound/magic/whiteflame.ogg'

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Effingo")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 1
	charge_slowdown = 3
	charge_sound = null
	cooldown_time = 300 SECONDS

	associated_skill = /datum/skill/magic/arcane
	point_cost = 0
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	var/obj/item/conjured_tool = null

/obj/item/handmirror/magic
	name = "arcyne hand mirror"
	desc = "Its surface glimmers and warps with arcyne magicks, reflections everchanging."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "handmirror"
	grid_width = 32
	grid_height = 64
	dropshrink = 0.8
	var/created
	var/hasWarned
	var/warnduration = 3 MINUTES
	var/duration = 5 MINUTES
	var/datum/appearance_changer/mirror_transform/M

/obj/item/handmirror/magic/Initialize()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(start_breaking)))
	created = world.time
	hasWarned = FALSE
	. = ..()

/obj/item/handmirror/magic/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(M)
	. = ..()
/obj/item/handmirror/magic/proc/start_breaking()
	START_PROCESSING(SSobj, src)

/obj/item/handmirror/magic/process()
	if(!hasWarned && created + warnduration < world.time)
		src.visible_message("<span class='info'>Cracks begin to form in the arcyne mirror!</span>")
		hasWarned = TRUE
	if(created + duration < world.time)
		playsound(loc, 'sound/spellbooks/crystal.ogg', 100, TRUE)
		src.visible_message("<span class='info'>The arcyne mirror shatters into dust and sparks!</span>")
		qdel(src)
	..()

/datum/action/cooldown/spell/mirror_transform_ov/cast(list/targets, mob/living/user = usr)
	. = ..()
	if(src.conjured_tool)
		qdel(src.conjured_tool)
		src.conjured_tool = null

	var/obj/item/R = new /obj/item/handmirror/magic
	R.filters += filter(type = "drop_shadow", x=0, y=0, size=1, offset = 2, color = GLOW_COLOR_ARCANE)
	R.smeltresult = null
	R.salvage_result = null
	R.fiber_salvage = FALSE
	user.put_in_hands(R)
	src.conjured_tool = R

/obj/item/handmirror/magic/attack_self(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	M = new(H)
	to_chat(H, span_info("You tilt your jaw from side to side, concentrating on the glamoring magicks limning your form..."))
	if(do_after(H, 3 SECONDS))
		M.ui_interact(H)

