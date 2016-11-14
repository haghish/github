
cap prog drop githublist
program githublist
	
	syntax [anything] [, language(str) save(str) in(str) all created(str) 		///
	reference(str) duration(numlist max=1) pushed(str) Number(numlist max=1)]
	
	if missing("`anything'") {
		local anything stata
	}
	if missing("`reference'") {
		di as txt "(the default time reference is used which is {bf:2016-01-01})"
		local reference "2016-01-01"
	}
	if missing("`duration'") {
		local duration 30
	}
	//get the current date
	*local today: display %td_CCYY-NN-DD date(c(current_date), "DMY")
	local today: display date(c(current_date), "DMY")
	
	local reference : display date("`reference'","YMD")
	local future `reference'
	
	local n 0							// indicator of the first dataset
	
	while `today' > `future' {
		
		local reference `future'
		local future = `reference' + `duration'
		
		// prepare the dates for API
		// -------------------------
		local reference : di %tdCCYY-NN-DD `reference'
		local future : di %tdCCYY-NN-DD `future'
		
		*di as err "`reference'..`future'"
		
		sleep 3000
		githubsearch `anything', language(`language') save(`"__`save'"') in(`in')	///
		`all' created("`reference'..`future'") pushed("`pushed'") 
		
		// create the data set
		if !missing("`save'") {
			capture findfile "__`save'.dta"
			if _rc == 0 & `n' == 0 {
				quietly copy `"__`save'.dta"' `"`save'.dta"' , replace
				capture quietly erase `"__`save'.dta"'
				local n 1
			}
			else if _rc == 0 & `n' == 1 {
				preserve
				qui use `"`save'"', clear
				append using "__`save'"
				qui saveold `"`save'"', replace
				capture quietly erase `"__`save'"'
				restore
			}
		}
		
		// return the value of date back to numeric
		local future : display date("`future'","YMD")
	}
	
	// avoid duplications
	// ------------------
	/*
	capture findfile `"`save'.dta"'
	if _rc == 0 {
		preserve
		qui use `"`save'"', clear
		qui duplicates drop address, force
		qui saveold `"`save'"', replace
		restore
	}
	*/

end

*githublist stata, reference("2016-02-21") duration(90) language(stata) in(all) all  save("new")
githublist, reference("2016-09-01")  in(all) save(ok)
