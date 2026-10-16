/obj/structure/skele_portal
	name = "skeleton portal"
	desc = "A bright portal torn through the fabric of the world, sounds of rattling bones and skeleton warcries can be heard on the other side. This can't be good."
	icon = 'modular_ochrevalley/icons/roguetown/misc/structure.dmi'
	icon_state = "evilportal"
	max_integrity = 500 //keep it a bit more intact, you'll need an axe to properly take it down quickly.
	anchored = TRUE
	density = FALSE
	layer = BELOW_OBJ_LAYER
	var/playerskele = 0 //Seperate so that skeleton NPCs (IF EVER ADDED) don't hog player slots
	var/maxplayerskele = 100 //upped for player shenngions with these.
	var/datum/looping_sound/boneloop/soundloop
	attacked_sound = 'sound/vo/mobs/ghost/skullpile_hit.ogg'

/obj/structure/skele_portal/Initialize(mapload)
	. = ..()
	soundloop = new(src, FALSE)
	soundloop.start()

	set_light(3, 2, 20, l_color = "#7b60f3")
	playsound(loc, 'sound/misc/portalopen.ogg', 100, FALSE, pressure_affected = FALSE)

/obj/structure/skele_portal/attack_ghost(mob/dead/observer/user)
	if(QDELETED(user))
		return
	if(!in_range(src, user))
		return
	if(playerskele >= (maxplayerskele+1))
		to_chat(user, "<span class='danger'>Too many player Skeletons.</span>")
		return
	playerskele++
	var/mob/living/carbon/human/species/skeleton/no_equipment/target = new (get_turf(src))
	target.key = user.key
	SSjob.EquipRank(target, "Envigorated Skeleton", TRUE)
	target.copy_known_languages_from(user, TRUE)
	target.visible_message(span_warning("[target]'s eyes light up with an eerie glow!"))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "ENVIGORATED SKELETON"), 3 SECONDS)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, select_skeleton_features)), 7 SECONDS)
	target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
	to_chat(target, span_danger("You are a disposable antagonist, expect to die rather quickly. Make sure to abide by the Event Rules of Engagement. Now go cause problems and stir some conflict! Remember to roleplay where possible."))
	qdel(user)

/obj/structure/skele_portal/examine(mob/user) //Ghosts only can examine this.
	. = ..()
	if(!isliving(user))
		var/bonelives = (maxplayerskele-playerskele)
		. += span_bloody("The skeleton wars beckon! You can click this portal to join as a skeleton if there are bones remaining. There are [bonelives] bones left.")


/obj/structure/skele_portal/Destroy()
	soundloop.stop()
	. = ..()


// NPC SKELETON SPAWNER - Taken From Abyssor Cult Wholesale
/obj/item/bone_marker
	name = "bone marker"
	desc = "A pulsating crystal shard that hums with otherworldly energy."
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "abyssal_marker_volatile"
	w_class = WEIGHT_CLASS_SMALL
	var/turf/marked_location
	var/effect_desc = " Use in-hand to mark a location, then activate it to break the barrier between the realm of bones and this realm where you put a mark down earlier."
	var/obj/rune_type = /obj/structure/active_bone_rune
	var/faith_locked = FALSE

/obj/item/bone_marker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, "It shatters the barrier between reality and BONE")

/obj/item/bone_marker/volatile
	name = "volatile bone marker"
	effect_desc = " Whispers fill your head. The crystal yearns to be used, it shall bring forth a wonderful rattling. The first use shall mark, the second shall unleash. Seems fragile, like it might explode violently with energies when thrown..."
	faith_locked = FALSE
	icon_state = "abyssal_marker_volatile"
	var/cooldown = 0
	var/creation_time


/obj/item/bone_marker/volatile/Initialize(mapload)
	. = ..()
	creation_time = world.time
	var/area/A = get_area(src)
	if(istype(A, /area/rogue/underworld/dream))
		cooldown = 3 MINUTES

/obj/item/bone_marker/volatile/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)

	var/turf/T = get_turf(hit_atom)
	if(T)
		marked_location = T
		visible_message(span_warning("[src] shatters on impact!"))
		playsound(src, 'sound/magic/lightning.ogg', 50, TRUE)
		new rune_type(T)
		qdel(src)
	else
		return ..()


/obj/item/bone_marker/attack_self(mob/user)
	if(do_after(user, 2 SECONDS) && !marked_location)
		marked_location = get_turf(user)
		to_chat(user, span_notice("You charge the crystal with the essence of this location."))
		playsound(src, 'sound/magic/vlightning.ogg', 50, TRUE)
	else if (marked_location)
		user.visible_message(span_warning("[user] crushes the [src] in their hands!"))
		playsound(src, 'sound/magic/lightning.ogg', 50, TRUE)
		new rune_type(marked_location)
		qdel(src)

/obj/item/bone_marker/volatile/attack_self(mob/user)
	return ..()

/obj/structure/active_bone_rune
	name = "awakened bone rune"
	desc = "A violently pulsating rune emitting dark energy."
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "zizo_active"
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	density = FALSE
	light_outer_range = 3
	light_color = LIGHT_COLOR_BLUE
	var/spawn_time = 10 SECONDS
	var/obj/spire_type = /obj/structure/bone_spire


/obj/structure/active_bone_rune/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(spawn_spire)), spawn_time)
	src.visible_message(span_userdanger("A glowing, pulsating rune etches itself into the ground. Reality cracks visibly around it! Something is coming!"))

/obj/structure/active_bone_rune/proc/spawn_spire()
	new spire_type(get_turf(src))

#define ABYSSAL_GLOW_FILTER "abyssal_glow"

// Bone Spire Structure
/obj/structure/bone_spire
	name = "bone spire"
	desc = "A massive bone structure pulsing with heretical energy. Dark ash spreads from its base."
	icon = 'modular_ochrevalley/icons/roguetown/misc/structure.dmi'
	icon_state = "evilportal"
	anchored = TRUE
	density = TRUE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 500
	var/current_radius = 1
	var/max_radius = 4
	var/fiend_count = 0
	var/max_fiends = 7
	// Holds all the turf data so it can be unconverted.
	var/list/turf_data = list()
	var/expansion_timer = 2 MINUTES
	var/next_expansion_time = 0
	var/spawn_timer = 5 SECONDS
	var/next_fiend_time = 0
	var/awakened = FALSE
	var/converting = FALSE
	var/turf_to_use = /turf/open/floor/rogue/underworld/road
	var/mob/living/initial_fiend = /mob/living/carbon/human/species/skeleton/npc/easy
	pixel_y = 8


/obj/structure/bone_spire/Initialize(mapload)
	. = ..()
	spawn_fiends(1, initial_fiend)

	next_fiend_time = world.time + spawn_timer
	next_expansion_time = world.time + expansion_timer

	var/turf/T = loc
	turf_data[T] = T.type
	T.ChangeTurf(turf_to_use, flags = CHANGETURF_IGNORE_AIR)

	START_PROCESSING(SSobj, src)


/obj/structure/bone_spire/process()
	if(world.time >= next_fiend_time)
		spawn_fiends(1)
		next_fiend_time = world.time + spawn_timer

	if(world.time >= next_expansion_time && current_radius < max_radius || !awakened)
		if(!awakened)
			awakened = TRUE
		expand_radius()
		next_expansion_time = world.time + expansion_timer


/obj/structure/bone_spire/Destroy()
	for(var/turf/T in turf_data)
		T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()

	for(var/obj/structure/active_bone_rune/R in range(1, src))
		qdel(R)

	src.visible_message(span_danger("The spire shatters with a painful ringing. In an instant the darkness recedes back to cursed realm, restoring the world as it was."))
	STOP_PROCESSING(SSobj, src)
	playsound(src, 'sound/foley/glassbreak.ogg', 50, TRUE)
	new /obj/effect/particle_effect/smoke(src.loc)


	return ..()

/obj/structure/bone_spire/proc/start_conversion()
	converting = TRUE
	resistance_flags |= INDESTRUCTIBLE

	add_filter(ABYSSAL_GLOW_FILTER, 2, list("type" = "outline", "color" = "#6A0DAD", "alpha" = 0, "size" = 2))
	update_icon()

/obj/structure/bone_spire/proc/end_conversion()
	converting = FALSE
	resistance_flags &= ~INDESTRUCTIBLE

	remove_filter(ABYSSAL_GLOW_FILTER)
	update_icon()

#undef ABYSSAL_GLOW_FILTER

/obj/structure/bone_spire/proc/convert_surroundings()
	start_conversion()
	var/turf/center = get_turf(src)
	var/radius_sq = current_radius * current_radius

	for(var/turf/T in spiral_range_turfs(current_radius, center))
		// Skip if already converted
		if(istype(T, /turf/open/floor/rogue/underworld/road))
			continue

		// Calculate distance from center
		// P.S I hate math :)
		var/dx = abs(T.x - center.x)
		var/dy = abs(T.y - center.y)
		var/dist_sq = dx*dx + dy*dy

		// Skip corners with higher probability
		var/is_corner = (dx == dy) || (dx == current_radius && dy == current_radius)
		if(is_corner && prob(60))
			continue

		// Skip random tiles (10% chance)
		if(prob(10))
			continue

		// Only convert tiles within circular radius
		if(dist_sq <= radius_sq)
			turf_data[T] = T.type
			T.ChangeTurf(/turf/open/floor/rogue/underworld/road, flags = CHANGETURF_IGNORE_AIR)
			playsound(T, 'sound/magic/fleshtostone.ogg', 30, TRUE)
			sleep(10)

	end_conversion()

/obj/structure/bone_spire/proc/expand_radius()
	if(converting || current_radius >= max_radius)
		return

	current_radius++
	convert_surroundings()

/obj/structure/bone_spire/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armour_penetration)
	if(converting)
		visible_message(span_warning("The spire pulses with vile energy, deflecting the attack!"))
		playsound(src, 'sound/magic/repulse.ogg', 50, TRUE)
		return FALSE
	return ..()

/obj/structure/bone_spire/proc/spawn_spire_fiend(turf/spawn_turf, obj/structure/bone_spire/spire, mob/living/fiend_type = /mob/living/carbon/human/species/skeleton/npc/easy)
	if(!spawn_turf || !spire || !ispath(fiend_type))
		return FALSE

	var/mob/living/F = new fiend_type(spawn_turf)
	F.visible_message(span_danger("[F] manifests, weapons bared in hostility towards all living life!"))

	var/datum/component/comp = F.AddComponent(/datum/component/bone_fiend, spire)
	return comp ? TRUE : FALSE

/obj/structure/bone_spire/proc/spawn_fiends(amount, mob/living/fiend_type = /mob/living/carbon/human/species/skeleton/npc/easy)
	if(fiend_count >= max_fiends)
		return

	for(var/i in 1 to amount)
		if(fiend_count >= max_fiends)
			break

		var/turf/T = find_safe_spawn()
		if(T && spawn_spire_fiend(T, src, fiend_type))
			fiend_count++

/obj/structure/bone_spire/proc/find_safe_spawn(outer_tele_radius = 3, inner_tele_radius = 2, include_dense = FALSE, include_teleport_restricted = FALSE)
	var/turf/target_turf = get_turf(src)
	var/list/turfs = list()

	for(var/turf/T in range(target_turf, outer_tele_radius))
		if(T in range(target_turf, inner_tele_radius))
			continue
		if(istransparentturf(T))
			continue
		if(T.density && !include_dense)
			continue
		if(T.teleport_restricted && !include_teleport_restricted)
			continue
		if(T.x>world.maxx-outer_tele_radius || T.x<outer_tele_radius)
			continue
		if(T.y>world.maxy-outer_tele_radius || T.y<outer_tele_radius)
			continue
		turfs += T

	if(!length(turfs))
		for(var/turf/T in orange(target_turf, outer_tele_radius))
			if(!(T in orange(target_turf, inner_tele_radius)))
				turfs += T

	if(!length(turfs))
		return null

	return pick(turfs)

/obj/structure/bone_spire/proc/fiend_died()
	fiend_count = max(fiend_count - 1, 0)

/datum/component/bone_fiend
	var/obj/structure/bone_spire/linked_bone_spire

/datum/component/bone_fiend/Initialize(obj/structure/bone_spire/spire)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	linked_bone_spire = spire
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/bone_fiend/proc/on_death()
	SIGNAL_HANDLER
	if(linked_bone_spire)
		linked_bone_spire.fiend_died()
	qdel(src)
