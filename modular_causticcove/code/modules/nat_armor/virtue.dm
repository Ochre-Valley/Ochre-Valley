/* OV EDIT - Disabled
/datum/virtue/combat/natarmor
	name = "Natural Armor"
	desc = "My hide is thick and resilient, enhancing my natural defense whilst making armor meerly vanity on my body. \
	\n It will regenerate so long as I keep it fed... "
	added_traits = list()
	custom_text = "Provides you with a special, regenerative armor piece that is capable of regenerating at the cost of your hunger that covers your entire body. \
	\n NOTE: OVRRIDES ANY WORN ARMOR ON THE BODY, WORN ARMOR WEIGHT CLASS STILL APPLIES DEBUFFS. "

/datum/virtue/combat/natarmor/apply_to_human(mob/living/carbon/human/recipient)
	recipient.skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/natural_armor(recipient)
*/
