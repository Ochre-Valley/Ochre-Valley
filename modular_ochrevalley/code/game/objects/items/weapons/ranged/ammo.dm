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
