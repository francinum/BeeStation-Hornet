// Ensure the frequency is within bounds of what it should be sending/receiving at
/proc/sanitize_frequency(frequency, free = FALSE, band)
	. = round(frequency)
	switch(band)
		if(RADIO_BAND_SPECIAL)
			. = CLAMP(frequency, RADIO_MIDBAND_CIVIL_MIN, RADIO_MIDBAND_CIVIL_MAX)

		if(RADIO_BAND_LF)
			. = CLAMP(frequency, RADIO_LOWBAND_MIN, RADIO_LOWBAND_MAX)

		if(RADIO_BAND_RF)
			if(!free)
				. = CLAMP(frequency, RADIO_MIDBAND_CIVIL_MIN, RADIO_MIDBAND_CIVIL_MAX)
			else
				. = CLAMP(frequency, RADIO_MIDBAND_MIN, RADIO_MIDBAND_MAX)

		if(RADIO_BAND_HF)
			. = CLAMP(frequency, RADIO_HIFBAND_MIN, RADIO_HIFBAND_MAX)

		if(RADIO_BAND_SUB)
			if(!free)
				. = CLAMP(frequency, RADIO_MIDBAND_CIVIL_MIN, RADIO_MIDBAND_CIVIL_MAX)
			else
				. = CLAMP(frequency, RADIO_MIDBAND_MIN, RADIO_MIDBAND_MAX)

	if(!(. % 2)) // Ensure the last digit is an odd number
		. += 1

// Format frequency by moving the decimal.
/proc/format_frequency(frequency)
	frequency = text2num(frequency)
	return "[round(frequency / 10)].[frequency % 10]"

//Opposite of format, returns as a number
/proc/unformat_frequency(frequency)
	frequency = text2num(frequency)
	return frequency * 10

/datum/controller/subsystem/radio/proc/verify_band(check_frequency as num, check_band as num)
	var/correct_band
	switch(check_frequency)
		if(RADIO_SPECIAL_MIN to RADIO_SPECIAL_MAX)
			correct_band = RADIO_BAND_SPECIAL

		if(RADIO_LOWBAND_MIN to RADIO_LOWBAND_MAX)
			correct_band = RADIO_BAND_LF

		if(RADIO_MIDBAND_MIN to RADIO_MIDBAND_MAX)
			correct_band = RADIO_BAND_RF

		if(RADIO_HIFBAND_MIN to RADIO_HIFBAND_MAX)
			correct_band = RADIO_BAND_HF

		if(RADIO_SUBBAND_MIN to RADIO_SUBBAND_MAX)
			correct_band = RADIO_BAND_SUB
		else
			throw EXCEPTION("Out of band radio signal!")

	if(check_band == correct_band)
		return TRUE
	else
		return FALSE