/obj/item/encryptionkey/special
	bandclass = RADIO_BAND_SPECIAL

/obj/item/encryptionkey/special/ctfred
	name = "red ctf encryption key"
	frequency = 0011
	prefix = "r"
	output_color = "#ff0000"

/obj/item/encryptionkey/special/ctfred
	name = "blu ctf encryption key"
	frequency = 0011
	prefix = "b"
	output_color = "#0000ff"
/*
 * Subspace Keys
 */

/obj/item/encryptionkey/subspace
	bandclass = RADIO_BAND_SUB

/obj/item/encryptionkey/subspace/syndicate
	name = "syndicate encryption key"
	icon_state = "syn_cypherkey"
	frequency = 3011
	prefix = "t"
	output_color = "#6d3f40"

/obj/item/encryptionkey/subspace/centcom
	name = "\improper CentCom radio encryption key"
	icon_state = "cent_cypherkey"
	frequency = 3013
	prefix = "t" //Haha.
	output_color = "#686868"
/*
 * Dummy (Non-Radio) Keys
 */

//I fucking hate this thing.
/obj/item/encryptionkey/dummy/binary
	name = "binary translator key"
	icon_state = "bin_cypherkey"
	translate_binary = TRUE

/*
 * Medium (Radio Frequency) Keys
 */

/obj/item/encryptionkey/medium
	bandclass = RADIO_BAND_RF


/obj/item/encryptionkey/medium/security
	name = "security radio encryption key"
	icon_state = "sec_cypherkey"
	frequency =  917
	prefix = "s"
	output_color = "#a30000"

/obj/item/encryptionkey/medium/engineering
	name = "engineering radio encryption key"
	icon_state = "eng_cypherkey"
	frequency =  915
	prefix = "e"
	output_color = "#fb5613"


/obj/item/encryptionkey/medium/medical
	name = "medical radio encryption key"
	icon_state = "med_cypherkey"
	frequency =  913
	prefix = "m"
	output_color = "#337269"


/obj/item/encryptionkey/medium/science
	name = "science radio encryption key"
	icon_state = "sci_cypherkey"
	frequency =  909
	prefix = "n"
	output_color = "#993399"


/obj/item/encryptionkey/medium/command
	name = "command radio encryption key"
	icon_state = "com_cypherkey"
	frequency =  911
	prefix = "c"
	output_color = "#948f02"



/obj/item/encryptionkey/medium/supply
	name = "supply radio encryption key"
	icon_state = "cargo_cypherkey"
	frequency =  905
	prefix = "u"
	output_color = "#a8732b"

/obj/item/encryptionkey/medium/service
	name = "service radio encryption key"
	icon_state = "srv_cypherkey"
	frequency =  907
	prefix = "v"
	output_color = "#6eaa2c"

/obj/item/encryptionkey/medium/aiprivate
	name = "\improper AI Restricted encryption key"
	icon_state = "srvsec_cypherkey"
	frequency = 1447
	prefix = "a"
	output_color = "#ff00ff"

/obj/item/encryptionkey/medium/general
	name = "shared encryption key"
	icon_state = "cypherkey"
	frequency = 1459
	prefix = "g"
	//Uses default output coloration

/*
 * Low Frequency Keys
 */

/obj/item/encryptionkey/low
	bandclass = RADIO_BAND_LF

/*
 * High Frequency Keys
 */

/obj/item/encryptionkey/high
	bandclass = RADIO_BAND_HF