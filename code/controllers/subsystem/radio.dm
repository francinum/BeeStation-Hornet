SUBSYSTEM_DEF(radio)
	name = "Radio"
	flags = SS_NO_FIRE|SS_NO_INIT

	var/list/datum/radio_frequency/frequencies = list()
	var/list/saymodes = list()

/datum/controller/subsystem/radio/PreInit(timeofday)
	for(var/_SM in subtypesof(/datum/saymode))
		var/datum/saymode/SM = new _SM()
		saymodes[SM.key] = SM
	return ..()

/datum/controller/subsystem/radio/proc/add_object(obj/device, new_frequency as num, filter = null as text|null)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]
	if(!frequency)
		frequencies[f_text] = frequency = new(new_frequency)
	frequency.add_listener(device, filter)
	return frequency

/datum/controller/subsystem/radio/proc/remove_object(obj/device, old_frequency)
	var/f_text = num2text(old_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]
	if(frequency)
		frequency.remove_listener(device)
		// let's don't delete frequencies in case a non-listener keeps a reference
	return 1

/datum/controller/subsystem/radio/proc/return_frequency(new_frequency as num)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]
	if(!frequency)
		frequencies[f_text] = frequency = new(new_frequency)
	return frequency

/*
	So here's how this is supposed to work


	Frequency Banding

	Special: 0-20
	Do no special processing, act like legacy system. Immediately and blindly broadcast to client radios.COMSIG_RADIO_NEW_FREQUENCY

	LF: 20.1 - 89.9
	"Long Range" communications, (primarily an NSV concept) Implimented here as

	RF: 90.1 - 199.9
	Broadcasts to the current zone. 'zone' being defined by `ZTRAIT_COMMZONE`

	HF: 200.1 - 299.9
	Broadcasts to the current Z-Level strictly.

	Subspace: 300.1+
	Not technically valid radio channels. Bands at this frequency are too tight to be used over the air.
	Used for zone trunking and ultra-secure radios.


	Physical Component

	Encryption keys are now Radio Transcievers, all-in-one boxes capable of handling radio signals directly.
	9 times out of 10 though, you'll be interacting with them as a human, and through a radio.
	To this end, obj/item/radio has been stripped back to function as a middle manager for various radio keys.
	[Writing this before I've done most of the work, but hopefully it should...] Saycode will forward the prefix attempted to the radio itself
	Keys will present their extension to the headset which will select based on the valid and accessible prefixes.
*/