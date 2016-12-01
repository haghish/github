
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
		quietly gen score = (watchers*5 + star*5 + fork) - 5
		quietly replace score = 0 if score < 0
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

