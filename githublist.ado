
prog githublist
	
	syntax [anything] [, language(str) save(str) in(str) all created(str) 		///
	pushed(str) duration(numlist max=1) replace append quiet] 
	
	// Packages before 2012
	// ======================================================================
	githubsearch `anything', created("<2012-01-01") language(`language') 			///
	in(`in') `all' save("`save'") append quiet
	
	// Packages after 2012
	// ======================================================================
	githubsearchsteps stata, reference("2012-01-01") duration(`duration') 				///
	language(`language') in(`in') `all'  save("`save'") append quiet
	
	// -----------------------------------------------------------------------
	// Drawing the output table
	// =======================================================================
	if missing("`quiet'") {
		preserve
		if !missing(`"`save'"') {
			use "`save'", clear 
		}	
		githuboutput `anything', in("`in'") `all' quiet
		restore
	}

end 


