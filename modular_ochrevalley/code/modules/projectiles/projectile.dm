// OV File

/obj/projectile
    // Determine whether the damaging part of this projectile is silver.
    var/is_silver_proj = FALSE

// This is a projectile knock off of the item.do_special_attack_effect proc.
/obj/projectile/proc/do_special_projectile_effect(firer, obj/item/bodypart/affecting, mob/living/victim, selzone)
    SHOULD_CALL_PARENT(TRUE)
    SEND_SIGNAL(victim, COMSIG_PROJECTILE_ATTACK_EFFECT, firer, affecting, selzone, src)
    SEND_SIGNAL(src, COMSIG_PROJECTILE_ATTACK_EFFECT_SELF, firer, affecting, victim, selzone)

    if(is_silver_proj && HAS_TRAIT(victim, TRAIT_SILVER_WEAK))
        SEND_SIGNAL(victim, COMSIG_FORCE_UNDISGUISE)
        to_chat(victim, span_danger("Silver rebukes my presence! My vitae smolders, and my powers wane!"))
        victim.adjust_fire_stacks(1, /datum/status_effect/fire_handler/fire_stacks/sunder) // Ammunition can't be blessed.
        victim.ignite_mob()
