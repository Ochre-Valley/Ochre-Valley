//OV FILE
//This is where everything that fits nowhere else goes? I think? Who really knows so who really cares.
#define span_orange(str) ("<span class='orange'>" + str + "</span>")
//#define span_yellow(str) ("<span class='yellow'>" + str + "</span>") //Outdated Per AP Merge 5.8.26
#define span_details(title, content) ("<details>"+"<summary>" + title + "</summary>" + content + "</details>")

// Incapacitation flags, used by the mob/proc/incapacitated() proc
#define INCAPACITATION_RESTRAINED 1
#define INCAPACITATION_BUCKLED_PARTIALLY 2
#define INCAPACITATION_BUCKLED_FULLY 4
#define INCAPACITATION_STUNNED 8
#define INCAPACITATION_FORCELYING 16 //needs a better name - represents being knocked down BUT still conscious.
#define INCAPACITATION_KNOCKOUT 32
#define INCAPACITATION_NONE 0


#define PLANE_FULLSCREEN		90 //Blindness, mesons, druggy, etc
