// OV File

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
