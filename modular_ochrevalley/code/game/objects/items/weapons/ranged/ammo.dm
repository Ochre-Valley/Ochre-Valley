// Overrides files in code/game/objects/items/rogueweapons/ranged so we can balance these how we want to.
#define MIN_OVBULLET_RANGE		2
#define MAX_OVBULLET_RANGE		12 //Siegebow Range
#define DAM_FALLOFF_OVBULLET	0.75
// OV File
/obj/item/ammo_casing/caseless/rogue/bullet
	name = "iron arquebus shot"
	desc = "A small iron sphere to be fired from a gun."
	dropshrink = 0.5 //I think it looks better this way

/obj/projectile/bullet/reusable/bullet
	name = "iron bullet"
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	icon = 'icons/roguetown/weapons/ranged/sling_proj.dmi'
	icon_state = "ironslingbullet_proj"
	//armor_penetration = PEN_HEAVY //Iron bullets are inferior to steel in this way

/obj/item/ammo_casing/caseless/rogue/bullet/bronze
	name = "bronze arquebus shot"
	desc = "A sphere of bronze, etched with myriad intricate patterns. Offers no advantage over iron bullets when shot from a gun, but offers potential improvement through enchantment."
	projectile_type = /obj/projectile/bullet/reusable/bullet/bronze


/obj/projectile/bullet/reusable/bullet/bronze
	name = "bronze bullet"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/bronze
	icon_state = "bronzeslingbullet_proj"

/obj/item/ammo_casing/caseless/rogue/bullet/steel
	name = "steel arquebus shot"
	desc = "An armor-piercing small steel sphere to be fired from a gun"
	projectile_type = /obj/projectile/bullet/reusable/bullet/steel


/obj/projectile/bullet/reusable/bullet/steel
	name = "steel bullet"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/steel
	armor_penetration = PEN_BSTEEL //this is the perk of steel- total armor pen
	icon_state = "steelslingbullet_proj"

/obj/item/ammo_casing/caseless/rogue/bullet/silver
	name = "silver arquebus shot"
	desc = "An armor-piercing silver sphere to be fired from a gun."
	projectile_type = /obj/projectile/bullet/reusable/bullet/silver


/obj/projectile/bullet/reusable/bullet/silver
	name = "silver bullet"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/silver
	armor_penetration = PEN_BSTEEL  //these are hard to make, and come in at lower totals
	is_silver_proj = TRUE
	icon_state = "steelslingbullet_proj"

/obj/item/ammo_casing/caseless/rogue/bullet/ricochet //high engineering recipe made with fairy dust
	name = "shimmering arquebus shot"
	desc = "A small bronze sphere to be fired from a gun. It shimmers with iridescence, and can never seem to sit still. Enchanted rounds shatter on impact"
	projectile_type = /obj/projectile/bullet/scatter/ricochet

/obj/projectile/bullet/scatter/ricochet
	name = "shimmering bullet"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/ricochet
	icon_state = "bronzeslingbullet_proj"
	damage = 40 //on a direct hit, low damage for a gun. after one ricochet, 60 damage- less than other bullets. After two, 90. 135 if it hits on the third ricochet.
	speed = 3.5 //A bullet enchanted with fairy dust. It moves with a mind of its own, easy to dodge, but aims for mobs to hit on banked shots. Does not distinguish friend and foe!
	ricochets_max = 3
	ricochet_chance = 100
	ricochet_auto_aim_angle = 100
	ricochet_auto_aim_range = 30
	ricochet_incidence_leeway = 0
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1.5

/obj/item/ammo_casing/caseless/rogue/bullet/concussive
	name = "concussive arquebus shot"
	desc = "A small bronze sphere to be fired from a gun. It sits heavy in your hand. This round will deal BLUNT damage, shattering armor instead of punching through. Enchanted rounds shatter on impact."
	projectile_type = /obj/projectile/bullet/scatter/concussive
	speed = 3

/obj/projectile/bullet/scatter/concussive
	name = "concussive bullet"
	icon_state = "bronzeslingbullet_proj"
	damage_type = BRUTE
	armor_penetration = PEN_NONE
	woundclass = BCLASS_BLUNT
	intdamfactor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	flag = "blunt"
	speed = 3.5
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/concussive
	damage = 60

/obj/item/ammo_casing/caseless/rogue/bullet/scatter
	name = "scattershot packet"
	desc = "A paper parcel full of iron shards, perfect for launching from a firearm"
	projectile_type = /obj/projectile/bullet/reusable/bullet/scatter
	pellets = 9
	variance = 50

/obj/projectile/bullet/scatter
	name = "iron shard"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/scatter
	armor_penetration = PEN_HEAVY
	damage = 10
	ricochets_max = 0
	ricochet_chance = 0
	min_range = MIN_SCATTER_RANGE
	max_range = 5
	dam_falloff_factor = DAM_FALLOFF_BULLET
	speed = 0.1
	npc_simple_damage_mult = 2
	damage_type = BRUTE
	icon = 'icons/roguetown/weapons/ranged/sling_proj.dmi'
	icon_state = "scatter_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet
	range = 30
	hitsound = 'sound/combat/hits/hi_bolt (3).ogg'
	embedchance = 100


/obj/item/ammo_casing/caseless/rogue/bullet/scatter/steel
	name = "shot cartridge"
	desc = "A paper cartridge full of small, armor-piercing steel balls, perfect for launching from a firearm"
	projectile_type = /obj/projectile/bullet/reusable/bullet/scatter/steel
	pellets = 6
	variance = 30

/obj/projectile/bullet/scatter/steel
	name = "steel shot"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/scatter/steel
	armor_penetration = PEN_BSTEEL
	damage = 15

/obj/item/ammo_casing/caseless/rogue/bullet/scatter/glass
	name = "improvised scattershot packet"
	desc = "A paper packet full of glass shards, to fire from a firearm"
	projectile_type = /obj/projectile/bullet/reusable/bullet/scatter/glass
	pellets = 15
	variance = 70

/obj/projectile/bullet/scatter/glass
	name = "glass fragment"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/scatter/glass
	armor_penetration = PEN_LIGHT
	damage = 5

/obj/item/ammo_casing/caseless/rogue/bullet/scatter/dragonsbreath
	name = "infernal scattershot cartridge"
	desc = "A paper cartridge filled with bronze shards, adulterated with infernal ash. Perfect for use with a firearm"
	projectile_type = /obj/projectile/bullet/reusable/bullet/scatter/dragonsbreath
	pellets = 6

/obj/projectile/bullet/scatter/dragonsbreath //if this turns out excessive, just remove it
	name = "burning shrapnel"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/scatter/dragonsbreath
	armor_penetration = PEN_LIGHT
	damage = 5

/obj/projectile/bullet/scatter/dragonsbreath/on_hit(atom/target) //shamelessly ripped off from sling fire pot code. if any of these bullets causes issues, this will.
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		M.adjust_fire_stacks(1)
		M.adjustFireLoss(5)
		M.ignite_mob()
	var/turf/T = get_turf(target)
	if(T)
		new /obj/effect/hotspot(T, null, null, 15)

// ------------------
// PROJECTILE OBJECTS
// ------------------

// Firearms
/obj/projectile/bullet/reusable/bullet
	name = "bullet"
	damage = 70
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
	npc_simple_damage_mult = 4 // Allows it to keep it's old busted damage vs simple mobs
	wall_impact_break_probability = 100 // Same as heavy crossbow. Bullets will shatter if they hit a wall. With a range of 30, this will almost ALWAYS happen if you miss, so don't miss!
	damages_turf_walls = FALSE // Bullets lack the mass to meaningfully damage walls.
	min_range = MIN_OVBULLET_RANGE
	max_range = MAX_OVBULLET_RANGE
	dam_falloff_factor = DAM_FALLOFF_OVBULLET

/obj/projectile/bullet/reusable/bullet/on_hit(atom/target) // EXP for shooting live targets only.
    ..()
    var/mob/living/L = firer
    if(!L?.mind)
        return
<<<<<<< HEAD
=======

>>>>>>> 8b0d4bbe04 (commit and worke lswhere)
    var/skill_multiplier = 0
    if(isliving(target))
        var/mob/living/T = target
        if(T.stat != DEAD)
            skill_multiplier = 4
<<<<<<< HEAD
=======

>>>>>>> 8b0d4bbe04 (commit and worke lswhere)
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
