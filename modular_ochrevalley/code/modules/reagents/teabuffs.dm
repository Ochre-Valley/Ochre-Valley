/datum/status_effect/buff/tea/perceptiontea
	id = "pertea"
	alert_type = /atom/movable/screen/alert/status_effect/buff/tea/per
	effectedstats = list(STATKEY_PER = 1)
	duration = 3 SECONDS

/datum/status_effect/buff/tea/constitutiontea
	id = "contea"
	alert_type = /atom/movable/screen/alert/status_effect/buff/tea/con
	effectedstats = list(STATKEY_CON = 1)
	duration = 3 SECONDS

/datum/status_effect/buff/tea/willpowertea
	id = "wiltea"
	alert_type = /atom/movable/screen/alert/status_effect/buff/tea/wil
	effectedstats = list(STATKEY_WIL = 1)
	duration = 3 SECONDS

/datum/status_effect/buff/tea/intellegencetea
	id = "inttea"
	alert_type = /atom/movable/screen/alert/status_effect/buff/tea/int
	effectedstats = list(STATKEY_INT = 1)
	duration = 3 SECONDS

/datum/status_effect/debuff/tea/baothaforget
	id = "baothaforget"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/baothaforget
	effectedstats = list(STATKEY_INT = -5)
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/buff/tea
	desc = "An herbal brew fortifies your body."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/debuff/baothaforget
	name = "Scorned indulgence"
	desc = "Your memory and wit fails you, the current moment seems all that matters"
	icon_state = "debuff"

/atom/movable/screen/alert/status_effect/buff/tea/per
	name = STATKEY_PER

/atom/movable/screen/alert/status_effect/buff/tea/con
	name = STATKEY_CON

/atom/movable/screen/alert/status_effect/buff/tea/wil
	name = STATKEY_WIL

/atom/movable/screen/alert/status_effect/buff/tea/int
	name = STATKEY_INT
