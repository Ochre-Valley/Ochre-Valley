/mob/living/carbon/human/species/hobgoblin/npc
	aggressive=1
	mode = NPC_AI_IDLE
	dodgetime = 20 //Bigger, Better, dodges every 2 seconds
	flee_in_pain = FALSE //GOBBY NO LIKE PAIN BUT ME BIG HOBBY WE NO HATE PAIN!!! (They're stronger.)
	npc_jump_chance = 40 //Not as nimble, less jumping...
	npc_jump_distance = 4 //But further distance by 1 tile compared to goblins.
	rude = TRUE
	wander = FALSE

	//smart_combatant = TRUE

	//Can use special attacks, but cannot parry or feint our foe.
	special_attacker = TRUE

/mob/living/carbon/human/species/hobgoblin/npc/ambush
	ambush_faction = "goblins"
	wander = TRUE
	//attack_speed = 1 //Unused var from npc AI? If it gets used in the future uncomment this.
