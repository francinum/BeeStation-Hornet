// Used for translating channels to tokens on examination
GLOBAL_LIST_INIT(channel_tokens, list(
	RADIO_CHANNEL_COMMON = RADIO_KEY_COMMON,
	RADIO_CHANNEL_SCIENCE = RADIO_TOKEN_SCIENCE,
	RADIO_CHANNEL_COMMAND = RADIO_TOKEN_COMMAND,
	RADIO_CHANNEL_MEDICAL = RADIO_TOKEN_MEDICAL,
	RADIO_CHANNEL_ENGINEERING = RADIO_TOKEN_ENGINEERING,
	RADIO_CHANNEL_SECURITY = RADIO_TOKEN_SECURITY,
	RADIO_CHANNEL_CENTCOM = RADIO_TOKEN_CENTCOM,
	RADIO_CHANNEL_SYNDICATE = RADIO_TOKEN_SYNDICATE,
	RADIO_CHANNEL_SUPPLY = RADIO_TOKEN_SUPPLY,
	RADIO_CHANNEL_SERVICE = RADIO_TOKEN_SERVICE,
	MODE_BINARY = MODE_TOKEN_BINARY,
	RADIO_CHANNEL_AI_PRIVATE = RADIO_TOKEN_AI_PRIVATE
))

/obj/item/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys."
	icon_state = "headset"
	item_state = "headset"
	materials = list(/datum/material/iron=75)
//	subspace_transmission = TRUE
	canhear_range = 0 // can't hear headsets from very far away
	var/bang_protect = 0 //this isn't technically clothing so it needs its own bang_protect var

	slot_flags = ITEM_SLOT_EARS
	dog_fashion = null

/obj/item/radio/headset/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins putting \the [src]'s antenna up [user.p_their()] nose! It looks like [user.p_theyre()] trying to give [user.p_them()]self cancer!</span>")
	return TOXLOSS

/obj/item/radio/headset/examine(mob/user)
	. = ..()

	if(item_flags & IN_INVENTORY && loc == user)
		// construction of frequency description
		var/list/avail_chans = list()
		if(defaultkey)
			avail_chans += "The default prefix ; will currently broadcast on [defaultkey.frequency/10]"
		if(translate_binary)
			avail_chans += "use ?b for Binary"
		for(var/obj/item/encryptionkey/key in encryptionkeys)
			if(!istype(key))
				continue
			if(key.dummy)
				continue
			avail_chans += "use :[key.prefix] for [key.frequency]"
			#warn consider adding a 'channel name' string to keys for this.
		. += "<span class='notice'>A small screen on the headset displays the following available frequencies:\n[english_list(avail_chans)].</span>"

		if(command)
			. += "<span class='info'>Alt-click to toggle the high-volume mode.</span>"
	else
		. += "<span class='notice'>A small screen on the headset flashes, it's too small to read without holding or wearing the headset.</span>"

/obj/item/radio/headset/Initialize()
	. = ..()
	recalculateChannels()

/obj/item/radio/headset/Destroy()
	QDEL_NULL(keyslot2)
	return ..()

/obj/item/radio/headset/talk_into(mob/living/M, message, channel, list/spans,datum/language/language)
	if (!listening)
		return ITALICS | REDUCE_RANGE
	return ..()

/*
/obj/item/radio/headset/can_receive(freq, level, AIuser)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.ears == src)
			return ..(freq, level)
	else if(AIuser)
		return ..(freq, level)
	return FALSE
*/ #warn can_receive is now handled by the encryption keys.
/obj/item/radio/headset/ui_data(mob/user)
	. = ..()
	.["headset"] = TRUE

/obj/item/radio/headset/syndicate //disguised to look like a normal headset for stealth ops

/obj/item/radio/headset/syndicate/alt //undisguised bowman with flash protection
	name = "syndicate headset"
	desc = "A syndicate headset that can be used to hear all radio frequencies. Protects ears from flashbangs."
	icon_state = "syndie_headset"
	item_state = "syndie_headset"
	bang_protect = 1

/obj/item/radio/headset/syndicate/alt/leader
	name = "team leader headset"
	command = TRUE

/obj/item/radio/headset/syndicate/Initialize()
	. = ..()
//	make_syndie()
#warn make_syndicate init
/obj/item/radio/headset/binary

/obj/item/radio/headset/binary/Initialize()
	. = ..()
	encryptionkeys += new /obj/item/encryptionkey/dummy/binary
	recalculateChannels()

/obj/item/radio/headset/headset_sec
	name = "security radio headset"
	desc = "This is used by your elite security force."
	icon_state = "sec_headset"
	encryptionkeys = list(new /obj/item/encryptionkey/medium/security)
/*
/obj/item/radio/headset/headset_medsec
	name = "medical-security radio headset"
	desc = "Used to hear how many security officers need to be stiched back together."
	icon_state = "medsec_headset"
	keyslot = new /obj/item/encryptionkey/headset_medsec
*/#warn medical department headset
/obj/item/radio/headset/headset_sec/alt
	name = "security bowman headset"
	desc = "This is used by your elite security force. Protects ears from flashbangs."
	icon_state = "sec_headset_alt"
	item_state = "sec_headset_alt"
	bang_protect = 1

/obj/item/radio/headset/headset_eng
	name = "engineering radio headset"
	desc = "When the engineers wish to chat like girls."
	icon_state = "eng_headset"
	encryptionkeys = list(new /obj/item/encryptionkey/medium/engineering)

/obj/item/radio/headset/headset_rob
	name = "robotics radio headset"
	desc = "Made specifically for the roboticists, who cannot decide between departments."
	icon_state = "rob_headset"
	encryptionkeys = list(new /obj/item/encryptionkey/medium/science, new /obj/item/encryptionkey/medium/engineering)

/obj/item/radio/headset/headset_med
	name = "medical radio headset"
	desc = "A headset for the trained staff of the medbay."
	icon_state = "med_headset"
	encryptionkeys = list(new /obj/item/encryptionkey/medium/medical)

/obj/item/radio/headset/headset_sci
	name = "science radio headset"
	desc = "A sciency headset. Like usual."
	icon_state = "sci_headset"
	encryptionkeys = list(new /obj/item/encryptionkey/medium/science)

/obj/item/radio/headset/headset_medsci
	name = "medical research radio headset"
	desc = "A headset that is a result of the mating between medical and science."
	icon_state = "medsci_headset"
	encryptionkeys = list(new /obj/item/encryptionkey/medium/medical, new /obj/item/encryptionkey/medium/science)

/obj/item/radio/headset/headset_srvsec
	name = "law and order headset"
	desc = "In the criminal justice headset, the encryption key represents two separate but equally important groups. Sec, who investigate crime, and Service, who provide services. These are their comms."
	icon_state = "srvsec_headset"
	encryptionkeys = list(new /obj/item/encryptionkey/medium/service, new /obj/item/encryptionkey/medium/security)

/obj/item/radio/headset/headset_com
	name = "command radio headset"
	desc = "A headset with a commanding channel."
	icon_state = "com_headset"
	encryptionkeys = list(new /obj/item/encryptionkey/medium/command)

/obj/item/radio/headset/heads
	command = TRUE

#warn oh god the captain's going to need to have some special bullshit for all his fucking keys good fuck, not doing that right now
/*
/obj/item/radio/headset/heads/captain
	name = "\proper the captain's headset"
	desc = "The headset of the king."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/captain

/obj/item/radio/headset/heads/captain/alt
	name = "\proper the captain's bowman headset"
	desc = "The headset of the boss. Protects ears from flashbangs."
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	bang_protect = 1

/obj/item/radio/headset/heads/rd
	name = "\proper the research director's headset"
	desc = "Headset of the fellow who keeps society marching towards technological singularity."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/rd

/obj/item/radio/headset/heads/hos
	name = "\proper the head of security's headset"
	desc = "The headset of the man in charge of keeping order and protecting the station."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/hos

/obj/item/radio/headset/heads/hos/alt
	name = "\proper the head of security's bowman headset"
	desc = "The headset of the man in charge of keeping order and protecting the station. Protects ears from flashbangs."
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	bang_protect = 1

/obj/item/radio/headset/heads/ce
	name = "\proper the chief engineer's headset"
	desc = "The headset of the guy in charge of keeping the station powered and undamaged."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/ce

/obj/item/radio/headset/heads/cmo
	name = "\proper the chief medical officer's headset"
	desc = "The headset of the highly trained medical chief."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/cmo

/obj/item/radio/headset/heads/hop
	name = "\proper the head of personnel's headset"
	desc = "The headset of the guy who will one day be captain."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/hop
*/
/obj/item/radio/headset/headset_cargo
	name = "supply radio headset"
	desc = "A headset used by the QM and his slaves."
	icon_state = "cargo_headset"
	encryptionkeys = list(new /obj/item/encryptionkey/medium/supply)

/obj/item/radio/headset/headset_cargo/mining
	name = "mining radio headset"
	desc = "Headset used by shaft miners."
	icon_state = "mine_headset"
	encryptionkeys = list(new /obj/item/encryptionkey/medium/science, new /obj/item/encryptionkey/medium/supply)

/obj/item/radio/headset/headset_srv
	name = "service radio headset"
	desc = "Headset used by the service staff, tasked with keeping the station full, happy and clean."
	icon_state = "srv_headset"
	encryptionkeys = list(new /obj/item/encryptionkey/medium_service)

/obj/item/radio/headset/headset_cent
	name = "\improper CentCom headset"
	desc = "A headset used by the upper echelons of Nanotrasen."
	icon_state = "cent_headset"
	encryptionkeys = list(new /obj/item/encryptionkey/medium/command, new /obj/item/encryptionkey/subspace/centcom)

/obj/item/radio/headset/headset_cent/empty
	encryptionkeys = null

#warn centcom commander headset needs captain key
/obj/item/radio/headset/headset_cent/commander
//	keyslot = new /obj/item/encryptionkey/heads/captain
	encryptionkeys = list(new /obj/item/encryptionkey/subspace/centcom)

/obj/item/radio/headset/headset_cent/alt
	name = "\improper CentCom bowman headset"
	desc = "A headset especially for emergency response personnel. Protects ears from flashbangs."
	icon_state = "cent_headset_alt"
	item_state = "cent_headset_alt"
	encryptionkeys = null
	bang_protect = 1

/obj/item/radio/headset/silicon/pai
	name = "\proper mini Integrated Subspace Transceiver "
	subspace_transmission = FALSE

#warn AI headset crap
/obj/item/radio/headset/silicon/ai
	name = "\proper Integrated Subspace Transceiver "
//	keyslot2 = new /obj/item/encryptionkey/ai
	command = TRUE

/obj/item/radio/headset/silicon/can_receive(freq, level)
	return ..(freq, level, TRUE)

/obj/item/radio/headset/attackby(obj/item/W, mob/user, params)
	//user.set_machine(src) //I hope to god this isn't necessary anymore.

	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(encryptionkeys.len)
			var/selected_key = input(user, "Select a key to remove.", "headset keyslots") as null|anything in encryptionkeys
			if(!selected_key)
				return //cancelled
			user.put_in_hands(selected_key)
			encryptionkeys -= selected_key
			recalculateChannels()
			to_chat(user, "<span class='notice'>You pop out [selected_key] from the headset.</span>")
		else
			to_chat(user, "<span class='warning'>This headset doesn't have any encryption keys!  How useless...</span>")

	else if(istype(W, /obj/item/encryptionkey))
		if(encryptionkeys.len >= max_keys)
			to_chat(user, "<span class='warning'>The headset can't hold any more keys!</span>")
			return
		if(!user.transferItemToLoc(W, src))
			return
		encryptionkeys += W

		recalculateChannels()
	else
		return ..()

#warn hopefully I don't need any of this at this level anymore.
/*
/obj/item/radio/headset/recalculateChannels()
	..()
	if(keyslot2)
		for(var/ch_name in keyslot2.channels)
			if(!(ch_name in src.channels))
				channels[ch_name] = keyslot2.channels[ch_name]

		if(keyslot2.translate_binary)
			translate_binary = TRUE
		if(keyslot2.syndie)
			syndie = TRUE
		if (keyslot2.independent)
			independent = TRUE

	for(var/ch_name in channels)
		secure_radio_connections[ch_name] = add_radio(src, GLOB.radiochannels[ch_name])
*/
/obj/item/radio/headset/AltClick(mob/living/user)
	if(!istype(user) || !Adjacent(user) || user.incapacitated())
		return
	if (command)
		use_command = !use_command
		to_chat(user, "<span class='notice'>You toggle high-volume mode [use_command ? "on" : "off"].</span>")
