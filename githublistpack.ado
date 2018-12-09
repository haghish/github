
prog githublistpack
	
	syntax [anything] [, language(str) save(str) in(str) all created(str) 		///
	pushed(str) reference(str) duration(numlist max=1) replace append quiet debug] 
	
	// Packages before 2012
	// ======================================================================
	if missing("`reference'") {
		local reference "2012-01-01"
		if missing("`quiet'") display "<2012-01-01"
		githubsearch `anything', created("<2012-01-01") language(`language') 	///
		in(`in') `all' save("`save'") append quiet scoreless `quiet' `debug'
	}
	
	
	// Packages after the reference (default is 2012-01-01)
	// ======================================================================
	githubsearchsteps `anything', reference("`reference'") duration(`duration') ///
	language(`language') in(`in') `all'  save("`save'") append `quiet' `debug'
	
	preserve
	
	// Generate score
	// ======================================================================
	if !missing(`"`save'"') {
		use "`save'", clear 
		qui label data "updated on `c(current_date)'"
		qui save `"`save'"', replace
	}	
		
	// -----------------------------------------------------------------------
	// Drawing the output table
	// =======================================================================
	if missing("`quiet'") {
		githuboutput `anything', in("`in'") `all' quiet
	}
	
	restore

end 

