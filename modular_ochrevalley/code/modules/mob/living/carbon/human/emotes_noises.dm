/datum/emote/living/coo
	key = "coo"
	key_third_person = "coos!"
	message = "coos!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_coo()
	set name = "Coo"
	set category = "WT"
	emote("coo", intentional = TRUE, animal = TRUE)
