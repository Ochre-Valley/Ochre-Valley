/datum/action/cooldown/spell/mercenary_statusupdate
	name = "Update Mercenary status"
	desc = "Update your status at the mercenary statue. Cycles through Available, Contracted, and Do Not Disturb in that order."
	button_icon_state = "book1"

	click_to_activate = FALSE
	self_cast_possible = TRUE

	charge_required = FALSE
	cooldown_time = 5 SECONDS //give the game some time to process it

	primary_resource_type = SPELL_COST_NONE

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/mercenary_statusupdate/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user) || !user.mind)
		return FALSE
	SSroguemachine.mercenary_statue.cycle_mercenary_status(user)
	return TRUE
