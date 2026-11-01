//Using this so we don't need to touch upstream defines.
#define ASPECT_NAME_AEROMANCY "Winds"
#define GLOW_COLOR_WIND "#8CDD8C"

/datum/magic_aspect/aeromancy
	name = "Aeromancy"
	latin_name = "Maior Aspectus Venti"
	desc = "A first-order school focused on wielding the air itself as a weapon. \
			Utilizing arcyne force, Magi practicing Aeromancy conjure and shape vicious vicious winds to lacerate and devastate their foes. \
			Historically, Aeromancy has its roots spread far across the eastern reaches of Psydonia, from the deserts of Raneshen to the grass sea of Lingyue — now mainland Kazengun."
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_AEROMANCY
	school_color = GLOW_COLOR_WIND
	binding_chants = list(
		"Invoco aeternos ventos!",
		"I call upon the winds from on high, descend!",
		"Aero, in me ligare!"
	)
	unbinding_chants = list(
		"Solvo ventos vinctam!",
		"I release the winds that ravage without, be calm.",
		"Aero, a me discede!"
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/wind_blade,
		/datum/action/cooldown/spell/projectile/windblade_volley,
		/datum/action/cooldown/spell/tempest,
		/datum/action/cooldown/spell/tailwind,
		/datum/action/cooldown/spell/squall,
		/datum/action/cooldown/spell/levitation,
		/datum/action/cooldown/spell/featherfall,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE = /datum/action/cooldown/spell/cyclone,
		),
	)
