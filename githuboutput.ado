*cap prog drop githuboutput
prog githuboutput
	syntax [anything]  [, language(str) all in(str) quiet Number(numlist max=1)] 
	cap qui summarize installable
	local N 1
	local max `r(max)'
	if "`max'" == "" local max 0
	
	if !missing("`debug'") {
		di as txt "{title:Part one is done!}"
	}
	// -----------------------------------------------------------------------
	// Drawing the output table
	// =======================================================================
	
	// make sure one of the observations is installable 
	if `c(N)' > 0 & `max' != 0 | `c(N)' > 0 & !missing("`all'") {
		di in text _n " {hline 82}" _n												///
		"  {bf:Repository}" _col(19) "{bf:Username}" _col(31) "{bf:Install}" 	///
		_col(40) "{bf:Description} "  _n 	///
		" {hline 82}"
		
		// limit the output
		if missing("`number'") local number `c(N)'
		
		while `N' <= `c(N)' & `N' <= `number' {
			
			// check the language
			if !missing("`language'") & "`language'" == language[`N'] |			///
			missing("`language'") | "`language'" == "all" & address[`N'] != "" {		
				if installable[`N'] == 1 | !missing("`all'") {
					local address : di address[`N']
					
					// checking for dependencies
					// =========================================================
					capture confirm variable dependency
					if _rc {
						capture githubdependency `address'
						local dependency `r(dependency)'
					}
					else {
						local dependency dependency[`N']
					}
					
					
					local pushed : di %tcCCYY-NN-DD pushed[`N']
					
					local short : di abbrev(name[`N'], 15) 
					
					tokenize `address', parse("/")
					local user : di abbrev(`"`1'"', 11) 
					
					local homepage : di homepage[`N']
					local homeabbrev : di abbrev(`"`homepage'"', 30)
				
					
					*local user : di address[`N']
					*local short : di abbrev(name[`N'], 15) 
					
					
					
					di `"  {bf:{browse "http://github.com/`address'":`short'}}"' ///
					_col(19) `"{browse "http://github.com/`1'":`user'}"' _c
					
					local install : di installable[`N']
					if "`install'" == "1" {
						di _col(31) "{stata github install `address':Install}" _c
					}
					else {
						di _col(31) "" _c
						*di _col(29) "({stata github install `address', force:{it:force}})" _c
					}
					
					// Description
					// ------------------------------------
					local score: di %5.0f score[`N']
					*if `score' > 100 {
					*	local score: di %5.0f score[`N']
					*}
					local star : di star[`N']
					local fork : di fork[`N']
					local size : di kb[`N']
					local lang : di language[`N']
					
					// get label
	*				local valuelabel :label (language) `lang'
	*				if "`valuelabel'" != "" local lang `valuelabel'
			
					local description : di description[`N']

					if length(`"`macval(description)'"') <= 5 {
						local description "No description, website, or topics provided."
					}
					else {
						local description : subinstr local description "`" "'", all
					}
					

					local l : di length(`"`macval(description)'"')
					local n 1
					local end 1
					
					tokenize `"`macval(description)'"'
					local sentence "`1'"
					local c 2
					
					local len 0
					local len2 0

					while `l' > 0 & `"``c''"' != "" {
						while `len2' <= 44 & `"``c''"' != "" {
							local sentence : di `"`sentence' ``c''"'
							local len : di strlen(`"`sentence'"') 
							local c `++c'
							local sentence2 : di `"`sentence' "' `"``c''"'
							local len2 : di strlen(`"`sentence2'"') 
						}
						local l`n' : di `"`sentence'"'
						local sentence  //RESET
						local sentence2 //RESET
						local len2    0 //RESET
						local l = `l'-`len'
						local n `++n'
					}

					if `"`l1'"' != "" di _col(40) `"`l1'"'
					
					//Add the package size
					*if trim(`"`l1'"') != "" {
					if "`install'" == "1" & trim(`"`l1'"') != "" {
						di _col(31) "{it:`size'k}" _c
					}
					//else {
					else if "`install'" == "1" {
						local alternative 1
					}
					local l1 //RESET
					local m 2
					
					// continue with the description
					while `m' <= `n' {
						if `"`l`m''"' != "" di _col(39) `"`l`m''"' 
						local l`m' //RESET
						local m `++m'
					}
					
					// Add the Homepage
					// -----------------------------------------------------------
					if `"`homepage'"' != "" {
						di _col(40) `"homepage {browse "`homepage'":`homeabbrev'}"'
						local homepage //RESET
					}
					
					// Add the last update
					// -----------------------------------------------------------
					di _col(40) `"updated on `pushed'"'
					
					// Add the additional description
					// -----------------------------------------------------------
					di _col(40) "{bf:Fork:}" trim("`fork'") _col(50) "{bf:Star:}" 		///
					trim("`star'") _c 
					
					if !missing("`lang'") {
						di _col(60) "{bf:Lang:}" trim("`lang'") _c
					}	
					
					if `dependency' == 1 {
						if "`alternative'" == "1" {
							di _col(72) `"({browse "http://github.com/`address'/blob/master/dependency.do":dependency})"' 
						}
						else {
							di _col(72) `"({browse "http://github.com/`address'/blob/master/dependency.do":dependency})"' _n
						}
					}	
					else {
						if "`alternative'" == "1" {
							di _col(77)  
						}
						else {
							di _col(77) _n 
						}
					}	
					
					//Add the package size if the description was empty
					if "`alternative'" == "1"  {
						di _col(31) "{it:`size'k}" _n
						local alternative //RESET
					}
				}
			}
			local N `++N'
		}
		
		di " {hline 82}"
	}
	else if missing("`quiet'") & "`language'" != "all" & "`in'" != "name,description,readme" {
		di as txt _n "repository {bf:`anything'} was not found for {bf:in(`in')} and {bf:language(`language')}" 
		di "{p}try: {stata github search `anything', in(all) language(Stata) all}" 
	}
	else if missing("`quiet'") {
		di as txt _n "repository {bf:`anything'} was not found for {bf:in(`savein')} and {bf:language(`language')}" 
		if missing("`all'") {
			di "{p}try: {stata github search `anything', in(all) language(Stata) all}"  
		}
	}
	
end
