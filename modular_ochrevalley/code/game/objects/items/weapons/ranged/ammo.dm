// Overrides files in code/game/objects/items/rogueweapons/ranged so we can balance these how we want to.

// ------------------
// PROJECTILE OBJECTS
// ------------------

// Firearms
/obj/projectile/bullet/reusable/bullet
	name = "bullet"
	damage = 90 // Same as heavy crossbow.
	damage_type = BRUTE
	icon_state = "slingbullet_proj" // Good enough.
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet
	range = 30 // Range is actually determined by the gun, not the bullet. This is a backup value.
	hitsound = 'sound/combat/hits/hi_bolt (3).ogg'
	embedchance = 100
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	armor_penetration = PEN_BSTEEL // Same as heavy crossbow.
	speed = 0.1 // Nearly hitscan.
	npc_simple_damage_mult = 5 // Same as heavy crossbow. (Honestly I think this might be a little high even for heavy crossbows, but whatever. Change it if this causes issues. -Ace)
	wall_impact_break_probability = 100 // Same as heavy crossbow. Bullets will shatter if they hit a wall. With a range of 30, this will almost ALWAYS happen if you miss, so don't miss!
	damages_turf_walls = FALSE // Bullets lack the mass to meaningfully damage walls.

/obj/projectile/bullet/reusable/bullet/on_hit(atom/target) // EXP for shooting live targets only.
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

// Not implimented yet; see below.
/obj/projectile/bullet/reusable/bullet/silver
	name = "silver shot"
	icon_state = "shotslugsilv"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/silver
	is_silver_proj = TRUE

// ------------
// AMMO OBJECTS
// ------------

// Firearms
/obj/item/ammo_casing/caseless/rogue/bullet
	name = "ball shot"
	desc = "A small metal sphere that is to be shot out of a firearm. It probably would not survive a direct hit to a wall."
	projectile_type = /obj/projectile/bullet/reusable/bullet
	caliber = "musketball"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "shotslug"
	dropshrink = 0.6 // The new icons can be shrunk without becoming invisible.
	possible_item_intents = list(/datum/intent/use)
	max_integrity = 0.1

// Not implimented yet; no crafting recipe.
/obj/item/ammo_casing/caseless/rogue/bullet/silver
	name = "silver shot"
	desc = "A small metal sphere that is to be shot out of a firearm. It probably would not survive a direct hit to a wall.</br>Purported to've originally been crafted by one of Grenzelhoft's finest monster hunters."
	projectile_type = /obj/projectile/bullet/reusable/bullet/silver
	icon_state = "shotslugsilv"
	is_silver = TRUE
	is_lesser_silver = TRUE
