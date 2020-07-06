/obj/item/encryptionkey
	name = "standard encryption key"
	desc = "An encryption key for a radio headset."
	icon = 'icons/obj/radio.dmi'
	icon_state = "cypherkey"
	w_class = WEIGHT_CLASS_TINY


	//Special Capabilities
	var/translate_binary = FALSE 	//AS MUCH AS I'D LOVE TO IMPROVE THIS. I'M NOT TOUCHIN THIS HOT HORSE PISS
	var/syndie = FALSE				//Not sure if I'll use this still. The station isn't intended to manufacture subspace capable keys
	var/dummy = FALSE 				//Key serves only it's special purpose.
	//var/independent = FALSE //Outdated


	//Generic Capabilities
	var/frequency		//Raw frequency value to broadcast on, MUST BE INSIDE THE RANGE OF THE BANDCLASS
	var/bandclass 		//Used to determine if the radio is programmed to a valid frequency for it's band.
	var/prefix 			//Single-character prefix. Special characters technically allowed.
	var/output_span		//Visual spanclass, only used by special keys. Custom keys SHOULD NOT be able to have this set for safety reasons.
	var/output_color	//Overridden by output_span

/obj/item/encryptionkey/Initialize()
	. = ..()
	if(dummy)
		return
	SSradio.add_object(src, frequency)

/obj/item/encryptionkey/examine(mob/user)
	. = ..()

	if(!dummy)
		. += "<span class='notice'>The text [frequency]://[prefix] is printed on the board.</span>"
	if(output_span)
		. += "<span class='nicegreen'>The output is processed by an unmarked, NT branded chip.</span>"
	else if(output_color)
		. += "<span class='notice'>The output is processed by a generic color-map chip labeled: [output_color]</span>"
	else
		. += "<span class='rose'>The postprocessing pads are not populated.</span>"

	if(translate_binary)
		. += "<span class='notice'>The encoder chip has been replaced, the new chip has been labeled <span class='italics'>NTSCII LUT v0.1</span>.</span>"
	/*
	if(LAZYLEN(channels))
		var/list/examine_text_list = list()
		for(var/i in channels)
			examine_text_list += "[GLOB.channel_tokens[i]] - [lowertext(i)]"

		. += "<span class='notice'>It can access the following channels; [jointext(examine_text_list, ", ")].</span>"
*/

/*
 * Vocal Input
 */

/obj/item/encryptionkey/proc/voice_input()

/obj/item/encryptionkey/proc/voice_output()
//Do all the transformations related to spans and color, or if necessary just pass it down the fucking chain to generate message.