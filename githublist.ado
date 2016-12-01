
prog githublist
	
	syntax [anything] [, language(str) save(str) in(str) all created(str) 		///
	pushed(str) duration(numlist max=1) replace append quiet] 
	
	// Packages before 2012
	// ======================================================================
	githubsearch `anything', created("<2012-01-01") language(`language') 		///
	in(`in') `all' save("`save'") append quiet scoreless
	
	// Packages after 2012
	// ======================================================================
	githubsearchsteps stata, reference("2012-01-01") duration(`duration') 		///
	language(`language') in(`in') `all'  save("`save'") append quiet
	
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

