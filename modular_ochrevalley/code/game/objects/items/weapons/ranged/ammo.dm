// OV File

// Arrows
/obj/projectile/bullet/reusable/arrow/silver
    is_silver_proj = TRUE // Vampyres, nitebeasts, and deadites can handle the shaft but not the tip.
    poisontype = null // No need to inject the target with holy water now.
    poisonamount = null

// Bolts
/obj/projectile/bullet/reusable/bolt/holy
    is_silver_proj = TRUE // This one is silver and has holy water in it.

/obj/projectile/bullet/reusable/bolt/silver
    is_silver_proj = TRUE
    poisontype = null
    poisonamount = null

// Heavy Bolts
// This one has a silver body too. No touching, vampyres!
/obj/projectile/bullet/reusable/heavy_bolt/silver
    is_silver_proj = TRUE
    poisontype = null
    poisonamount = null

// Black Powder
/obj/projectile/bullet/reusable/bullet
	damage = 40 // Lower than a broadhead arrow, but the embedding behavior makes up for it.
	hitsound = 'sound/combat/hits/hi_bolt (3).ogg'
	armor_penetration = PEN_BSTEEL
	npc_simple_damage_mult = 2.5

/obj/projectile/bullet/reusable/bullet/silver
	name = "silver ball"
	damage = 40
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/silver

// This lets a bullet item transfer special effects to the target when the bullet projectile hits; e.g., silver bullets setting deadites on fire.
/obj/projectile/bullet/reusable/bullet/on_hit(atom/target, blocked)
	. = ..()
	if(blocked != 100 && ismob(target))
		var/mob/living/M = target
		if(isitem(src.dropped))
			var/obj/item/I = src.dropped
			var/mob/living/shooter
			if(ismob(src.firer))
				shooter = firer
			I.do_special_attack_effect(src.firer, src.def_zone, null, M, shooter?.zone_selected)

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

/obj/item/ammo_casing/caseless/rogue/bullet/silver
	name = "silver arquebus shot"
	desc = "A small silver sphere. This should go well inside vampyres, nitebeasts, and deadites."
	projectile_type = /obj/projectile/bullet/reusable/bullet/silver
	icon = 'icons/roguetown/weapons/ranged/sling_mob.dmi'
	icon_state = "silverbullet"
	is_silver = TRUE
