/obj/structure/rotation_piece/examine(mob/user)
	. = ..()
	if(rotation_direction)
		. += span_notice("It is spinning [rotation_direction == 8? "counter" : ""]clockwise")
