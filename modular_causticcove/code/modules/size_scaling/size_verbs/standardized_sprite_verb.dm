/mob/verb/standardsprite()
	set name = "Standardize sprite"
	set category = "Vore.Misc" // OV Edit
	set desc = "Standardizes your sprite to 100%. ONLY FOR YOURSELF!"
	if(isliving(src))
		var/mob/living/curruser = src
		curruser.standardize_sprite()

/mob/living
	var/currentlystandardized = FALSE

/mob/living/proc/standardize_sprite()
	if(!currentlystandardized)
		var/image/I = image(icon = src.icon, icon_state = src.icon_state, loc = src, layer = src.layer, pixel_x = src.pixel_x, pixel_y = src.pixel_y)
		I.override = TRUE
		I.overlays += overlays
		add_alt_appearance(/datum/atom_hud/alternate_appearance/basic, "smallsprite_sizecode", I)
	else
		remove_alt_appearance("smallsprite_sizecode")

	currentlystandardized = !currentlystandardized
	
/mob/living/proc/refresh_standardized_sprite()
	remove_alt_appearance("smallsprite_sizecode")
	var/image/I = image(icon = src.icon, icon_state = src.icon_state, loc = src, layer = src.layer, pixel_x = src.pixel_x, pixel_y = src.pixel_y)
	I.override = TRUE
	I.overlays += overlays
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic, "smallsprite_sizecode", I)

