/datum/sizecat/macro
	name =  "Macro"
	desc = "Somehow, due to a freak accident or magical energies, my form is absolutely colossal. My strength and body are second to none. However, the ground beneath shifts, causing my speed to suffer greatly."
	custom_text = "Greatly increases your sprite size. Makes you stronger and more durable but reduces your movement speed. Your speed stat remains unaffected."
	starting_scale = 2

/datum/sizecat/macro/apply_to_living(mob/living/recipient)
	recipient.change_stat(STATKEY_STR, 2)
	recipient.change_stat(STATKEY_CON, 2)
	recipient.add_movespeed_modifier(MOVESPEED_ID_MACROMICRO, update=TRUE, priority=100, multiplicative_slowdown=0.5, movetypes=GROUND) // Base slowdown is increased to the equivalent of having 5 speed.
	ADD_TRAIT(recipient, TRAIT_BIGGUY, MAGIC_TRAIT)

/datum/sizecat/macro/remove_sizecat_from_living(mob/living/recipient)
	recipient.change_stat(STATKEY_STR, -2)
	recipient.change_stat(STATKEY_CON, -2)
	REMOVE_TRAIT(recipient, TRAIT_BIGGUY, MAGIC_TRAIT)

/datum/sizecat/large
	name = "Large"
	desc = "I've always been larger, stronger and hardier than the average person. I tend to lumber around a lot, and my immense size can break down frail, wooden doors."
	custom_text = "Increases your sprite size."
	starting_scale = 1.25

/datum/sizecat/large/apply_to_living(mob/living/recipient)
	recipient.change_stat(STATKEY_STR, 1)
	recipient.change_stat(STATKEY_CON, 1)
	recipient.add_movespeed_modifier(MOVESPEED_ID_MACROMICRO, update=TRUE, priority=100, multiplicative_slowdown=0.2, movetypes=GROUND) //Go a little slower. Same as having 8 speed
	ADD_TRAIT(recipient, TRAIT_BIGGUY, MAGIC_TRAIT)

/datum/sizecat/large/remove_sizecat_from_living(mob/living/recipient)
	recipient.change_stat(STATKEY_STR, -1)
	recipient.change_stat(STATKEY_CON, -1)
	REMOVE_TRAIT(recipient, TRAIT_BIGGUY, MAGIC_TRAIT)

/datum/sizecat/none
	name = "None"
	desc = "You are extraordinarily ordinary!"

/datum/sizecat/small
	name = "Small"
	desc ="Somehow, due to a freak accident or magical energies, my form is below average in height.  My strength and body are impacted.  However, my smaller size allows me to better slip by others unnoticed."
	custom_text = "Reduces your sprite size.  Your stealth and agility is strengthened.  Your strength and durability will be lower than average."
	starting_scale = 0.75

/datum/sizecat/small/apply_to_living(mob/living/recipient)
	recipient.change_stat(STATKEY_STR, -2)
	recipient.change_stat(STATKEY_WIL, -1)//OV Edit: Make the will drop of being small more palatable
	recipient.change_stat(STATKEY_CON, -3)
	recipient.change_stat(STATKEY_SPD, 2)
	recipient.add_movespeed_modifier(MOVESPEED_ID_MACROMICRO, update=TRUE, priority=100, multiplicative_slowdown=0.3, movetypes=GROUND) //They're more agile, not faster. Smaller sprite, smaller clickbox. Speed the same as 9 speed base TOTAL.
	
	passtable_on(recipient, MAGIC_TRAIT)
	recipient.pass_flags |= PASSMOB
	//recipient.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE) //Sadly might have to keep this gone to prevent weirdness from it being regularly applied and removed? Can't really reasonably remove this after it's been applied...
	//recipient.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)

/datum/sizecat/small/remove_sizecat_from_living(mob/living/recipient)
	recipient.change_stat(STATKEY_STR, 2)
	recipient.change_stat(STATKEY_WIL, 1)//OV Edit: Make the will drop of being small more palatable
	recipient.change_stat(STATKEY_CON, 3)
	recipient.change_stat(STATKEY_SPD, -2)

	passtable_off(recipient, MAGIC_TRAIT)
	recipient.pass_flags &= ~PASSMOB

/datum/sizecat/micro
	name = "Micro"
	desc ="Somehow, due to a freak accident or magical energies, my form is absolutely tiny. My strength and body are lacking. However, my dimutive size allows me to greatly stay hidden, sometimes even in plain sight."
	custom_text = "Greatly reduces your sprite size. Your stealth and agility will be strengthened greatly, however your strength, durability, and movement speed will be reduced greatly."
	starting_scale = 0.25

/datum/sizecat/micro/apply_to_living(mob/living/recipient)
	recipient.change_stat(STATKEY_STR, -5) // Lets try keeping stat maluses to -5, and explore other options if this isnt enough for them.
	recipient.change_stat(STATKEY_WIL, -2)//OV Edit: Make the will drop of being small more palatable
	recipient.change_stat(STATKEY_CON, -5)
	recipient.change_stat(STATKEY_SPD, 5) // Multiplicative slowdown should cover the move speed while still letting micros dodge. Even at their fastest (which they should be with this modifier) they'll move as fast as a speed 0 character.
	recipient.add_movespeed_modifier(MOVESPEED_ID_MACROMICRO, update=TRUE, priority=100, multiplicative_slowdown=1.2, movetypes=GROUND) //OV Edit: Some movespeed, as a treat. - Base slowdown is increased to the equivalent of having -5 speed. With the +5 speed added, it lowers it by .5 for a base total of 1
	
	passtable_on(recipient, MAGIC_TRAIT)
	recipient.pass_flags |= PASSMOB
	//recipient.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	//recipient.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)

/datum/sizecat/micro/remove_sizecat_from_living(mob/living/recipient)
	recipient.change_stat(STATKEY_STR, 5)
	recipient.change_stat(STATKEY_WIL, 2)//OV Edit: Make the will drop of being small more palatable
	recipient.change_stat(STATKEY_CON, 5)
	recipient.change_stat(STATKEY_SPD, -5)

	passtable_off(recipient, MAGIC_TRAIT)
	recipient.pass_flags &= ~PASSMOB
