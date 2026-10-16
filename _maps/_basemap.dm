//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "map_files\ovdun_world\ochre_CentCom.dmm" //OV EDIT

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\ovdun_world\ovdun_world.dmm" //OV EDIT
		#include "map_files\jagged_jaw\jagged_jaw.dmm"
		#include "map_files\roguetest\roguetest.dmm"
		#include "map_files\otherz\wretch_coast.dmm"

		#ifdef ALL_TEMPLATES
			#include "templates.dm"
		#endif

	#endif
#endif
