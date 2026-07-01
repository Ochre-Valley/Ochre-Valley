// OV File

/obj/projectile/bullet/reusable/bullet
	damage = 40 // Lower than a broadhead arrow, but the embedding behavior makes up for it.
	hitsound = 'sound/combat/hits/hi_bolt (3).ogg'
	armor_penetration = PEN_BSTEEL
	npc_simple_damage_mult = 2.5

// Give the firer experience for shooting living targets.
/obj/projectile/bullet/reusable/bullet/on_hit(atom/target)
    ..()
    var/mob/living/L = firer
    if(!L?.mind)
        return
    
    var/skill_multiplier = 0
    if(isliving(target))
        var/mob/living/T = target
        if(T.stat != DEAD)
            skill_multiplier = 4
    
    if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/firearms, SKILL_LEVEL_EXPERT))
        L.mind.add_sleep_experience(/datum/skill/combat/firearms, L.STAINT * skill_multiplier)

/obj/item/ammo_casing/caseless/rogue/bullet
	name = "arquebus shot"
	desc = "A small metal sphere to be fired from a gun."
	dropshrink = 0.9
	embedding = list(
		"embedded_fall_chance" = 0, // It's not coming out on its own.
		"embedded_pain_multiplier" = 6,
		"embedded_fall_pain_multiplier" = 10, // Shouldn't happen, but let's cover our bases.
		"embedded_impact_pain_multiplier" = 12,
		"embedded_unsafe_removal_pain_multiplier" = 20, // Pretty metal but also a bad idea. A surgeon can do this without hurting you.
		"embedded_unsafe_removal_time" = 30, // No time to dig your fingers in around the bullet in a melee.
		"embedded_bloodloss" = 1
	)
