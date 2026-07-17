/datum/appearance_changer
	var/list/valid_hairstyles = list()
	var/list/valid_facial_hairstyles = list()
	var/list/valid_ears = list()
	var/list/valid_tails = list()
	var/list/valid_horns = list()
	var/list/valid_wings = list()
	var/list/valid_penises = list()
	var/list/valid_testicles = list()
	var/list/valid_vaginas = list()
	var/list/valid_breasts = list()
	var/list/valid_accessories = list()
	var/list/valid_details = list()
	var/list/valid_gradients = list()
	var/customize_usr = FALSE
	var/mob/living/carbon/human/owner = null
	var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice
	var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice
/datum/appearance_changer/mirror_transform
	customize_usr = TRUE

/datum/appearance_changer/New(mob/living/carbon/human/H)
	owner = H
	hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
	facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)

/datum/appearance_changer/Destroy()
	return ..()

/datum/appearance_changer/ui_state(mob/user)
	return GLOB.always_state

/datum/appearance_changer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AppearanceChanger", "Mirror Transform")
		ui.open()
/datum/appearance_changer/proc/generate_data()
	//LAZYLEN to keep us from redoing these lists every time.
	var/datum/customizer_choice/bodypart_feature/accessory/accessory_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/accessory)
	var/datum/customizer_choice/bodypart_feature/face_detail/face_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/face_detail)
	if(!LAZYLEN(valid_hairstyles))
		for(var/hair_type in hair_choice.sprite_accessories)
			var/datum/sprite_accessory/hair/head/hair = new hair_type()
			valid_hairstyles[hair.name] = hair_type
	if(!LAZYLEN(valid_facial_hairstyles))
		for(var/facial_type in facial_choice.sprite_accessories)
			var/datum/sprite_accessory/hair/facial/facial = new facial_type()
			valid_facial_hairstyles[facial.name] = facial_type
	if(!LAZYLEN(valid_ears))
		for(var/ears_path in subtypesof(/datum/sprite_accessory/ears))
			var/datum/sprite_accessory/ears/ears = new ears_path()
			valid_ears[ears.name] = ears_path
	if(!LAZYLEN(valid_tails))
		for(var/tail_path in subtypesof(/datum/sprite_accessory/tail))
			var/datum/sprite_accessory/tail/tail = new tail_path()
			valid_tails[tail.name] = tail_path
	if(!LAZYLEN(valid_horns))
		for(var/horns_path in subtypesof(/datum/sprite_accessory/horns))
			var/datum/sprite_accessory/horns/horns = new horns_path()
			valid_horns[horns.name] = horns_path
	if(!LAZYLEN(valid_wings))
		for(var/wings_path in subtypesof(/datum/sprite_accessory/wings))
			var/datum/sprite_accessory/wings/wings = new wings_path()
			valid_wings[wings.name] = wings_path
	if(!LAZYLEN(valid_penises))
		for(var/penis_path in subtypesof(/datum/sprite_accessory/penis))
			var/datum/sprite_accessory/penis/penis = new penis_path()
			valid_penises[penis.name] = penis_path
	if(!LAZYLEN(valid_testicles))
		for(var/testicle_path in subtypesof(/datum/sprite_accessory/testicles))
			var/datum/sprite_accessory/testicles/testicles = new testicle_path()
			valid_testicles[testicles.name] = testicle_path
	if(!LAZYLEN(valid_vaginas))
		for(var/vagina_path in subtypesof(/datum/sprite_accessory/vagina))
			var/datum/sprite_accessory/vagina/vagina = new vagina_path()
			valid_vaginas[vagina.name] = vagina_path
	if(!LAZYLEN(valid_breasts))
		for(var/breast_path in subtypesof(/datum/sprite_accessory/breasts))
			var/datum/sprite_accessory/breasts/breasts = new breast_path()
			valid_breasts[breasts.name] = breast_path
	if(!LAZYLEN(valid_accessories))
		for(var/accessory_type in accessory_choice.sprite_accessories)
			var/datum/sprite_accessory/accessory/acc = new accessory_type()
			valid_accessories[acc.name] = accessory_type
	if(!LAZYLEN(valid_details))
		for(var/detail_type in face_choice.sprite_accessories)
			var/datum/sprite_accessory/face_detail/detail = new detail_type()
			valid_details[detail.name] = detail_type
	if(!LAZYLEN(valid_gradients))
		for(var/gradient_type in GLOB.hair_gradients)
			var/datum/hair_gradient/gradient = new gradient_type()
			valid_gradients[gradient.name] = gradient_type
/datum/appearance_changer/ui_static_data(mob/user)
	//A bit cleaner now, should probably still just make all the style lists part of the datum.
	var/list/data = list()
	generate_data()
	var/hair_styles[0]
	var/facial_styles[0]
	var/ear_styles[0]
	var/tail_styles[0]
	var/horn_styles[0]
	var/wing_styles[0]
	var/penis_styles[0]
	var/testicle_styles[0]
	var/vagina_styles[0]
	var/breast_styles[0]
	var/accessory_styles[0]
	var/detail_styles[0]
	var/gradient_styles[0]
	for(var/hair_style in valid_hairstyles)
		hair_styles[++hair_styles.len] = list("hairstyle" = hair_style)
	for(var/facial_style in valid_facial_hairstyles)
		facial_styles[++facial_styles.len] = list("facialhairstyle" = facial_style)
	for(var/ear_style in valid_ears)
		ear_styles[++ear_styles.len] = list("name" = ear_style)
	for(var/tail_style in valid_tails)
		tail_styles[++tail_styles.len] = list("name" = tail_style)
	for(var/horn_style in valid_horns)
		horn_styles[++horn_styles.len] = list("name" = horn_style)
	for(var/wing_style in valid_wings)
		wing_styles[++wing_styles.len] = list("name" = wing_style)
	for(var/penis_style in valid_penises)
		penis_styles[++penis_styles.len] = list("name" = penis_style)
	for(var/testicle_style in valid_testicles)
		testicle_styles[++testicle_styles.len] = list("name" = testicle_style)
	for(var/vagina_style in valid_vaginas)
		vagina_styles[++vagina_styles.len] = list("name" = vagina_style)
	for(var/breast_style in valid_breasts)
		breast_styles[++breast_styles.len] = list("name" = breast_style)
	for(var/acc_style in valid_accessories)
		accessory_styles[++accessory_styles.len] = list("name" = acc_style)
	for(var/detail_style in valid_details)
		detail_styles[++detail_styles.len] = list("name" = detail_style)
	for(var/gradient_style in valid_gradients)
		gradient_styles[++gradient_styles.len] = list("name" = gradient_style)
	data["hair_styles"] = hair_styles
	data["facial_hair_styles"] = facial_styles
	data["ear_styles"] = ear_styles
	data["tail_styles"] = tail_styles
	data["horn_styles"] = horn_styles
	data["wing_styles"] = wing_styles
	data["penis_styles"] = penis_styles
	data["testicle_styles"] = testicle_styles
	data["vagina_styles"] = vagina_styles
	data["breast_styles"] = breast_styles
	data["accessory_styles"] = accessory_styles
	data["detail_styles"] = detail_styles
	data["gradient_styles"] = gradient_styles
	return data

/datum/appearance_changer/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/carbon/human/target = owner
	if(customize_usr)
		if(!ishuman(user))
			return data
		target = user
	var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
	if(head && head.bodypart_features)
		for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
			data["nat_gradient_color"] = hair_feature.natural_color
			data["nat_gradient_style"] = hair_feature.natural_gradient
			data["dye_gradient_color"] = hair_feature.hair_dye_color
			data["dye_gradient_style"] = hair_feature.hair_dye_gradient
			data["hair_style"] = hair_feature
			break
		for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
			data["facial_hair_style"] = facial_feature
			break
	var/obj/item/organ/penis/penis = target.getorganslot(ORGAN_SLOT_PENIS)
	if(penis)
		data["penis_size"] = penis.penis_size
		data["penis_color"] = color_string_to_list(penis.accessory_colors)
	var/obj/item/organ/testicles/testicles = target.getorganslot(ORGAN_SLOT_TESTICLES)
	if(testicles)
		data["testicle_size"] = testicles.ball_size
		data["testicle_color"] = color_string_to_list(testicles.accessory_colors)
	var/obj/item/organ/breasts/breasts = target.getorganslot(ORGAN_SLOT_BREASTS)
	if(breasts)
		data["breast_size"] = breasts.breast_size
		data["breast_color"] = color_string_to_list(breasts.accessory_colors)
	var/obj/item/organ/vagina/vagina = target.getorganslot(ORGAN_SLOT_VAGINA)
	if(vagina)
		data["vagina_color"] = color_string_to_list(vagina.accessory_colors)
	var/obj/item/organ/wings/wings = target.getorganslot(ORGAN_SLOT_WINGS)
	if(wings)
		data["wing_color"] = color_string_to_list(wings.accessory_colors)
	var/obj/item/organ/horns/horns = target.getorganslot(ORGAN_SLOT_HORNS)
	if(horns)
		data["horn_color"] = color_string_to_list(horns.accessory_colors)
	var/obj/item/organ/tail/tail = target.getorganslot(ORGAN_SLOT_TAIL)
	if(tail)
		data["tail_color"] = color_string_to_list(tail.accessory_colors)
	var/obj/item/organ/ears/ears = target.getorganslot(ORGAN_SLOT_EARS)
	if(ears)
		data["ear_color"] = color_string_to_list(ears.accessory_colors)
	data["has_vagina"] = (vagina ? 1 : 0)
	data["has_wings"] = (wings ? 1 : 0)
	data["has_horns"] = (horns ? 1 : 0)
	data["has_tail"] = (tail ? 1 : 0)
	data["has_ears"] = (ears.accessory_colors ? 1 : 0)
	data["has_breasts"] = (breasts ? 1 : 0)
	data["eye_color"] = target.eye_color
	data["hair_primary"] = target.hair_color
	data["facial_hair_color"] = target.facial_hair_color
	return data

/datum/appearance_changer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	var/should_update = FALSE
	var/mob/living/carbon/human/target = owner
	if(customize_usr)
		if(!ishuman(usr))
			return FALSE
		target = usr

	switch(action)
		if("hair")
			if(params["hair"] in valid_hairstyles)
				var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color

						if(istype(current_hair, /datum/bodypart_feature/hair/head))
							hair_entry.natural_gradient = current_hair.natural_gradient
							hair_entry.natural_color = current_hair.natural_color
							if(hasvar(current_hair, "hair_dye_gradient"))
								hair_entry.dye_gradient = current_hair.hair_dye_gradient
							if(hasvar(current_hair, "hair_dye_color"))
								hair_entry.dye_color = current_hair.hair_dye_color

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(valid_hairstyles[params["hair"]], hair_entry.hair_color, target)

						hair_choice.customize_feature(new_hair, target, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE
		if("eye_color")
			var/new_eye_color = color_pick_sanitized(target, "Choose your eye color", "Eye Color", target.eye_color)
			if(new_eye_color)
				new_eye_color = sanitize_hexcolor(new_eye_color, 6, TRUE)
				var/obj/item/organ/eyes/eyes = target.getorganslot(ORGAN_SLOT_EYES)
				if(eyes)
					eyes.Remove(target)
					eyes.eye_color = new_eye_color
					eyes.Insert(target, TRUE, FALSE)
				target.eye_color = new_eye_color
				target.dna.features["eye_color"] = new_eye_color
				target.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
				should_update = TRUE
		if("hair_primary")
			var/new_hair_color = color_pick_sanitized(target, "Choose your hair color", "Primary Hair Color", target.hair_color)
			if(new_hair_color)
				var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)

					var/datum/customizer_entry/hair/hair_entry = new()
					hair_entry.hair_color = sanitize_hexcolor(new_hair_color, 6, TRUE)

					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/bodypart_feature/hair/head/new_hair = new()

						new_hair.set_accessory_type(current_hair.accessory_type, null, target)

						hair_choice.customize_feature(new_hair, target, null, hair_entry)

						target.hair_color = hair_entry.hair_color
						target.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)

						target.dna.species.handle_body(target)
						should_update = TRUE
		if("facial_hair_color")
			var/new_facial_hair_color = color_pick_sanitized(target, "Choose your facial hair color", "Facial Hair Color", target.facial_hair_color)
			if(new_facial_hair_color)
				var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)

					var/datum/customizer_entry/hair/facial/facial_entry = new()

					var/datum/bodypart_feature/hair/facial/current_facial = null
					for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
						current_facial = facial_feature
						break

					if(current_facial)
						facial_entry.hair_color = sanitize_hexcolor(new_facial_hair_color, 6, TRUE)
						facial_entry.accessory_type = current_facial.accessory_type

						var/datum/bodypart_feature/hair/facial/new_facial = new()
						new_facial.set_accessory_type(current_facial.accessory_type, null, target)
						facial_choice.customize_feature(new_facial, target, null, facial_entry)

						target.facial_hair_color = facial_entry.hair_color
						target.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						should_update = TRUE
		if("facial_hair")
			if(params["facial_hair"] in valid_facial_hairstyles)
				var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/facial/current_facial = null
					for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
						current_facial = facial_feature
						break

					if(current_facial)
						// Create a new facial hair entry with the SAME color as the current facial hair
						var/datum/customizer_entry/hair/facial/facial_entry = new()
						facial_entry.hair_color = current_facial.hair_color

						// Create the new facial hair with the new style but preserve color
						var/datum/bodypart_feature/hair/facial/new_facial = new()
						new_facial.set_accessory_type(valid_facial_hairstyles[params["facial_hair"]], facial_entry.hair_color, target)

						// Apply all the color data from the entry
						facial_choice.customize_feature(new_facial, target, null, facial_entry)

						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						should_update = TRUE
		if("ear")
			if(params["ear"])
				if(params["ear"] == "none")
					var/obj/item/organ/ears/ears = target.getorganslot(ORGAN_SLOT_EARS)
					if(ears)
						ears.Remove(target)
						qdel(ears)
						//You need ears, give them back!
						ears = new /obj/item/organ/ears()
						ears.Insert(target, TRUE, FALSE)
						should_update = TRUE
				else
					var/obj/item/organ/ears/ears = target.getorganslot(ORGAN_SLOT_EARS)
					if(!ears)
						ears = new /obj/item/organ/ears()
						ears.Insert(target, TRUE, FALSE)
					ears.accessory_type = valid_ears[params["ear"]]
					var/datum/sprite_accessory/ears/ears_type = SPRITE_ACCESSORY(ears.accessory_type)
					ears.accessory_colors = ears_type.get_default_colors(color_key_source_list_from_carbon(target))
					should_update = TRUE
		if("tail")
			if(params["tail"])
				if(params["tail"] == "none")
					var/obj/item/organ/tail/tail = target.getorganslot(ORGAN_SLOT_TAIL)
					if(tail)
						tail.Remove(target)
						qdel(tail)
						should_update = TRUE
				else
					var/obj/item/organ/tail/tail = target.getorganslot(ORGAN_SLOT_TAIL)
					if(!tail)
						tail = new /obj/item/organ/tail/anthro()
						tail.Insert(target, TRUE, FALSE)
					tail.accessory_type = valid_tails[params["tail"]]
					var/datum/sprite_accessory/tail/tail_type = SPRITE_ACCESSORY(tail.accessory_type)
					tail.accessory_colors = tail_type.get_default_colors(color_key_source_list_from_carbon(target))
					should_update = TRUE
		if("horn")
			if(params["horn"])
				if(params["horn"] == "none")
					var/obj/item/organ/horns/horns = target.getorganslot(ORGAN_SLOT_HORNS)
					if(horns)
						horns.Remove(target)
						qdel(horns)
						should_update = TRUE
				else
					var/obj/item/organ/horns/horns = target.getorganslot(ORGAN_SLOT_HORNS)
					if(!horns)
						horns = new /obj/item/organ/horns()
						horns.Insert(target, TRUE, FALSE)
					horns.accessory_type = valid_horns[params["horn"]]
					var/datum/sprite_accessory/horns/horns_type = SPRITE_ACCESSORY(horns.accessory_type)
					horns.accessory_colors = horns_type.get_default_colors(color_key_source_list_from_carbon(target))
					should_update = TRUE
		if("wing")
			if(params["wing"])
				if(params["wing"] == "none")
					var/obj/item/organ/wings/wings = target.getorganslot(ORGAN_SLOT_WINGS)
					if(wings)
						wings.Remove(target)
						qdel(wings)
						should_update = TRUE
				else
					var/obj/item/organ/wings/wings = target.getorganslot(ORGAN_SLOT_WINGS)
					if(!wings)
						wings = new /obj/item/organ/wings()
						wings.Insert(target, TRUE, FALSE)
					wings.accessory_type = valid_wings[params["wing"]]
					var/datum/sprite_accessory/wings/wings_type = SPRITE_ACCESSORY(wings.accessory_type)
					wings.accessory_colors = wings_type.get_default_colors(color_key_source_list_from_carbon(target))
					should_update = TRUE
		if("penis")
			if(params["penis"])
				if(params["penis"] == "none")
					var/obj/item/organ/penis/penis = target.getorganslot(ORGAN_SLOT_PENIS)
					if(penis)
						penis.Remove(target)
						qdel(penis)
						should_update = TRUE
				else
					var/obj/item/organ/penis/penis = target.getorganslot(ORGAN_SLOT_PENIS)
					if(!penis)
						penis = new()
						penis.Insert(target, TRUE, FALSE)
					penis.accessory_type = valid_penises[params["penis"]]
					var/datum/sprite_accessory/penis/penis_type = SPRITE_ACCESSORY(penis.accessory_type)
					penis.accessory_colors = penis_type.get_default_colors(color_key_source_list_from_carbon(target))
					should_update = TRUE
		if("penis_size")
			var/obj/item/organ/penis/penis = target.getorganslot(ORGAN_SLOT_PENIS)
			if(penis)
				penis.penis_size = 1 + (penis.penis_size % 5)
				should_update = TRUE
		if("penis_color")
			var/obj/item/organ/penis/penis = target.getorganslot(ORGAN_SLOT_PENIS)
			if(penis)
				var/new_color = color_pick_sanitized(target, "Choose your penis color", "Penis color", "#FFFFFF")
				if(new_color)
					penis.Remove(target)
					var/list/colors = list()
					if(penis.accessory_colors)
						colors = color_string_to_list(penis.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					penis.accessory_colors = color_list_to_string(colors)
					penis.Insert(target, TRUE, FALSE)
					target.dna.features["penis_color"] = colors[1]  // Update DNA features
					should_update = TRUE
		if("testicle")
			if(params["testicle"])
				if(params["testicle"] == "none")
					var/obj/item/organ/testicles/testicles = target.getorganslot(ORGAN_SLOT_TESTICLES)
					if(testicles)
						testicles.Remove(target)
						qdel(testicles)
						should_update = TRUE
				else
					var/obj/item/organ/testicles/testicles = target.getorganslot(ORGAN_SLOT_TESTICLES)
					if(!testicles)
						testicles = new()
						testicles.Insert(target, TRUE, FALSE)
					testicles.accessory_type = valid_testicles[params["testicle"]]
					var/datum/sprite_accessory/testicles/testicles_type = SPRITE_ACCESSORY(testicles.accessory_type)
					testicles.accessory_colors = testicles_type.get_default_colors(color_key_source_list_from_carbon(target))
					should_update = TRUE
		if("testicle_size")
			var/obj/item/organ/testicles/testicles = target.getorganslot(ORGAN_SLOT_TESTICLES)
			if(testicles)
				testicles.ball_size = 1 + (testicles.ball_size % 5)
				should_update = TRUE
		if("testicle_color")
			var/obj/item/organ/testicles/testicles = target.getorganslot(ORGAN_SLOT_TESTICLES)
			if(testicles)
				var/new_color = color_pick_sanitized(target, "Choose your testicle color", "Testicle color", "#FFFFFF")
				if(new_color)
					testicles.Remove(target)
					var/list/colors = list()
					if(testicles.accessory_colors)
						colors = color_string_to_list(testicles.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					testicles.accessory_colors = color_list_to_string(colors)
					testicles.Insert(target, TRUE, FALSE)
					target.dna.features["testicle_color"] = colors[1]  // Update DNA features
					should_update = TRUE
		if("vagina")
			if(params["vagina"])
				if(params["vagina"] == "none")
					var/obj/item/organ/vagina/vagina = target.getorganslot(ORGAN_SLOT_VAGINA)
					if(vagina)
						vagina.Remove(target)
						qdel(vagina)
						should_update = TRUE
				else
					var/obj/item/organ/vagina/vagina = target.getorganslot(ORGAN_SLOT_VAGINA)
					if(!vagina)
						vagina = new()
						vagina.Insert(target, TRUE, FALSE)
					vagina.accessory_type = valid_vaginas[params["vagina"]]
					should_update = TRUE
		if("vagina_color")
			var/obj/item/organ/vagina/vagina = target.getorganslot(ORGAN_SLOT_VAGINA)
			if(vagina)
				var/new_color = color_pick_sanitized(target, "Choose your vagina color", "Vagina color", "#FFFFFF")
				if(new_color)
					vagina.Remove(target)
					var/list/colors = list()
					if(vagina.accessory_colors)
						colors = color_string_to_list(vagina.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					vagina.accessory_colors = color_list_to_string(colors)
					vagina.Insert(target, TRUE, FALSE)
					target.dna.features["vagina_color"] = colors[1]  // Update DNA features
					should_update = TRUE
		if("wing_color")
			var/obj/item/organ/wings/wings = target.getorganslot(ORGAN_SLOT_WINGS)
			if(wings)
				var/new_color = color_pick_sanitized(target, "Choose your primary wing color", "Wing Color One", "#FFFFFF")
				if(new_color)
					wings.Remove(target)
					var/list/colors = list()
					if(wings.accessory_colors)
						colors = color_string_to_list(wings.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[params["index"]] = sanitize_hexcolor(new_color, 6, TRUE)
					wings.accessory_colors = color_list_to_string(colors)
					wings.Insert(target, TRUE, FALSE)
					target.dna.features["wings_color"] = colors[params["index"]]  // Update DNA features
					should_update = TRUE
			else
				to_chat(target, span_warning("You don't have wings!"))
		if("horn_color")
			var/obj/item/organ/horns/horns = target.getorganslot(ORGAN_SLOT_HORNS)
			if(horns)
				var/new_color = color_pick_sanitized(target, "Choose your primary horn color", "Horn Color", "#FFFFFF")
				if(new_color)
					horns.Remove(target)
					var/list/colors = list()
					if(horns.accessory_colors)
						colors = color_string_to_list(horns.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					horns.accessory_colors = color_list_to_string(colors)
					horns.Insert(target, TRUE, FALSE)
					target.dna.features["horns_color"] = colors[1]  // Update DNA features
					should_update = TRUE
			else
				to_chat(target, span_warning("You don't have horns!"))
		if("tail_color")
			var/obj/item/organ/tail/tail = target.getorganslot(ORGAN_SLOT_TAIL)
			if(tail)
				var/new_color = color_pick_sanitized(target, "Choose your tail color", "Tail Color [params["index"]]", "#FFFFFF")
				if(new_color)
					tail.Remove(target)
					var/list/colors = list()
					if(tail.accessory_colors)
						colors = color_string_to_list(tail.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[params["index"]] = sanitize_hexcolor(new_color, 6, TRUE)
					tail.accessory_colors = color_list_to_string(colors)
					tail.Insert(target, TRUE, FALSE)
					target.dna.features["tail_color"] = colors[params["index"]]  // Update DNA features
					should_update = TRUE
			else
				to_chat(target, span_warning("You don't have a tail!"))
		if("ear_color")
			var/obj/item/organ/ears/ears = target.getorganslot(ORGAN_SLOT_EARS)
			if(ears)
				var/new_color = color_pick_sanitized(target, "Choose your ear color [params["index"]]", "Ear Color [params["index"]]", "#FFFFFF")
				if(new_color)
					ears.Remove(target)
					var/list/colors = list()
					if(ears.accessory_colors)
						colors = color_string_to_list(ears.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[params["index"]] = sanitize_hexcolor(new_color, 6, TRUE)
					ears.accessory_colors = color_list_to_string(colors)
					ears.Insert(target, TRUE, FALSE)
					target.dna.features["ears_color"] = colors[params["index"]]  // Update DNA features
					should_update = TRUE
			else
				to_chat(target, span_warning("You don't have ears!"))
		if("breast")
			if(params["breast"])
				if(params["breast"] == "none")
					var/obj/item/organ/breasts/breasts = target.getorganslot(ORGAN_SLOT_BREASTS)
					if(breasts)
						breasts.Remove(target)
						qdel(breasts)
						should_update = TRUE
				else
					var/obj/item/organ/breasts/breasts = target.getorganslot(ORGAN_SLOT_BREASTS)
					if(!breasts)
						breasts = new()
						breasts.Insert(target, TRUE, FALSE)

					breasts.accessory_type = valid_breasts[params["breast"]]
					var/datum/sprite_accessory/breasts/breasts_type = SPRITE_ACCESSORY(breasts.accessory_type)
					breasts.accessory_colors = breasts_type.get_default_colors(color_key_source_list_from_carbon(target))
					should_update = TRUE
		if("breast_size")
			var/obj/item/organ/breasts/breasts = target.getorganslot(ORGAN_SLOT_BREASTS)
			if(breasts)
				breasts.breast_size = (breasts.breast_size + 1) % 17
				should_update = TRUE
		if("breast_color")
			var/obj/item/organ/breasts/breasts = target.getorganslot(ORGAN_SLOT_BREASTS)
			if(breasts)
				var/new_color = color_pick_sanitized(target, "Choose your breast color", "Breast color", "#FFFFFF")
				if(new_color)
					breasts.Remove(target)
					var/list/colors = list()
					if(breasts.accessory_colors)
						colors = color_string_to_list(breasts.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					breasts.accessory_colors = color_list_to_string(colors)
					breasts.Insert(target, TRUE, FALSE)
					target.dna.features["breast_color"] = colors[1]  // Update DNA features
					should_update = TRUE
		if("accessory")
			if(params["acc"])
				var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					// Remove existing accessory if any
					for(var/datum/bodypart_feature/accessory/old_acc in head.bodypart_features)
						head.remove_bodypart_feature(old_acc)
						break

					// Add new accessory if not "none"
					if(params["acc"] != "none")
						var/datum/bodypart_feature/accessory/accessory_feature = new()
						accessory_feature.set_accessory_type(valid_accessories[params["acc"]], target.hair_color, target)
						head.add_bodypart_feature(accessory_feature)
					should_update = TRUE
		if("face_detail")
			if(params["detail"])
				var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					// Remove existing face detail if any
					for(var/datum/bodypart_feature/face_detail/old_detail in head.bodypart_features)
						head.remove_bodypart_feature(old_detail)
						break

					// Add new face detail if not "none"
					if(params["detail"] != "none")
						var/datum/bodypart_feature/face_detail/detail_feature = new()
						detail_feature.set_accessory_type(valid_details[params["detail"]], target.hair_color, target)
						head.add_bodypart_feature(detail_feature)
					should_update = TRUE
		if("natgrad")
			if(params["grad"])
				var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = valid_gradients[params["grad"]]
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, target)
						hair_choice.customize_feature(new_hair, target, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE
		if("dyegrad")
			if(params["grad"])
				var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = valid_gradients[params["grad"]]
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, target)
						hair_choice.customize_feature(new_hair, target, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE
		if("nat_color")
			var/new_gradient_color = color_pick_sanitized(target, "Choose your natural gradient color", "Secondary Natural Hair Gradient Color", target.hair_color)
			if(new_gradient_color)
				var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_entry/hair/hair_entry = new()

					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = sanitize_hexcolor(new_gradient_color, 6, TRUE)
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, target)
						hair_choice.customize_feature(new_hair, target, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE
		if("dye_color")
			var/new_gradient_color = color_pick_sanitized(target, "Choose your third gradient hair color", "Third Hair Gradient Color", target.hair_color)
			if(new_gradient_color)
				var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)

					var/datum/customizer_entry/hair/hair_entry = new()

					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = sanitize_hexcolor(new_gradient_color, 6, TRUE)
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, target)
						hair_choice.customize_feature(new_hair, target, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE
	if(should_update)
		target.update_hair()
		target.update_body()
		target.update_body_parts()
		return TRUE

