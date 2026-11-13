/datum/action/cooldown/spell/mercenary_statusupdate
	name = "Update Mercenary Status"
	desc = "Update your status at the mercenary statue. Cycles through Available, Contracted, and Do Not Disturb in that order."
	button_icon_state = "book1"

	click_to_activate = FALSE
	self_cast_possible = TRUE

	charge_required = FALSE
	cooldown_time = 2 SECONDS //give the game some time to process it

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


// Not actually a virtue, but kept in the category for convenience.
/mob/living/carbon/human/proc/mercenary_statusupdate()
	set name = "Update Mercenary Status"
	set category = "RoleUnique.Virtue"
	set desc = "Update your status at the mercenary statue. Cycles through Available, Contracted, and Do Not Disturb in that order."
	SSroguemachine.mercenary_statue.cycle_mercenary_status(src)
