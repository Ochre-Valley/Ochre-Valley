//** LORE **//

// Lux puppets are inferior artifice of local Z-cultists or worn-down old facilities of former Zizo facilities dotting Azuria. They are maleovent and have a certain feral intelligence,
// but ultimately cannot compare to true Constructs, having no volition or will of their own. They purely function on the desires of others, be it ancient directives given to them by
// long-gone masters or insane Artificers who wish for new test subjects. All in all, they are a rather rare, but unsavoury expression of 'progress', an obedient warrior and butcherer
// for their betters - while the Lux that fuels their limbs screams in anguish, horrified over what is happening. Sometimes, they break that out.
// Spooky!!

//** ARCHETYPES **//

/datum/npc_archetype/lux_puppet
	abstract_type = /datum/npc_archetype/lux_puppet
	job = "Lux Puppet"
	category = FACTION_BANDITS
	faction_tag = "Lux_puppets"
	threat_point = THREAT_DANGEROUS
	body = /datum/npc_body/lux_puppet
	armor_training = ARMOR_CLASS_HEAVY
	traits = list(TRAIT_STEELHEARTED, TRAIT_DUALWIELDER)
	melee = SKILL_LEVEL_EXPERT
	brawl = SKILL_LEVEL_EXPERT
	survival = SKILL_LEVEL_APPRENTICE
	athletics = SKILL_LEVEL_JOURNEYMAN

/datum/npc_archetype/lux_puppet/lesser //Unarmed fellas in decaying gear. Old and worn down.
	name = "Decaying Lux Puppet"
	statpack = /datum/npc_statpack/light/t2 // Speedier but fragile.
	skills = (/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT)
	loadout = list(
		/datum/npc_loadout/armor/light/decaying_puppet,
		/datum/npc_loadout/weapon/decaying_puppet,
		/datum/npc_loadout/kit/lux_puppet
	)


/datum/npc_archetype/lux_puppet/fresh //Better equipped and maintained. Oh no. Carries weapons.



/datum/npc_archetype/lux_puppet/greater //Avantyne. Bad news. Leader units. Danger!


//** BODY **//

/datum/npc_body/lux_puppet
	aggro_lines_file = "modular_ochrevalley/strings/rt/luxpuppetaggrolines.txt"

/datum/npc_body/lux_puppet/get_head_sellprice()
	return HEAD_BOUNTY_DESERTER

/datum/npc_body/lux_puppet/greater/get_head_sellprice()
	return HEAD_BOUNTY_BIG_GUY

//** GEAR **//

/datum/npc_loadout/armor/light/decaying_puppet
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy

//** WEAPONS **//

/datum/npc_loadout/weapon/decaying_puppet
	weapons = list(
		list(/obj/item/rogueweapon/katar/bronze, /obj/item/rogueweapon/katar/bronze)
		list(/obj/item/rogueweapon/handclaw, /obj/item/rogueweapon/handclaw)
		list(/obj/item/rogueweapon/katar/punchdagger, /obj/item/rogueweapon/katar/punchdagger)
	)

