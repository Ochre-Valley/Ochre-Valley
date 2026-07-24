/mob/living/carbon/human/verb/toggle_taur_clothing()
	set name = "Toggle Taur Clothing"
	set desc = "Show or hide clothing appearing over taur bodies."
	set category = "IC"

	allow_taur_clothing = !allow_taur_clothing
	if(allow_taur_clothing)
		to_chat(src, "Some clothing will now show on your taur body.")
	else
		to_chat(src, "Clothing will no longer appear over your taur body.")
