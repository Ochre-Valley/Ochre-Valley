/datum/action/cooldown/spell/hypnotic_gaze
	name = "Hypnotic Command"
	desc = "Pry at a target's mind and plant a command, if they submit to your authority."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "transfix"
	sound = 'sound/magic/timestop.ogg'

	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 2
	var/post_cast_channel_time = 3 SECONDS

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 1
	charge_slowdown = 3
	charge_sound = null
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	point_cost = 0
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/hypnotic_gaze/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	if(!isliving(cast_on))
		return FALSE
	var/mob/living/target = cast_on
	if(!caster || target == caster || target.stat != CONSCIOUS || !target.client)
		return FALSE
	if(target_has_blocked_hypnotic_command(caster, target))
		return FALSE
	if(caster.cmode || target.cmode)
		return FALSE
	if(spell_guard_check(target))
		return FALSE

	var/datum/status_effect/hypnotic_gaze/existing_command = target.has_status_effect(/datum/status_effect/hypnotic_gaze)
	if(existing_command && (!caster.mind || existing_command.original_caster_mind != caster.mind))
		if(target_has_blocked_hypnotic_command(caster, target))
			return FALSE
		if(caster.cmode || target.cmode)
			return FALSE
		var/original_caster_name = existing_command.original_caster_name
		if(!original_caster_name)
			original_caster_name = "another caster"
		var/original_intelligence_at_attempt = existing_command.original_caster_intelligence
		var/mob/original_caster_at_attempt = existing_command.original_caster_mind?.current
		if(isliving(original_caster_at_attempt))
			var/mob/living/living_original_caster_at_attempt = original_caster_at_attempt
			original_intelligence_at_attempt = living_original_caster_at_attempt.get_stat(STATKEY_INT)
		var/breaker_intelligence = caster.get_stat(STATKEY_INT)
		var/known_original_caster_name = original_caster_name
		if(breaker_intelligence < 15)
			known_original_caster_name = "another caster"
		to_chat(caster, span_notice("You await [target.real_name]'s choice on whether to break [known_original_caster_name]'s Hypnotic Command."))
		var/takeover_consent = tgui_alert(target, "[caster.real_name] is trying to break [original_caster_name]'s Hypnotic Command. Will you help break their hold?", "Break Hypnotic Command", list("Leave It", "Break It"))
		if(target_has_blocked_hypnotic_command(caster, target))
			return FALSE
		if(caster.cmode || target.cmode)
			return FALSE
		if(takeover_consent != "Break It")
			to_chat(caster, span_warning("[target.real_name]'s mind refuses other commands; [known_original_caster_name]'s Hypnotic Command remains."))
			return FALSE

		to_chat(caster, span_notice("[target.real_name]'s mind is open to a new command, but [known_original_caster_name]'s command may still overpower yours."))
		var/breaker_identity = "Someone"
		if(original_intelligence_at_attempt >= 15)
			breaker_identity = caster.real_name
		notify_hypnotic_command_original(existing_command, "[breaker_identity] is trying to pry [target.real_name] free of your Hypnotic Command.")
		if(!do_after(caster, 10 SECONDS, needhand = FALSE, target = target))
			to_chat(caster, span_warning("Your attempt to break [known_original_caster_name]'s command is interrupted."))
			if(!QDELETED(target))
				to_chat(target, span_notice("The struggle over your mind is broken off; [original_caster_name]'s command remains."))
			notify_hypnotic_command_original(existing_command, "[breaker_identity]'s attempt to break your Hypnotic Command over [target.real_name] was interrupted.")
			return FALSE

		if(QDELETED(caster) || QDELETED(target) || target.stat == DEAD)
			if(!QDELETED(existing_command))
				notify_hypnotic_command_original(existing_command, "[breaker_identity]'s attempt to break your Hypnotic Command over [target.real_name] failed before the struggle could resolve.")
			return FALSE
		if(target_has_blocked_hypnotic_command(caster, target))
			return FALSE
		if(caster.cmode || target.cmode || QDELETED(existing_command) || target.has_status_effect(/datum/status_effect/hypnotic_gaze) != existing_command)
			if(!QDELETED(existing_command))
				notify_hypnotic_command_original(existing_command, "[breaker_identity]'s attempt to break your Hypnotic Command over [target.real_name] failed before the struggle could resolve.")
			return FALSE

		var/original_intelligence = existing_command.original_caster_intelligence
		var/mob/original_caster = existing_command.original_caster_mind?.current
		if(isliving(original_caster))
			var/mob/living/living_original_caster = original_caster
			original_intelligence = living_original_caster.get_stat(STATKEY_INT)

		var/original_roll = rand(1, 20) + original_intelligence
		var/new_caster_roll = rand(1, 20) + caster.get_stat(STATKEY_INT)
		var/needed_roll = original_roll + 1
		to_chat(caster, span_notice("Your contest: [new_caster_roll] against [original_roll]. You needed [needed_roll] or higher to break the command."))
		if(new_caster_roll <= original_roll)
			to_chat(caster, span_warning("[known_original_caster_name]'s command overpowers your attempt to wrench [target.real_name]'s mind free."))
			to_chat(target, span_notice("[original_caster_name]'s command holds firm against [caster.real_name]'s attempt to break it."))
			notify_hypnotic_command_original(existing_command, "[breaker_identity] tried to break your Hypnotic Command over [target.real_name], but your hold prevailed.")
			return FALSE

		var/break_notification = "Your Hypnotic Command over [target.real_name] has been broken by [breaker_identity]."
		notify_hypnotic_command_original(existing_command, break_notification)
		qdel(existing_command)
		to_chat(caster, span_notice("You break [known_original_caster_name]'s hold over [target.real_name]'s mind."))
		to_chat(target, span_notice("[caster.real_name] tears [original_caster_name]'s command from your thoughts."))

	if(!do_after(caster, post_cast_channel_time, needhand = FALSE, target = target))
		to_chat(caster, span_warning("Your attempt to influence [target.real_name]'s mind is interrupted."))
		if(!QDELETED(target))
			to_chat(target, span_notice("You slip free of [caster.real_name]'s mental influence before it can take hold."))
		return FALSE

	if(target_has_blocked_hypnotic_command(caster, target))
		return FALSE
	if(caster.cmode || target.cmode)
		return FALSE
	var/initial_consent = tgui_alert(target, "[caster.real_name] is trying to pry their way into your mind and hypnotize you. Do you resist or submit to their authority?", "Hypnotic Command Consent", list("Resist", "Submit"))
	if(target_has_blocked_hypnotic_command(caster, target))
		return FALSE
	if(caster.cmode || target.cmode)
		return FALSE
	if(initial_consent != "Submit")
		notify_hypnotic_gaze_declined(caster, target)
		return FALSE

	if(QDELETED(caster) || QDELETED(target) || target.stat == DEAD)
		return FALSE

	var/datum/status_effect/hypnotic_gaze_pending/pending = target.apply_status_effect(/datum/status_effect/hypnotic_gaze_pending)
	if(!pending)
		to_chat(caster, span_warning("Your grasp cannot find purchase in [target.real_name]'s mind."))
		return FALSE

	var/command = tgui_input_text(caster, "What command will you press into [target.real_name]'s mind?", "Plant a Command", max_length = MAX_MESSAGE_LEN, multiline = TRUE, encode = FALSE)
	if(QDELETED(caster) || QDELETED(target) || QDELETED(pending) || target.stat == DEAD)
		if(!QDELETED(pending))
			qdel(pending)
		return FALSE
	if(isnull(command) || !length(trim(command)))
		qdel(pending)
		to_chat(caster, span_notice("You release your hold before a command takes root."))
		to_chat(target, span_notice("[caster.real_name]'s grasp loosens; your mind slips free, unmarked."))
		return FALSE

	var/safe_command = html_encode(trim(command))
	if(target_has_blocked_hypnotic_command(caster, target))
		qdel(pending)
		return FALSE
	if(caster.cmode || target.cmode)
		qdel(pending)
		return FALSE
	var/command_consent = tgui_alert(target, "[caster.real_name] presses these words against your thoughts:\n\n\"[safe_command]\"\n\nWill you let the command take root, or resist their grasp?", "A Command Takes Root", list("Resist", "Submit"))
	if(target_has_blocked_hypnotic_command(caster, target))
		qdel(pending)
		return FALSE
	if(caster.cmode || target.cmode)
		qdel(pending)
		return FALSE
	if(command_consent != "Submit")
		qdel(pending)
		notify_hypnotic_gaze_declined(caster, target)
		return FALSE

	if(QDELETED(caster) || QDELETED(target) || QDELETED(pending) || target.stat == DEAD)
		if(!QDELETED(pending))
			qdel(pending)
		return FALSE

	qdel(pending)
	var/datum/status_effect/hypnotic_gaze/effect = target.apply_status_effect(/datum/status_effect/hypnotic_gaze, trim(command), caster.mind, caster.get_stat(STATKEY_INT), caster.real_name)
	if(!effect)
		to_chat(caster, span_warning("Your grasp on [target.real_name]'s mind slips before the command can take root."))
		to_chat(target, span_warning("You wrench your mind free before the command can take root."))
		return FALSE

	target.playsound_local(target, 'sound/magic/necra_sight.ogg', 100)
	caster.playsound_local(caster, 'sound/magic/necra_sight.ogg', 100)
	to_chat(target, span_big("The command rings through my mind in [caster.real_name]'s voice: <font color=#7246ff><i>\"[safe_command]\"</i></font>"))
	to_chat(caster, span_big("You press the command into [target.real_name]'s mind: <font color=#7246ff><i>\"[safe_command]\"</i></font>"))
	return TRUE

/datum/action/cooldown/spell/hypnotic_gaze/proc/target_has_blocked_hypnotic_command(mob/living/caster, mob/living/target)
	if(!target || QDELETED(target) || !target.client || !hypnotic_gaze_is_blocked(target.client))
		return FALSE
	if(caster && !QDELETED(caster))
		to_chat(caster, span_warning("[target.real_name] has Hypnotic Command consent prompts disabled."))
	return TRUE

/datum/action/cooldown/spell/hypnotic_gaze/proc/notify_hypnotic_gaze_declined(mob/living/caster, mob/living/target)
	if(caster && !QDELETED(caster))
		to_chat(caster, span_warning("[target.real_name] resists your attempt to pry into their mind."))
	if(target && !QDELETED(target))
		to_chat(target, span_notice("You wrench your mind free of [caster.real_name]'s grasp. Nothing further takes hold."))

/datum/action/cooldown/spell/hypnotic_gaze/proc/notify_hypnotic_command_original(datum/status_effect/hypnotic_gaze/effect, message)
	if(!effect || QDELETED(effect) || !effect.original_caster_mind || QDELETED(effect.original_caster_mind))
		return
	var/mob/original_caster = effect.original_caster_mind.current
	if(original_caster && !QDELETED(original_caster))
		to_chat(original_caster, span_warning("[message]"))

/datum/status_effect/hypnotic_gaze_pending
	id = "hypnotic_gaze_pending"
	duration = -1
	tick_interval = -1
	needs_processing = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/hypnotic_gaze_pending
	// var/datum/status_effect/incapacitating/immobilized/created_immobilization

// /datum/status_effect/hypnotic_gaze_pending/on_apply()
// 	. = ..()
// 	if(!. || owner.IsImmobilized())
// 		return
// 	created_immobilization = owner.apply_status_effect(STATUS_EFFECT_IMMOBILIZED, -1, TRUE)
//
// /datum/status_effect/hypnotic_gaze_pending/on_remove()
// 	if(created_immobilization && !QDELETED(created_immobilization))
// 		qdel(created_immobilization)
// 	. = ..()

// Removed for now due to concerns with immobilization. I or someone can uncomment later if wanting it back.

/atom/movable/screen/alert/status_effect/hypnotic_gaze_pending
	name = "Mind Awaiting a Command"
	desc = "My thoughts are held open, awaiting a command."
	icon_state = "coke"

/datum/status_effect/hypnotic_gaze
	id = "hypnotic_gaze"
	duration = -1
	tick_interval = 15 MINUTES
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/hypnotic_gaze
	var/command
	var/datum/mind/original_caster_mind
	var/original_caster_intelligence
	var/original_caster_name

/datum/status_effect/hypnotic_gaze/on_creation(mob/living/new_owner, new_command, datum/mind/new_original_caster_mind, new_original_caster_intelligence, new_original_caster_name)
	command = new_command
	original_caster_mind = new_original_caster_mind
	original_caster_intelligence = new_original_caster_intelligence
	original_caster_name = new_original_caster_name
	. = ..()
	if(.)
		update_command_alert()

/datum/status_effect/hypnotic_gaze/tick()
	owner.playsound_local(owner, 'sound/magic/necra_sight.ogg', 100)
	to_chat(owner, span_big("[html_encode(original_caster_name)]'s command echoes back into my thoughts: <font color=#7246ff><i>\"[html_encode(command)]\"</i></font>"))

/datum/status_effect/hypnotic_gaze/proc/update_command_alert()
	if(!linked_alert)
		return
	linked_alert.name = "Hypnotic Command"
	linked_alert.desc = "[html_encode(original_caster_name)]'s command has taken root in my thoughts: \"[html_encode(command)]\""
	linked_alert.icon_state = "coke"

/atom/movable/screen/alert/status_effect/hypnotic_gaze
	name = "Hypnotic Command"
	desc = ""
	icon_state = "coke"

/obj/item/book/granter/spell/bonechill/hypnotic_gaze
	name = "Scroll of Hypnotic Command"
	spell = /datum/action/cooldown/spell/hypnotic_gaze
	spellname = "Hypnotic Command"
	icon_state = "scrolldarkred"
	oneuse = TRUE
	remarks = list()

/obj/item/book/granter/spell/bonechill/hypnotic_gaze/loadout
	needLit = FALSE
	pages_to_mastery = 0

/datum/loadout_item/hypnotic_gaze_scroll
	name = "Scroll of Hypnotic Command"
	path = /obj/item/book/granter/spell/bonechill/hypnotic_gaze/loadout

// straight up slapping my belly
