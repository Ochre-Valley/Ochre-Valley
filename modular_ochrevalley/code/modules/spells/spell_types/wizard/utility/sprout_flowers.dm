/datum/action/cooldown/spell/sprout_flowers
	button_icon = 'icons/roguetown/gems/gem_rose.dmi'
	name = "Conjure Minor Flora"
	desc = "Creates a small patch of flowers at a targeted location. The color of the flowers can be toggled via the alt mode button."
	button_icon_state = "flower_rose"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_BARDIC
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Flores Germinare Magicae.")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 0

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_NO_MOVE | SPELL_REQUIRES_SAME_Z
	var/current_mode = 1
	var/list/modes = list(
		list("name" = "Lavender", "tag" = "LAV"),
		list("name" = "Yellow", "tag" = "YEL"),
		list("name" = "Blue-Red", "tag" = "BLRD"),
		list("name" = "Pink-Purple", "tag" = "PKPR"),
	)
	var/static/list/turf_whitelist = list(
		/turf/open/floor/rogue/grass,
		/turf/open/floor/rogue/grassyel,
		/turf/open/floor/rogue/grassred,
		/turf/open/floor/rogue/grasscold,
		/turf/open/floor/rogue/dirt,
		/turf/open/floor/rogue/snow,
		/turf/open/floor/rogue/snowpatchy,
		/turf/open/floor/rogue/snowrough,
		)

/datum/action/cooldown/spell/conjure_summon/Grant(mob/grant_to)
	. = ..()
	update_mode_maptext()

/datum/action/cooldown/spell/sprout_flowers/toggle_alt_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	update_mode_maptext()
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]]."))
	return TRUE

/datum/action/cooldown/spell/sprout_flowers/proc/update_mode_maptext()
	if(!length(modes))
		return
	var/list/mode = modes[current_mode]
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(mode["tag"])
		holder.maptext_x = 5
		holder.color = "#E8837C"

/datum/action/cooldown/spell/sprout_flowers/cast(atom/cast_on)
	. = ..()
	var/turf/target = get_turf(cast_on)

	if(!target || !target.Enter(owner) || !is_type_in_list(target, turf_whitelist))
		to_chat(owner, span_warning("This turf is inhospitable to flora."))
		return FALSE
	
	switch(modes[current_mode]["name"])
		if("Yellow")
			new /obj/structure/flora/ausbushes/ywflowers(target)
		if("Blue-Red")
			new /obj/structure/flora/ausbushes/brflowers(target)
		if("Pink-Purple")
			new /obj/structure/flora/ausbushes/ppflowers(target)
		else
			new /obj/structure/flora/ausbushes/lavendergrass(target)
	return TRUE
