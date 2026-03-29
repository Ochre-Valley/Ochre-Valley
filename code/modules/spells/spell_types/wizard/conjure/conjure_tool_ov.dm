/obj/effect/proc_holder/spell/invoked/conjure_tool
	var/list/bad_tool_options = list(
		"Axe" = /obj/item/rogueweapon/stoneaxe,
		"Hammer" = /obj/item/rogueweapon/hammer/stone,
		"Knife" = /obj/item/rogueweapon/huntingknife/stoneknife,
		"Hoe" = /obj/item/rogueweapon/hoe/stone,
		"Fishing Rod" = /obj/item/fishingrod,
	)
	var/list/tool_selection

/obj/effect/proc_holder/spell/invoked/conjure_tool/Initialize()
	. = ..()
	tool_selection = tool_options //Because we can't do this statically, apparently?

/obj/effect/proc_holder/spell/invoked/conjure_tool/cast(list/targets, mob/living/user = usr)
	// Ochre Valley - Modified to add 'UNCONJURE.'
	var/list/choices = list()
	if(conjured_tool)
		choices["-- Unconjure Current Tool --"] = "UNCONJURE"
	for(var/name in tool_selection)
		choices[name] = tool_selection[name]
	var/selection = input(user, "Choose a tool", "Conjure Tool") as anything in choices
	if(!selection)
		return
	if(choices[selection] == "UNCONJURE")
		if(conjured_tool)
			conjured_tool.visible_message(span_warning("[conjured_tool] shimmers and fades away."))
			qdel(conjured_tool)
			conjured_tool = null
		return TRUE
	var/tool_path = choices[selection]
	if(conjured_tool)
		conjured_tool.visible_message(span_warning("[conjured_tool] shimmers and fades away."))
		qdel(conjured_tool)
		conjured_tool = null
	var/obj/item/R = new tool_path(user.drop_location())
	R.blade_dulling = DULLING_SHAFT_CONJURED
	// R.filters += filter(type = "drop_shadow", x=0, y=0, size=1, offset = 2, color = GLOW_COLOR_ARCANE)
	// R.smeltresult = null
	// R.salvage_result = null
	// R.fiber_salvage = FALSE
	// OV Edit; These are resolved in conjure_weapon calling conjured item dataum? I don't see a difference if there is one.
	if(!QDELETED(R))
		R.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE, user)
	user.put_in_hands(R)
	user.visible_message(span_warning("[R] forms in [user]'s hands!"))
	conjured_tool = R
	return TRUE

/obj/effect/proc_holder/spell/invoked/conjure_tool/mage/cast(list/targets, mob/living/user = usr)
	if(user.get_skill_level(/datum/skill/magic/arcane) < SKILL_LEVEL_JOURNEYMAN && !(HAS_TRAIT(user, TRAIT_ARCYNE_T2) || HAS_TRAIT(user, TRAIT_ARCYNE_T3) || HAS_TRAIT(user, TRAIT_ARCYNE_T4))) //Some magic classes only get apprentice arcane magic??
		tool_selection = bad_tool_options
	else
		tool_selection = tool_options //In case we leveled up since last using the spell
	return ..()

/obj/effect/proc_holder/spell/invoked/conjure_tool/Destroy()
	if(conjured_tool)
		conjured_tool.visible_message(span_warning("[conjured_tool]'s borders begin to shimmer and fade, before it vanishes entirely!"))
		qdel(conjured_tool)
		conjured_tool = null
	return ..()
