/////////////////////////////////////////////////////////////////////////////////////////////
// Wolf modular verb time : Added by Ochre Valley // OV	Edit							   //
// Add your verb here and then add it to the list at werewolf.dm : var/list/werewolf_verbs //
// Hopefully this is self explanatory of how to handle things.							   //
/////////////////////////////////////////////////////////////////////////////////////////////

/proc/parse_spoilers(text) // Free to use. Added here because werewolfs are a bit more of a basic examine system. But I *do* want it so people can be expressive, even if its explicit or otherwise.
	if(!text)
		return text
	var/regex/R = new(@"\|\|(.+?)\|\|", "g")
	while(R.Find(text))
		var/match = R.group[1]
		var/replacement = "<span class='spoiler'>[match]</span>"
		text = copytext(text, 1, R.index) + replacement + copytext(text, R.next)
	return text

/mob/living/carbon/human/proc/werewolf_changename()
	set name = "Change Wolf Name"
	set category = "WEREWOLF"

	if(!mind)
		return FALSE
	var/datum/antagonist/werewolf/W = mind.has_antag_datum(/datum/antagonist/werewolf)
	if(!W)
		return FALSE
	if(stat >= UNCONSCIOUS)
		return FALSE
	if(W.allow_rename)
		var/newname = input(src, "Choose your wolf name. Limit: [WEREWOLF_MAXNAMEL_LIMIT] characters.", "Wolf Name", W.wolfname) as text|null
		if(!newname)
			return FALSE
		newname = sanitize_name(newname)
		if(!length(newname))
			return FALSE
		if(length(newname) > WEREWOLF_MAXNAMEL_LIMIT)
			to_chat(src, span_notice("Your wolf name is too long. We'll repeat it back here for you to modify: [newname]\nYour wolf name is too long. We'll repeat it back here for you to modify."))
			return FALSE
		W.wolfname = newname
		src.werewolf_setname = newname
		W.allow_rename = TRUE
		if(istype(src, /mob/living/carbon/human/species/werewolf)) // If currently transformed, update the active mob
			src.real_name = newname
			src.name = newname
		to_chat(src, span_notice("Your wolf name is now [newname]."))
		return TRUE
	else
		to_chat(src, span_warning("Not allowed to rename! Currently: [W.wolfname]  If there is a mistake, ahelp and ask an admin to set your character's mind > Werewolf antag datum > 'allow_rename' var back to TRUE or 1!"))
		return FALSE

/mob/living/carbon/human/proc/werewolf_changedesc()
	set name = "Change Wolf Description"
	set category = "WEREWOLF"

	if(!mind)
		return FALSE
	var/datum/antagonist/werewolf/W = mind.has_antag_datum(/datum/antagonist/werewolf)
	if(!W)
		return FALSE
	if(stat >= UNCONSCIOUS)
		return FALSE
	var/inputteddesc = input(src, "Choose your wolf description. Limit: [WEREWOLF_MAXDESCL_LIMIT] characters.", "Wolf Description", W.wolfdesc) as message|null
	if(!inputteddesc)
		return FALSE
	inputteddesc = trim(inputteddesc)
	if(!length(inputteddesc))
		return FALSE
	if(length(inputteddesc) > WEREWOLF_MAXDESCL_LIMIT)
		to_chat(src, span_notice("Your wolf description is too long."))
		return FALSE
	W.wolfdesc = inputteddesc
	var/rendered = html_encode(inputteddesc)
	rendered = parse_spoilers(rendered)
	rendered = parsemarkdown_basic(rendered, limited = TRUE, barebones = TRUE)
	W.wolfdesc_cached = rendered
	to_chat(src, span_notice("Your new wolf description is set."))
	return TRUE
