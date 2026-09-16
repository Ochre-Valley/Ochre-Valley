/area/rogue/indoors/remote_sanctuary
	name = "Remote Sanctuary"
	icon_state = "eora"
	droning_sound = 'sound/music/area/peace.ogg'
	droning_sound_dusk = 'sound/music/area/peace.ogg'
	droning_sound_night = 'sound/music/area/peace.ogg'
	deathsight_message = "a normally unreachable, remote location that cannot see the sky"

/area/rogue/indoors/remote_sanctuary/running_water_sounds
	spookysounds = AMB_CAVEWATER
	spookynight = AMB_CAVEWATER

/area/rogue/indoors/remote_sanctuary/cave
	name = "Remote Sanctuary"
	icon_state = "cave"
	droning_sound = 'sound/music/area/caves.ogg'
	droning_sound_dusk = 'sound/music/area/caves.ogg'
	droning_sound_night = 'sound/music/area/caves.ogg'
	spookysounds = AMB_GENCAVE
	spookynight = AMB_GENCAVE
	deathsight_message = "a normally unreachable, remote location in a cave"

// Outdoor areas

/area/rogue/outdoors/remote_sanctuary
	name = "Remote Sanctuary"
	icon_state = "exposed"
	droning_sound = 'sound/music/area/peace.ogg'
	droning_sound_dusk = 'sound/music/area/peace.ogg'
	droning_sound_night = 'sound/music/area/peace.ogg'
	deathsight_message = "a normally unreachable, remote location with a view of the sky"
	converted_type = /area/rogue/indoors/remote_sanctuary

/area/rogue/outdoors/remote_sanctuary/mountains
	icon_state = "mountains"
	spookysounds = AMB_MOUNTAIN
	spookynight = AMB_MOUNTAIN

