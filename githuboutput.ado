// works withe the data in the memory

*cap prog drop githuboutput
prog githuboutput
	
	syntax [anything] [, all in(str)]
	
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
		di in text _n " {hline 80}" _n												///
		"  {bf:repository}" _col(17) "{bf:Author}" _col(29) "{bf:Install}" 	///
		_col(38) "{bf:Description} "  _n 	///
		" {hline 80}"
		
		while `N' <= `c(N)' {
			
			if installable[`N'] == 1 | !missing("`all'") {
				local address : di address[`N']
				local short : di abbrev(name[`N'], 13) 
				
				tokenize `address', parse("/")
				local user : di abbrev("`1'", 11) 
				
				capture githubdependency `address'
				
				*local user : di address[`N']
				*local short : di abbrev(name[`N'], 15) 
				
				
				
				di `"  {bf:{browse "http://github.com/`address'":`short'}}"' ///
				_col(17) `"{browse "http://github.com/`1'":`user'}"' _c
				
				local install : di installable[`N']
				if "`install'" == "1" {
					di _col(29) "{stata github install `address', replace:Install}" _c
				}
				else {
					di _col(29) "" _c
				}
				
				// Description
				// ------------------------------------
				local score: di %5.0f score[`N']
				*if `score' > 100 {
				*	local score: di %5.0f score[`N']
				*}
				local star : di star[`N']
				local size : di kb[`N']
				local lang : di language[`N']
				
				// get label
				local valuelabel :label (language) `lang'
				if "`valuelabel'" != "" local nme `valuelabel'
		
				local description : di description[`N']
				local l : di length(`"`description'"')
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

				if `"`l1'"' != "" di _col(38) `"`l1'"'
				
				//Add the package size
				if "`install'" == "1" & trim(`"`l1'"') != "" {
					di _col(29) "{it:`size'k}" _c
				}
				else {
					local alternative 1
				}
				local l1 //RESET
				local m 2
				
				// continue with the description
				while `m' <= `n' {
					if `"`l`m''"' != "" di _col(37) `"`l`m''"' 
					local l`m' //RESET
					local m `++m'
				}
				di _col(38) "{bf:Hits:}" trim("`score'") _col(49) "{bf:Stars:}" 		///
				trim("`star'") _c 
				
				if !missing("`nme'") {
					di _col(58) "{bf:Lang:}" trim("`nme'") _c
				}	
				
				if `r(dependency)' == 1 {
					di _col(74) /*"{bf:Dep:}"*/ `"({browse "http://github.com/`address'/blob/master/dependency.do":Depend})"' _n
				}	
				else {
					di _col(75)  //"{bf:Dep:}" "No" _n
				}	
				
				//Add the package size if the description was empty
				if "`alternative'" == "1"  {
					di _col(29) "{it:`size'k}" _c
					local alternative //RESET
				}
				
				di _n
				
			}
			local N `++N'
		}
		
		di " {hline 80}"
	}
	else if "`savelang'" != "all" & "`in'" != "name,description,readme" {
		di as txt "repository {bf:`anything'} was not found for {bf:in(`in')} and {bf:language(`savelang')}" 
		di "try: {stata github search `anything', in(all) language(all) all}" 
	}
	else {
		di as txt "repository {bf:`anything'} was not found for {bf:in(`savein')} and {bf:language(`savelang')}" 
		if missing("`all'") {
			di "try: {stata github search `anything', in(all) language(all) all}" 
		}
	}
	
end

