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

	//Radio Connection
	var/radio_connection

/obj/item/encryptionkey/Initialize()
	. = ..()
	if(dummy)
		return
	radio_connection = SSradio.add_object(src, frequency)

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
 *
 * Okay this is gonna get messy. This code is a mixture of KMC's mess for his squad system on NSV, and my own investigation.
 *
 * On input: Discard as much as fucking possible.
 *
 * An aside on protocols: Legibility Convention.
 * A few protocols are 'internal only' and should either be silently ignored by protocol number, or generate a message explicitly stating that protocol is unreadable.
 * This is to prevent, say, invalid radio messaged with arbitrary speech spans which can be *very* dangerous.
 * Anything that down-the-line allows the creation of arbitary signals should follow the conventions.
 *
 * We pass the message down to the headset with only a few bits of essential data: the languge, the color, and the message itself.
 *
 * Treat the message's spans.
 *
 */

 //(atom/movable/M, message, mode, list/spans, datum/language/language, radio_prefix)
 //(M, message, spans, language)
/obj/item/encryptionkey/proc/voice_input(atom/movable/M, message, list/spans, datum/language/language, command=FALSE)
	var/datum/signal/sig = new(list("protocol" = NETWORK_PROTOCOL_VOICE, "message" = message, "audio_meta" = spans, "speaker" = M, "language" = language, "command" = command)) //basic structure.
	radio_connection.post_signal(src, sig)

/obj/item/encryptionkey/receive_signal(datum/signal/signal)
	//I have no idea how I'm going to do the band checking.
	//Verify a few things about the packet.
	if(signal.data["protocol"] != NETWORK_PROTOCOL_VOICE)
		return
	//Implicitly trust packets to be valid as long as their protocol header is valid. Protect against runtimes as much as possible but only so much can really be done.
	voice_output(signal["speaker"],signal["message"],signal["audio_meta"], signal["language"], signal["command"])

/obj/item/encryptionkey/proc/voice_output(atom/movable/M, message, list/spans, datum/language/language, command)
	if(QDELETED(M))
		return //With all the passing going on here this is possible. Maybe.
	attach_spans(message, spans)//The internal message is now wrapped in it's spans. Now we just do our own processing.
	var/span_prefix
	if(output_span)
		span_prefix = "<span class=\"[output_span] [command ? "command_headset" : ""]\">"
	else if(output_color)
		span_prefix = "<span style=\"color:[output_color]\" class=\"[command ? "command_headset" : ""]\">"
	message = "[span_prefix]<b>\[[M.GetVoice()]</b> says, \"[msg]\"</span>"
	#warn Headset audio out is half-baked and unfinished
//Do all the transformations related to spans and color, or if necessary just pass it down the fucking chain to generate message.