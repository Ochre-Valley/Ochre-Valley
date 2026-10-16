// Sanctuary portal creation returns
/// The sanctuary portals were created without issue
#define SANCTUARY_PORTAL_SUCCESSFUL 1
/// One or more portals to and from this KEYMASTER already exist!
#define SANCTUARY_PORTAL_ERROR_PORTALSALREADYEXIST 2
/// We found unobstructed places to spawn the portals, but there were mobs in the way of all of them! (We don't want to make a portal on top of a mob!)
#define SANCTUARY_PORTAL_ERROR_MOBSINWAY 3
/// There were no turfs available around one or both of the KEYMASTERs due to none of the turfs being non-obstructed (i.e. dense objects, dense turfs, etc.)
#define SANCTUARY_PORTAL_ERROR_OBSTRUCTEDTURFS 4
/// There were no turfs available around one or both of the KEYMASTERs due to none of the turfs being safe (i.e. traps and spikes in the way)
#define SANCTUARY_PORTAL_ERROR_DANGEROUSTURFS 5
