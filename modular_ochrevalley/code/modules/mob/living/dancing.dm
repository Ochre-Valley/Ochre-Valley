// Dancing!
#define DANCE_TOTAL_TIME (2 SECONDS)
#define DANCE_CLOSER_DISTANCE 8

// Called from /mob/living/rmb_on, notably ignores arm grabs
// Will interrupt rmb_on if you return TRUE
/mob/living/proc/ov_try_dance_move(mob/living/carbon/partner)
	// Dancing check
	if(actively_dancing)
		return

	// We only care about right clicking on carbon mobs (since we have to target hand and animals have no hands)
	if(!istype(partner))
		return FALSE

	// Grab has to be in our active hand
	var/obj/item/grabbing/G = get_active_held_item()
	// And grabbing the person we're clicking
	if(!istype(G) || G.grabbed != partner)
		return FALSE

	// At this point, they're likely trying to dance, so we'll start giving them information on why they can't and preventing default behavior
	if(grab_state != GRAB_PASSIVE)
		to_chat(src, span_warning("I cannot dance with a grip so tight."))
		return TRUE

	// If either of us are in combat mode, maybe we don't dance...
	if(cmode || partner.cmode)
		to_chat(src, span_warning("I cannot dance when either of us are tensed up."))
		return TRUE

	// Okay, we have a grab on partner, make sure we're grabbing one of their HANDS
	if(G.sublimb_grabbed != BODY_ZONE_PRECISE_L_HAND && G.sublimb_grabbed != BODY_ZONE_PRECISE_R_HAND)
		to_chat(src, span_warning("I cannot dance without holding their hand."))
		return TRUE

	// Let's make sure we're CARDINAL to them or everything breaks
	if(!(get_dir(src, partner) in GLOB.cardinals))
		to_chat(src, span_warning("I cannot dance at this strange angle, I should align myself with them."))
		return TRUE

	// We are ready to dance!
	// Clockwise if right hand, counterclockwise if left hand
	ov_do_dance(partner, ccw = !!(active_hand_index % 2))
	return TRUE

// Unsafe proc, does no checks!
// Animates a 180 degree rotation to swap places
/mob/living/proc/ov_do_dance(mob/living/carbon/partner, ccw = FALSE)
	var/original_turf_src = get_turf(src)
	var/original_turf_partner = get_turf(partner)

	// Prepare our dancers
	ov_prepare_for_dance()
	partner.ov_prepare_for_dance()

	var/original_pixel_x = pixel_x
	var/original_pixel_y = pixel_y
	var/original_pixel_x_partner = partner.pixel_x
	var/original_pixel_y_partner = partner.pixel_y

	// Mask what we're doing
	var/original_invis = invisibility
	var/original_invis_partner = partner.invisibility

	invisibility = INVISIBILITY_ABSTRACT
	partner.invisibility = INVISIBILITY_ABSTRACT

	// Immediately swap places so we abort before animations if we can't actually swap places
	if(!ov_dance_swap_places(partner))
		// Failed to swap for whatever reason
		to_chat(src, span_danger("You can't dance with [partner] right now."))
		// Immediately call end_dance
		ov_end_dance(TRUE, original_invis)
		partner.ov_end_dance(FALSE, original_invis_partner)
		return FALSE

	// Set our direction for coming out of the spin (we're invisible now so it's fine)
	setDir(get_dir(src, partner))
	partner.setDir(get_dir(partner, src))

	// Reset a few things after the animation ends
	addtimer(CALLBACK(src, PROC_REF(ov_end_dance), TRUE, original_invis), DANCE_TOTAL_TIME)
	addtimer(CALLBACK(partner, PROC_REF(ov_end_dance), FALSE, original_invis_partner), DANCE_TOTAL_TIME)

	// Crunch the numbers
	var/alist/animation_input = alist(
		// Technically this should be get_standard_pixel_x_offset/etc with pulling removed; but
		// mob_offsets is not actually used for anything we care about as of 2026-08-20
		"src_base" = list(initial(pixel_x), initial(pixel_y)),
		"src_start" = list(original_pixel_x, original_pixel_y),
		"src_end" = list(pixel_x, pixel_y),
		"partner_base" = list(initial(partner.pixel_x), initial(partner.pixel_y)),
		"partner_start" = list(original_pixel_x_partner, original_pixel_y_partner),
		"partner_end" = list(partner.pixel_x, partner.pixel_y),
	)
	var/alist/animation_data = ov_calculate_dance_animation(animation_input, ccw, get_dir(src, partner))

	// Destructure
	var/list/src_passes = animation_data["src_passes"]
	var/list/partner_passes = animation_data["partner_passes"]

	// Create temporary visuals to animate
	// Also set initial values

	// Us
	var/mutable_appearance/src_appearance = new(src)
	src_appearance.invisibility = original_invis
	src_appearance.dir = src_passes[1]["dir"]
	src_appearance.layer = src_passes[1]["layer"]
	src_appearance.pixel_x = src_passes[1]["x"]
	src_appearance.pixel_y = src_passes[1]["y"]

	var/obj/effect/temp_visual/ov_dance/src_vis = new(original_turf_src)
	src_vis.appearance = src_appearance

	// Our Partner
	var/mutable_appearance/partner_appearance = new(partner)
	partner_appearance.invisibility = original_invis
	partner_appearance.dir = partner_passes[1]["dir"]
	partner_appearance.layer = partner_passes[1]["layer"]
	partner_appearance.pixel_x = partner_passes[1]["x"]
	partner_appearance.pixel_y = partner_passes[1]["y"]

	var/obj/effect/temp_visual/ov_dance/partner_vis = new(original_turf_partner)
	partner_vis.appearance = partner_appearance

	var/divisions = length(src_passes) - 1

	// Run the actual animation
	// First us
	for(var/i in 2 to length(src_passes))
		var/alist/pass = src_passes[i]
		var/list/animate_args = list(
			"dir" = pass["dir"],
			"pixel_x" = pass["x"],
			"pixel_y" = pass["y"],
		)
		if(!isnull(pass["layer"]))
			animate_args["layer"] = pass["layer"]

		animate(src_vis, animate_args, time = DANCE_TOTAL_TIME / divisions, flags = ANIMATION_CONTINUE)

	// Then our client
	if(client)
		for(var/i in 2 to length(src_passes))
			var/alist/pass = src_passes[i]
			var/list/animate_args = list(
				"pixel_x" = pass["x"],
				"pixel_y" = pass["y"],
			)
			animate(client, animate_args, time = DANCE_TOTAL_TIME / divisions, flags = ANIMATION_CONTINUE)

	// Then our partner
	for(var/i in 2 to length(partner_passes))
		var/alist/pass = partner_passes[i]
		var/list/animate_args = list(
			"dir" = pass["dir"],
			"pixel_x" = pass["x"],
			"pixel_y" = pass["y"],
		)
		if(!isnull(pass["layer"]))
			animate_args["layer"] = pass["layer"]

		animate(partner_vis, animate_args, time = DANCE_TOTAL_TIME / divisions, flags = ANIMATION_CONTINUE)

	// Then our partner's client
	if(partner.client)
		for(var/i in 2 to length(partner_passes))
			var/alist/pass = partner_passes[i]
			var/list/animate_args = list(
				"pixel_x" = pass["x"],
				"pixel_y" = pass["y"],
			)
			animate(partner.client, animate_args, time = DANCE_TOTAL_TIME / divisions, flags = ANIMATION_CONTINUE)


/mob/living/proc/ov_prepare_for_dance()
	// Dance check
	actively_dancing = TRUE
	// Pixel shifts are definitely going to look wrong
	unpixel_shift()
	// Immobilize our dancer so they don't fuck up the animation
	Immobilize(DANCE_TOTAL_TIME)
	// Don't let them change directions with face_atom till we're done either!
	facing_locked = TRUE
	// All of the below only matters if we have a client
	if(client)
		// Lock cameras
		locked_look = TRUE
		// For some reason reset_view and reset_perspective won't let us lock to current turf, so we do it by hand
		client.perspective = EYE_PERSPECTIVE
		client.eye = get_turf(src)
		// Hide our cone
		hide_cone()
		// We have to call update_cone directly because we can't sit and wait for SSincone
		update_cone()

// Callback after our animation is done, should undo everything in ov_prepare_for_dance
// is_lead is TRUE for the mob that clicked, FALSE for the partner
/mob/living/proc/ov_end_dance(is_lead, original_invis)
	// Dance check
	actively_dancing = FALSE
	// Immobilization ends on it's own
	// Unhide us
	invisibility = original_invis
	// Unlock facing
	facing_locked = FALSE
	// Unlock camera
	locked_look = FALSE
	reset_perspective()
	// Reset our client's pixel offsets instantly to make it seamless
	if(client)
		client.pixel_x = 0
		client.pixel_y = 0
	// Reset view cones
	update_cone_show()
	update_vision_cone()

// Calculate offsets for four passes: Start, Closeup, Middle, and End
// First pass will always be initial conditions for the effects
// Schema (input):
//		src_base: [x, y]
//		src_start: [x, y]
//		src_end: [x, y]
//		partner_base: [x, y]
//		partner_start: [x, y]
//		partner_end: [x, y]
//
// Schema (output):
//		type Pass = {
//			x: number,
//			y: number;
//			dir: Dir;
//			layer: Layer | null; // null indicates keep same layer
//		}
//		src_passes: Pass[];
//		partner_passes: Pass[];
//
/proc/ov_calculate_dance_animation(
	// See input schema
	alist/pixel_offsets,
	// Counterclockwise?
	ccw = FALSE,
	// Direction after the swap
	dir_to_partner_after_swap
)
	RETURN_TYPE(/alist)
	// Reminder:
	// pixel_x: Negative is left/WEST, positive is right/EAST
	// pixel_y: Negative is down/SOUTH, positive is up/NORTH

	// Everything depends on the dir between us and them
	var/dir_to_partner_before_swap = turn(dir_to_partner_after_swap, 180)

	// Just used for easier to understand code
	var/full_step = world.icon_size
	var/half_step = world.icon_size / 2

	// Destructure our list
	var/src_base = pixel_offsets["src_base"]
	var/src_start = pixel_offsets["src_start"]
	var/src_end = pixel_offsets["src_end"]
	var/partner_base = pixel_offsets["partner_base"]
	var/partner_start = pixel_offsets["partner_start"]
	var/partner_end = pixel_offsets["partner_end"]

	var/list/src_passes = list()
	var/list/partner_passes = list()

	// Calculate passes
	// -----------------------------------------------------------------------------
	// START
	// -----------------------------------------------------------------------------
	var/src_start_layer = (dir_to_partner_before_swap & (NORTH | (ccw ? EAST : WEST))) ? ABOVE_ALL_MOB_LAYER : MOB_LAYER
	var/partner_start_layer = (dir_to_partner_before_swap & (SOUTH | (ccw ? WEST : EAST))) ? ABOVE_ALL_MOB_LAYER : MOB_LAYER
	UNTYPED_LIST_ADD(src_passes, alist(
		"x" = src_start[1],
		"y" = src_start[2],
		"dir" = dir_to_partner_before_swap,
		"layer" = src_start_layer,
	))
	UNTYPED_LIST_ADD(partner_passes, alist(
		"x" = partner_start[1],
		"y" = partner_start[2],
		"dir" = turn(dir_to_partner_before_swap, 180),
		"layer" = partner_start_layer,
	))

	// -----------------------------------------------------------------------------
	// CLOSEUP
	// -----------------------------------------------------------------------------
	var/src_closeup_dx = (dir_to_partner_before_swap & (NORTH|SOUTH)) \
		? 0 \
		: ((dir_to_partner_before_swap & EAST) ? 1 : -1) * DANCE_CLOSER_DISTANCE
	var/src_closeup_dy = (dir_to_partner_before_swap & (EAST|WEST)) \
		? 0 \
		: ((dir_to_partner_before_swap & NORTH) ? 1 : -1) * DANCE_CLOSER_DISTANCE
	var/partner_closeup_dx = -src_closeup_dx
	var/partner_closeup_dy = -src_closeup_dy

	UNTYPED_LIST_ADD(src_passes, alist(
		"x" = src_base[1] + src_closeup_dx,
		"y" = src_base[2] + src_closeup_dy,
		"dir" = dir_to_partner_before_swap,
		"layer" = null,
	))
	UNTYPED_LIST_ADD(partner_passes, alist(
		"x" = partner_base[1] + partner_closeup_dx,
		"y" = partner_base[2] + partner_closeup_dy,
		"dir" = turn(dir_to_partner_before_swap, 180),
		"layer" = null,
	))

	// -----------------------------------------------------------------------------
	// MIDDLE
	//   This is where stuff gets complex and ccw has to be taken into account...
	// -----------------------------------------------------------------------------
	var/middle_close_axis = (half_step - DANCE_CLOSER_DISTANCE) * (ccw ? 1 : -1) * (dir_to_partner_before_swap & (NORTH|WEST) ? 1 : -1)
	var/middle_far_axis = half_step * (dir_to_partner_before_swap & (NORTH|EAST) ? 1 : -1)

	var/src_middle_dx = dir_to_partner_before_swap & (NORTH|SOUTH) ? middle_close_axis : middle_far_axis
	var/src_middle_dy = dir_to_partner_before_swap & (NORTH|SOUTH) ? middle_far_axis : middle_close_axis

	var/partner_middle_dx = -src_middle_dx
	var/partner_middle_dy = -src_middle_dy

	var/src_middle_layer
	var/partner_middle_layer

	switch(dir_to_partner_before_swap)
		if(NORTH)
			src_middle_layer = MOB_LAYER
			partner_middle_layer = ABOVE_ALL_MOB_LAYER
		if(SOUTH)
			src_middle_layer = ABOVE_ALL_MOB_LAYER
			partner_middle_layer = MOB_LAYER
		if(EAST)
			src_middle_layer = ccw ? ABOVE_ALL_MOB_LAYER : MOB_LAYER
			partner_middle_layer = ccw ? MOB_LAYER : ABOVE_ALL_MOB_LAYER
		if(WEST)
			src_middle_layer = ccw ? MOB_LAYER : ABOVE_ALL_MOB_LAYER
			partner_middle_layer = ccw ? ABOVE_ALL_MOB_LAYER : MOB_LAYER

	UNTYPED_LIST_ADD(src_passes, alist(
		"x" = src_base[1] + src_middle_dx,
		"y" = src_base[2] + src_middle_dy,
		"dir" = turn(dir_to_partner_before_swap, ccw ? 90 : -90),
		"layer" = src_middle_layer,
	))
	UNTYPED_LIST_ADD(partner_passes, alist(
		"x" = partner_base[1] + partner_middle_dx,
		"y" = partner_base[2] + partner_middle_dy,
		"dir" = turn(dir_to_partner_before_swap, ccw ? -90 : 90),
		"layer" = partner_middle_layer,
	))

	// -----------------------------------------------------------------------------
	// END
	// -----------------------------------------------------------------------------
	var/src_ending_dx = (dir_to_partner_before_swap & (NORTH|SOUTH)) \
		? 0 \
		: ((dir_to_partner_before_swap & EAST) ? 1 : -1) * full_step
	var/src_ending_dy = (dir_to_partner_before_swap & (NORTH|SOUTH)) \
		? ((dir_to_partner_before_swap & NORTH) ? 1 : -1) * full_step \
		: 0
	var/partner_ending_dx = -src_ending_dx
	var/partner_ending_dy = -src_ending_dy

	UNTYPED_LIST_ADD(src_passes, alist(
		"x" = src_end[1] + src_ending_dx,
		"y" = src_end[2] + src_ending_dy,
		"dir" = turn(dir_to_partner_before_swap, 180),
		"layer" = null,
	))
	UNTYPED_LIST_ADD(partner_passes, alist(
		"x" = partner_end[1] + partner_ending_dx,
		"y" = partner_end[2] + partner_ending_dy,
		"dir" = dir_to_partner_before_swap,
		"layer" = null,
	))

	return alist(
		"src_passes" = src_passes,
		"partner_passes" = partner_passes,
	)

// Basically just ripped from /mob/living/proc/MobBump
/mob/living/proc/ov_dance_swap_places(mob/living/carbon/partner)
	var/old_loc = loc
	var/old_partner_loc = partner.loc

	// we give PASSMOB to both mobs to avoid bumping other mobs during swap.
	var/src_passmob = (pass_flags & PASSMOB)
	var/partner_passmob = (partner.pass_flags & PASSMOB)
	pass_flags |= PASSMOB
	partner.pass_flags |= PASSMOB

	// Disable move animation temporarily
	var/src_animate_movement = animate_movement
	var/partner_animate_movement = partner.animate_movement
	animate_movement = NO_STEPS
	partner.animate_movement = NO_STEPS

	var/move_failed = FALSE
	if(!partner.Move(old_loc) || !Move(old_partner_loc))
		// Shunt back if we failed
		forceMove(old_loc)
		partner.forceMove(old_partner_loc)
		move_failed = TRUE

	// Reset pass flags if necessary
	if(!src_passmob)
		pass_flags &= ~PASSMOB
	if(!partner_passmob)
		partner.pass_flags &= ~PASSMOB

	// Reset animation
	animate_movement = src_animate_movement
	partner.animate_movement = partner_animate_movement

	// Update our pixel offsets for grabbing since we moved
	if(!move_failed)
		set_pull_offsets(partner, grab_state)
		if(partner.pulling)
			partner.set_pull_offsets(partner.pulling, partner.grab_state)

	// Return if we moved successfully
	return !move_failed

/obj/effect/temp_visual/ov_dance
	duration = DANCE_TOTAL_TIME
	randomdir = FALSE

/obj/effect/temp_visual/ov_dance/Initialize(mapload, mob/living/dancer)
	. = ..()
	if(dancer)
		appearance = dancer

#undef DANCE_TOTAL_TIME
#undef DANCE_CLOSER_DISTANCE
