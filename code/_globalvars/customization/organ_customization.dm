//Caustic Edit
GLOBAL_LIST_INIT(named_penis_sizes, list(
	"small" = 1,
	"average" = 2,
	"large" = 3,
	"extra-large" = 4,
	"massive" = 5,
	"enormous" = 6,
	"baothan" = 7,
))

GLOBAL_LIST_INIT(named_ball_sizes, list(
	"small" = 1,
	"average" = 2,
	"large" = 3,
	"extra-large" = 4,
	"massive" = 5,
	"enormous" = 6,
	"huge" = 7,
	"baothan" = 8,
))

GLOBAL_LIST_INIT(named_breast_sizes, list(
	"flat" = 0,
	"very small" = 1,
	"small" = 2,
	"normal" = 3,
	"large" = 4,
	"enormous" = 5,
	"towering" = 6,
	"huge" = 7,
	"gargantuan" = 8,
	"colossal" = 9,
	"ungodly big" = 10,
	"gigantic" = 11,
	"titanic" = 12,
	"obscenely large" = 13,
	"over-endowed" = 14,
	"unholy" = 15,
	"baothan" = 16,
	"extra baothan" = 17,
	"over-baothan" = 18,
	"downright incredible" = 19,
))
//Caustic End
GLOBAL_LIST_INIT(customizer_choices, build_customizer_choices())
GLOBAL_LIST_INIT(customizers, build_customizers())

/proc/build_customizer_choices()
	. = list()
	for(var/type in typesof(/datum/customizer_choice))
		if(is_abstract(type))
			continue
		.[type] = new type()
	return .

/proc/build_customizers()
	. = list()
	for(var/type in typesof(/datum/customizer))
		if(is_abstract(type))
			continue
		.[type] = new type()
	return .

/proc/color_pick_sanitized(mob/user, description, title, default_value)
	var/color = input(user, description, title, default_value) as color|null
	if(!color)
		return
	color = sanitize_hexcolor(color)

	return color
