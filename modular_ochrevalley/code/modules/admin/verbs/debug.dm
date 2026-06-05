/client/proc/add_remove_spell(mob/living/carbon/human/H)	
	switch(alert(usr, "Add or remove a spell from [H.name]?", "Add/Remove Spell", "Add", "Remove", "Cancel"))
		if("Add")
			var/list/spells = list()
			for(var/path in subtypesof(/datum/action/cooldown/spell))
				var/datum/action/cooldown/spell/S = path
				spells["[initial(S.name)] ([path])"] = path
			for(var/path in subtypesof(/obj/effect/proc_holder))
				var/obj/effect/proc_holder/S = path
				spells["[initial(S.name)] ([path])"] = path
			var/selected = tgui_input_list(usr,"Select Spell to Add", "Spell Adder", sortList(spells))
			if(!selected)
				return
			var/path = spells[selected]
			var/spell = new path
			if(spell)
				H.mind.AddSpell(spell, H)
				message_admins("[key_name_admin(usr)] has granted [selected] to [ADMIN_LOOKUPFLW(H)].")
				log_admin("[key_name(usr)] has granted [selected] to [key_name(H)].")
		if("Remove")
			var/spell = tgui_input_list(usr,"Select Spell to Remove", "Spell Remover", H.mind.spell_list)
			if(spell)
				var/spell_name = null
				if(istype(spell, /datum/action))
					var/datum/action/S = spell
					spell_name = S.name
				else if(istype(spell, /obj))
					var/obj/S = spell
					spell_name = S.name
				H.mind.RemoveSpell(spell)
				message_admins("[key_name_admin(usr)] has removed [spell_name] from [ADMIN_LOOKUPFLW(H)].")
				log_admin("[key_name(usr)] has removed [spell_name] from [key_name(H)].")
