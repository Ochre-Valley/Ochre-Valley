/datum/action/cooldown/spell/conjure_summon/servant
	name = "Summon Servant"
	desc = "Call forth a bound humanoid servant to aid you. The servant may take on a myriad of forms, but is quite useless at near any task. (This is meant as a scene tool, do not use them as cheap meat shields or some other nonsense!)"
	button_icon_state = "primetriangle"
	invocations = list("Exsurge, serve!")
	summon_noun = "champion"
	recoil_energy_floor = 200
	modes = list(
			list("name" = "Servant", "tag" = "SRV", "loadout" = "servant", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, serve!"), //OV Edit: Add servant summon
	)
	var/spellsgranted = FALSE


/datum/action/cooldown/spell/conjure_summon/servant/spawn_summon(turf/T, mob/living/user)
	var/mob/living/carbon/human/species/human/northern/conjured_champion/champion = new(T)
	champion.loadout = modes[current_mode]["loadout"]
	champion.arcane_scale = clamp(user.get_skill_level(/datum/skill/combat/arcyne), 1, 6)
	champion.gear_tier = get_summon_tier(user)
	champion.summoner_ref = WEAKREF(user)
	if(!spellsgranted)
		user.mind.AddSpell(new /datum/action/cooldown/spell/conjure_projection, user)
		user.mind.AddSpell(new /datum/action/cooldown/spell/minion_order/conjurer, user)
		user.mind.AddSpell(new /datum/action/cooldown/spell/conjure_dismiss, user)
		spellsgranted = TRUE
	return champion


/obj/item/book/granter/spell/bonechill/servant
	name = "Scroll of Conjure Servant"
	spell = /datum/action/cooldown/spell/conjure_summon/servant
	spellname = "Conjure Servant"
	icon_state ="scrolldarkred"
	oneuse = TRUE
	remarks = list()

/obj/item/book/granter/spell/bonechill/servant/loadout
	needLit = FALSE
	pages_to_mastery = 0 //OV Edit: reads faster

/datum/loadout_item/servantspell //I'd have this even further up the list if I could, but I don't want to needlessly edit the Azure loadouts
	name = "Scroll of Conjure Servant"
	path = /obj/item/book/granter/spell/bonechill/servant/loadout
