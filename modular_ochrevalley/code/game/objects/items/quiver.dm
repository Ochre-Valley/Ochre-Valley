// OV File

// Black Powder
/obj/item/quiver/bulletpouch/silver/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bullet/silver/A = new()
		arrows += A
	update_icon()
