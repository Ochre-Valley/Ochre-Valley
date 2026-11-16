/datum/component/decal/contamination
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/flavor
	var/color

/datum/component/decal/contamination/Initialize(_icon, _icon_state, _dir, _cleanable=CLEAN_WEAK, _color="green", _layer=ABOVE_OBJ_LAYER, _description, _alpha, _flavor="Generic")
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	
	flavor = lowertext(_flavor)
	color = _color

	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_GET_EXAMINE_NAME, PROC_REF(get_examine_name))

/datum/component/decal/contamination/generate_appearance(_icon, _icon_state, _dir, _layer, _color)
	var/obj/item/I = parent
	var/icon = I.icon
	var/icon_state = I.icon_state
	var/static/list/contamination_appearances = list()
	//try to find a pre-processed blood-splatter. otherwise, make a new one
	// Use initial icon to avoid cache collisions from dynamic icon objects
	var/base_icon = isfile(icon) ? "[icon]" : "[initial(I.icon)]"
	var/index = "[base_icon]-[icon_state]"
	pic = contamination_appearances[index]

	if(!pic)
		var/icon/contamination_icon = icon(icon, icon_state, , 1)		//we only want to apply blood-splatters to the initial icon_state for each object
		contamination_icon.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
		contamination_icon.Blend(GLOB.gurgled_overlays[color], ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
		pic = mutable_appearance(contamination_icon, initial(icon_state))
		contamination_appearances[index] = pic
	pic.alpha = 255
	return TRUE

/datum/component/decal/contamination/proc/get_examine_name(datum/source, mob/user, list/override)
	var/atom/A = parent
	override[EXAMINE_POSITION_ARTICLE] = A.gender == PLURAL? "some" : "a"
	override[EXAMINE_POSITION_BEFORE] = " <span class='green'>[flavor]</span> "
	return COMPONENT_EXNAME_CHANGED

/datum/component/decal/contamination/remove(atom/thing)
	. = ..()

	var/atom/master = thing || parent
	if(isitem(master))
		var/obj/item/I = master
		I.gurgled = 0
		I.gurgled_color = null
