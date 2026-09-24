// Overrides files in code/game/objects/items/rogueweapons/ranged so we can balance these how we want to.
#define MIN_OVBULLET_RANGE		2
#define MAX_OVBULLET_RANGE		12 //Siegebow Range
#define DAM_FALLOFF_OVBULLET	0.5
// OV File

// ------------------
// PROJECTILE OBJECTS
// ------------------

// Firearms
/obj/projectile/bullet/reusable/bullet
	name = "bullet"
	damage = 70
	damage_type = BRUTE
	icon = 'modular_ochrevalley/icons/roguetown/weapons/ranged/arquebus_proj.dmi'
	icon_state = "ironbullet_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet
	range = 30 // Range is actually determined by the gun, not the bullet. This is a backup value.
	hitsound = 'sound/combat/hits/hi_bolt (3).ogg'
	embedchance = 100
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	armor_penetration = PEN_HEAVY
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
    var/skill_multiplier = 0
    if(isliving(target))
        var/mob/living/T = target
        if(T.stat != DEAD)
            skill_multiplier = 4
    if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/firearms, SKILL_LEVEL_EXPERT))
        L.mind.add_sleep_experience(/datum/skill/combat/firearms, L.STAINT * skill_multiplier)

/obj/projectile/bullet/reusable/bullet/bronze
	name = "bronze bullet"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/bronze
	icon_state = "bronzebullet_proj"

/obj/projectile/bullet/reusable/bullet/silver
	name = "silver bullet"
	icon_state = "silverbullet_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/silver
	is_silver_proj = TRUE

/obj/projectile/bullet/scatter
	name = "bronze shard"
	icon = 'modular_ochrevalley/icons/roguetown/weapons/ranged/arquebus_proj.dmi'
	icon_state = "scatter_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/scatter
	armor_penetration = PEN_MEDIUM
	damage = 10
	ricochets_max = 0
	ricochet_chance = 0
	min_range = 1
	max_range = 7
	range = 12
	dam_falloff_factor = DAM_FALLOFF_OVBULLET
	speed = 0.1
	npc_simple_damage_mult = 4
	damage_type = BRUTE
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet
	hitsound = 'sound/combat/hits/hi_bolt (3).ogg'
	embedchance = 100

/obj/projectile/bullet/scatter/iron
	name = "iron shot"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/scatter/iron
	armor_penetration = PEN_HEAVY
	damage = 15

/obj/projectile/bullet/scatter/glass
	name = "glass fragment"
	icon_state = "glassscatter_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/scatter/glass
	armor_penetration = PEN_LIGHT
	max_range = 3
	damage = 5

/obj/projectile/bullet/scatter/hollowpoint
	name = "shattering bronze bullet"
	icon_state = "bronzebullet_proj"
	armor_penetration = PEN_LIGHT
	min_range = MIN_OVBULLET_RANGE
	max_range = MAX_OVBULLET_RANGE
	damage = 70
	flag = BCLASS_PICK //essentially, "old" bullet damage style, but you're not hitting the same level of damage, nor penetration

/obj/projectile/bullet/reusable/bullet/bronze/ricochet
	name = "shimmering bullet"
	icon_state = "ricobullet_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/bronze
	armor_penetration = PEN_HEAVY
	min_range = MIN_OVBULLET_RANGE
	max_range = MAX_OVBULLET_RANGE
	damage = 40 //on a direct hit, low damage for a gun. after one ricochet, 60 damage- less than other bullets. After two, 90. 135 if it hits on the third ricochet.
	speed = 3.5 //A bullet enchanted with fairy dust. It moves with a mind of its own, easy to dodge, but aims for mobs to hit on banked shots. Does not distinguish friend and foe!
	ricochets_max = 3
	ricochet_chance = 100
	ricochet_auto_aim_angle = 100
	ricochet_auto_aim_range = 10
	ricochet_incidence_leeway = 0
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1.5

/obj/projectile/bullet/scatter/dragonsbreath //if this turns out excessive, just remove it
	name = "burning shrapnel"
	icon_state = "burnscatter_proj"
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

/obj/projectile/bullet/reusable/bullet/bronze/concussive
	name = "concussive bullet"
	icon_state = "concbullet_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet/bronze
	damage_type = BRUTE
	armor_penetration = PEN_NONE
	woundclass = BCLASS_BLUNT
	intdamfactor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	min_range = MIN_OVBULLET_RANGE
	max_range = MAX_OVBULLET_RANGE
	flag = "blunt"
	speed = 3.5
	damage = 65
	object_damage_multiplier = 18 //at 65 damage and 18 multiplier, a blunderbus or pistol's damage will destroy most, but not all, wood defenses, whilst a rifle can destroy objects with roughly siegebow equivalence
	damages_turf_walls = TRUE

/obj/projectile/bullet/scatter/concussive/on_hit(target) //somewhere between a siegebow and a heavy sling bullet, but not terribly easy to get
	. = ..()
	var/mob/living/M = target
	if(ismob(target))
		M.visible_message(span_warning("[M] staggers back from the tremendous impact!"))
		M.apply_status_effect(/datum/status_effect/debuff/staggered, 3 SECONDS)
		M.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		M.Slowdown(3)
		M.OffBalance(1 SECONDS)
		M.Immobilize(1 SECONDS)
		var/throw_dir = get_dir(src, target)
		var/atom/throw_target = get_edge_target_turf(M, throw_dir)
		M.safe_throw_at(throw_target, 3, 1)
		return

	var/turf/T = target
	if(isturf(target))
		explosion(T, heavy_impact_range = 0, light_impact_range = 0, flame_range = 0, smoke = FALSE, soundin = pick('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg'))
		loud_message("A loud crash echoes", hearing_distance = 14)
		return

// ------------
// AMMO OBJECTS
// ------------

/obj/item/ammo_casing/caseless/rogue/bullet
	name = "arquebus shot"
	desc = "A small iron sphere to be fired from a gun."
	icon = 'modular_ochrevalley/icons/roguetown/weapons/ammo.dmi'
	icon_state = "ironshot"
	dropshrink = 0.6
	possible_item_intents = list(/datum/intent/use)

/obj/item/ammo_casing/caseless/rogue/bullet/bronze
	name = "bronze arquebus shot"
	desc = "A sphere of bronze, etched with myriad intricate patterns. Offers no advantage over iron bullets when shot from a gun, but offers potential improvement through enchantment."
	icon_state = "runedbronzeshot"
	projectile_type = /obj/projectile/bullet/reusable/bullet/bronze

/obj/item/ammo_casing/caseless/rogue/bullet/bronze/hollowpoint
	name = "crossed bronze arquebus shot"
	desc = "A sphere of bronze, deeply etched in cruciform. Originally a charm of good luck, the cruciform causes the bullet to split on hit, worsening armor penetration, but making much nastier wounds."
	icon_state = "hollowshot"
	projectile_type = /obj/projectile/bullet/scatter/hollowpoint

/obj/item/ammo_casing/caseless/rogue/bullet/silver
	name = "silver arquebus shot"
	desc = "A small metal sphere that is to be shot out of a firearm. It probably would not survive a direct hit to a wall.</br>Purported to've originally been crafted by one of Grenzelhoft's finest monster hunters."
	projectile_type = /obj/projectile/bullet/reusable/bullet/silver
	icon_state = "silvshot"
	is_silver = TRUE
	is_lesser_silver = TRUE

/obj/item/ammo_casing/caseless/rogue/bullet/ricochet //high engineering recipe made with fairy dust
	name = "shimmering arquebus shot"
	desc = "A small bronze sphere to be fired from a gun. It shimmers with iridescence, and can never seem to sit still. Enchanted rounds shatter on impact"
	icon_state = "feyshot"
	projectile_type = /obj/projectile/bullet/reusable/bullet/bronze/ricochet

/obj/item/ammo_casing/caseless/rogue/bullet/concussive
	name = "concussive arquebus shot"
	desc = "A small bronze sphere to be fired from a gun. It sits heavy in your hand. This round will deal BLUNT damage, shattering armor instead of punching through. Enchanted rounds shatter on impact."
	icon_state = "earthshot"
	projectile_type = /obj/projectile/bullet/reusable/bullet/bronze/concussive

/obj/item/ammo_casing/caseless/rogue/bullet/scatter
	name = "scattershot packet"
	desc = "A cloth sachet full of bronze shards, perfect for launching from a firearm"
	icon_state = "bronzescatter"
	projectile_type = /obj/projectile/bullet/scatter
	pellets = 9
	variance = 50

/obj/item/ammo_casing/caseless/rogue/bullet/scatter/iron
	name = "shot cartridge"
	desc = "A cloth sachet full of small, armor-piercing iron balls, perfect for launching from a firearm"
	icon_state = "ironscatter"
	projectile_type = /obj/projectile/bullet/scatter/iron
	pellets = 6
	variance = 30

/obj/item/ammo_casing/caseless/rogue/bullet/scatter/glass
	name = "improvised scattershot packet"
	desc = "A cloth sachet full of glass shards, to fire from a firearm"
	icon_state = "glassscatter"
	projectile_type = /obj/projectile/bullet/scatter/glass
	pellets = 15
	variance = 70

/obj/item/ammo_casing/caseless/rogue/bullet/scatter/dragonsbreath
	name = "infernal scattershot cartridge"
	desc = "A cloth sachet filled with bronze shards, adulterated with infernal ash. Perfect for use with a firearm"
	icon_state = "infernalscatter"
	projectile_type = /obj/projectile/bullet/scatter/dragonsbreath
	pellets = 6
