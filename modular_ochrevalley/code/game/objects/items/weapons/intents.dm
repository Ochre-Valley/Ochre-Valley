/datum/intent/sword/thrust/rapier/lungefast
	name = "fast lunge"
	icon_state = "inshank"
	damfactor = 1.1
	penfactor = PEN_MEDIUM

	swingdelay_type = SWINGDELAY_PENALTY //the compromise - normalized damage and lengthier time between swings, BUT it retains two dot stab and your defence isn't super nuked. Let Rapier players still have a response to maille/hardened leather folks

	swingdelay = 0.6 SECONDS
	clickcd = 1.0 SECONDS
