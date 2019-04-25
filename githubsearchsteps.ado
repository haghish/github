
*capture prog drop githubsearchsteps
program githubsearchsteps
	
	syntax [anything] [, language(str) save(str) in(str) all created(str) 		///
	reference(str) duration(numlist max=1) pushed(str) Number(numlist max=1) 	///
	delay(numlist max=1) append replace quiet debug]
	
	if missing("`reference'") {
		di as txt "(the default time reference is used which is {bf:2016-01-01})"
		local reference "2016-01-01"
	}
	if missing("`duration'") {
		local duration 30
	}
	if missing("`delay'") {
		local delay 10000
	}
	
	local stopdate: display date(c(current_date), "DMY")

	local reference : display date("`reference'","YMD")
	local future `reference'
	
	local n 0							// indicator of the first dataset
	
	while `stopdate' >= `future' {
		
		local reference `future'
		local future = `reference' + `duration'
		
		// prepare the dates for API
		// -------------------------
		local reference : di %tdCCYY-NN-DD `reference'
		local future : di %tdCCYY-NN-DD `future'
		
		if missing("`quiet'") display as txt "from  `reference'  to  `future'"
		
		sleep `delay'
		capture noisily githubsearch `anything', language(`language') save(`"`save'"') in(`in')	///
		`all' created("`reference'..`future'") pushed("`pushed'") quiet			///
		`append' `replace'
		
		while _rc {
			di as err "the GitHub API is not responsive right now. Try again in 10 or 20 seconds. this can happen if you search GitHub very frequent..."
			sleep `delay'
			capture noisily githubsearch `anything', language(`language') save(`"`save'"') in(`in')	///
		`all' created("`reference'..`future'") pushed("`pushed'") quiet			///
		`append' `replace'
		}
	
		// return the value of date back to numeric
		local future : display date("`future'","YMD")
	}
	
	// -----------------------------------------------------------------------
	// Drawing the output table
	// =======================================================================
	if missing("`quiet'") {
		githuboutput `anything', in("`in'") `all'
	}

end


