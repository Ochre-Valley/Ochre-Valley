/datum/sizecat/none
	name = "None"
	desc = "You are extraordinarily ordinary!"

/datum/sizecat/giant
	name = "Giant"
	desc = "I've always been larger, stronger and hardier than the average person. I tend to lumber around a lot, and my immense size can break down frail, wooden doors."
	added_traits = list(TRAIT_BIGGUY)
	custom_text = "Increases your sprite size."

/datum/sizecat/giant/apply_to_human(mob/living/carbon/human/recipient)
//	recipient.transform = recipient.transform.Scale(1.25, 1.25) //OV REMOVE - Determined by sprite scale now
//	recipient.transform = recipient.transform.Translate(0, (0.25 * 16)) //OV REMOVE
	recipient.update_transform()
	recipient.change_stat(STATKEY_STR, 1)
	recipient.change_stat(STATKEY_CON, 1)
	recipient.add_movespeed_modifier(MOVESPEED_ID_MACROMICRO, update=TRUE, priority=100, multiplicative_slowdown=0.2, movetypes=GROUND) //Go a little slower. Same as having 8 speed

/datum/sizecat/macro
	name =  "Macro"
	desc = "Somehow, due to a freak accident or magical energies, my form is absolutely colossal. My strength and body are second to none. However, the ground beneath shifts, causing my speed to suffer greatly."
	added_traits = list(TRAIT_MACRO)
	custom_text = "Greatly increases your sprite size. Makes you stronger and more durable but reduces your movement speed. Your speed stat remains unaffected."

/datum/sizecat/macro/apply_to_human(mob/living/carbon/human/recipient)
//	recipient.transform = recipient.transform.Scale(2, 2) //OV REMOVE
//	recipient.transform = recipient.transform.Translate(0, (0.25 * 35)) //OV REMOVE
	recipient.update_transform()
	recipient.change_stat(STATKEY_STR, 2)
	recipient.change_stat(STATKEY_CON, 2)
	// recipient.change_stat(STATKEY_SPD, -4) // Multiplicative slowdown should cover the move speed while still letting macros dodge.
	recipient.add_movespeed_modifier(MOVESPEED_ID_MACROMICRO, update=TRUE, priority=100, multiplicative_slowdown=0.5, movetypes=GROUND) // Base slowdown is increased to the equivalent of having 5 speed.

/datum/sizecat/small
	name = "Small"
	desc ="Somehow, due to a freak accident or magical energies, my form is below average in height.  My strength and body are impacted.  However, my smaller size allows me to better slip by others unnoticed."
	added_traits = list(TRAIT_SMALL)
	custom_text = "Reduces your sprite size.  Your stealth and agility is strengthened.  Your strength and durability will be lower than average."

/datum/sizecat/small/apply_to_human(mob/living/carbon/human/recipient)
//	recipient.transform = recipient.transform.Scale(0.75, 0.75) //OV REMOVE
//	recipient.transform = recipient.transform.Translate(0, (0.5 * -5)) //OV REMOVE
	recipient.update_transform()
	recipient.change_stat(STATKEY_STR, -2)
	recipient.change_stat(STATKEY_WIL, -2)
	recipient.change_stat(STATKEY_CON, -3)
	recipient.change_stat(STATKEY_SPD, 2)
	recipient.add_movespeed_modifier(MOVESPEED_ID_MACROMICRO, update=TRUE, priority=100, multiplicative_slowdown=0.3, movetypes=GROUND) //They're more agile, not faster. Smaller sprite, smaller clickbox. Speed the same as 9 speed base TOTAL.
	recipient.pass_flags = PASSTABLE | PASSMOB
	recipient.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
	recipient.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)

/datum/sizecat/micro
	name = "Micro"
	desc ="Somehow, due to a freak accident or magical energies, my form is absolutely tiny. My strength and body are lacking. However, my dimutive size allows me to greatly stay hidden, sometimes even in plain sight."
	added_traits = list(TRAIT_MICRO)
	custom_text = "Greatly reduces your sprite size. Your stealth and agility will be strengthened greatly, however your strength, durability, and movement speed will be reduced greatly."

/datum/sizecat/micro/apply_to_human(mob/living/carbon/human/recipient)
//	recipient.transform = recipient.transform.Scale(0.2, 0.2) //OV REMOVE
//	recipient.transform = recipient.transform.Translate(0, (0.25 * 8)) //OV REMOVE
	recipient.update_transform()
	recipient.change_stat(STATKEY_STR, -5) // Lets try keeping stat maluses to -5, and explore other options if this isnt enough for them.
	recipient.change_stat(STATKEY_WIL, -5)
	recipient.change_stat(STATKEY_CON, -5)
	recipient.change_stat(STATKEY_SPD, 5) // Multiplicative slowdown should cover the move speed while still letting micros dodge. Even at their fastest (which they should be with this modifier) they'll move as fast as a speed 0 character.
	recipient.add_movespeed_modifier(MOVESPEED_ID_MACROMICRO, update=TRUE, priority=100, multiplicative_slowdown=1.5, movetypes=GROUND) // Base slowdown is increased to the equivalent of having -5 speed. With the +5 speed added, it lowers it by .5 for a base total of 1
	recipient.pass_flags = PASSTABLE | PASSMOB
	recipient.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	recipient.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
