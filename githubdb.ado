* E. F. Haghish 2018

*cap prog drop githubdb
program githubdb, rclass
	syntax anything, [address(str) username(str) reponame(str) name(str) force(str) version(str)]
	
	// test the database, if it doesn't exist create it!
	capture findfile github.dta, path("`c(sysdir_plus)'g/")
	if _rc {
		preserve
		quietly clear
		tempfile data
		qui generate str10 downloaded = ""
		qui generate str address = ""
		qui generate str username = ""
		qui generate str reponame = ""
		qui generate str name = ""
		qui generate str version = ""
		qui generate str force = ""
		qui save "`c(sysdir_plus)'g/github.dta", replace
		restore
	}
	
	// for versions betwen 1.4.0 to 1.4.5 make sure the data set has these variables:
	// -----------------------------------------------------------------------
	capture findfile github.dta, path("`c(sysdir_plus)'g/")
	if _rc == 0 {
		preserve
		use "`r(fn)'", clear
		cap confirm variable version
		if _rc qui generate str version = ""
		cap confirm variable force
		if _rc qui generate str force   = ""
		qui save "`c(sysdir_plus)'g/github.dta", replace
		restore
	}
	
	// processing the subcommands
	// =========================================================================
	capture findfile github.dta, path("`c(sysdir_plus)'g/")
	if _rc == 0 {
		
		// check 
		// ----------------
		if "`anything'" == "check" {
			if missing("`name'") err 198
			preserve
			use "`r(fn)'", clear
			qui keep if name == "`name'"  
			if _N == 0 {
				di as err "`name' package was not found"
			}
			if _N > 1 {
				di as err "{p}multiple packages with this name are found!"      ///
						"this can be caused if you had installed multiple "     ///
						"packages from different repositories, but with an "    ///
						"identical name..." _n
				list
			}
			if _N == 1 {
				local address : di address[1]
				return local address `address'
			}
			
			restore
		}
		
		// version 
		// ----------------
		if "`anything'" == "version" {
			if missing("`name'") err 198
			preserve
			use "`r(fn)'", clear
			qui keep if name == "`name'"  
			if _N == 0 {
				di as err "`name' package was not found"
			}
			if _N > 1 {
				di as err "{p}multiple packages with this name are found!"      ///
						"this can be caused if you had installed multiple "     ///
						"packages from different repositories, but with an "    ///
						"identical name..." _n
				list
			}
			if _N == 1 {
				local version : di version[1]
				display as txt "`version'"
				return local version `version'
			}
			
			restore
		}
		
		// add 
		// --------------
		if "`anything'" == "add" {
			preserve
			use "`r(fn)'", clear
			qui drop if address == "`address'"  // clean the database
			local nextN : di _N + 1
			qui set obs `nextN' 
			qui replace downloaded = "$S_DATE"  in `nextN'
			qui replace address = "`address'"   in `nextN'
			qui replace username = "`username'" in `nextN'
			qui replace reponame = "`reponame'" in `nextN'
			qui replace name = "`name'"         in `nextN'
			qui replace version = "`version'"   in `nextN'
			qui replace force = "`force'"       in `nextN'
			qui save "`c(sysdir_plus)'g/github.dta", replace
			restore
		}
		
		// erase
		// --------------
		if "`anything'" == "erase" {
			preserve
			use "`r(fn)'", clear
			if missing("`name'") err 198
			quietly drop if name == "`name'"  // clean the database
			qui save "`c(sysdir_plus)'g/github.dta", replace
			restore
		}
		
		// list 
		// ---------------
		if "`anything'" == "list" {
			preserve
			use "`r(fn)'", clear
			
			// update the database if a package is removed without github uninstall
			// --------------------------------------------------------------------
			
			// get the list of packages from stata.trk
			qui findfile "stata.trk"
			tempname hitch2 
			file open `hitch2' using "`r(fn)'", read
			file read `hitch2' line
			local pkglist ""
			while r(eof) == 0 {
				if substr(`"`macval(line)'"', 1,2) == "N " {
					local newline : di substr(`"`macval(line)'"', 2,.)
					local newline : subinstr local newline ".pkg" "", all
					tokenize `"`macval(newline)'"' , parse(" ")
					if "`pkglist'" != "" local pkglist "`pkglist' `1'"
					else local pkglist "`1'"
				} 
				file read `hitch2' line
			}
			file close `hitch2'
			
			// check that every package in github.dta is included in the list, otherwise remove it
			local length = _N
			forval num = 1/`length' {	
				if strpos(`"`pkglist'"', name[`num']) < 1 {
					qui drop in `num'
					qui save "`c(sysdir_plus)'g/github.dta", replace
				}
			}

			if !missing("`name'") {
				qui keep if name == "`name'"
			}
			qui sort name
			local N : di _N
			if `N' > 0 {
				di in text " {hline 74}" _n										///
						   "  {bf:Date}" _col(16) 								///
						   "{bf:Name}" _col(28) 								///
							 "{bf:Version}" _col(38) 								///
						   "{bf:user/repository} " _col(58) 					///
						   "{bf:Latest release}"    _n                  ///
						   " {hline 74}"
				forvalues i = 1/`N' {
					local address : di username[`i'] "/" reponame[`i']
					local short   : di abbrev("`address'", 20) 
					local name    : di name[`i']
					local version : di version[`i']
					capture github query `address'
					if _rc {
						local latestver "API not responding" 
					}
					else local latestver `r(latestversion)' 
					*di as err "latest version:  `latestver'"
					
					if missing("`version'") {
						local version "NA"
						local vlink "https://github.com/`address'/releases/"
					}
					else {
						local vlink "https://github.com/`address'/releases/tag/`version'"
					}
					
					di " " downloaded[`i']                                       _col(16) ///
					   name[`i']                                                 _col(28) ///
					   `"{browse "`vlink'":`version'}"'                          _col(38) ///
					   `"{browse "http://github.com/`address'":`short'}"'        _col(58) _continue
					
					if "`version'" == "`latestver'" di "`latestver'"
					else if "`latestver'" != "" & "`latestver'" != "API not responding" {
					  di `"{browse "https://github.com/`address'/releases/tag/`latestver'":`latestver'}"' _col(68)  ///
						   `"({stata github install `address', version(`latestver') :update})"'
					}
					else if "`latestver'" == "API not responding" {
					  di as err "API not responding" _continue
					  di as txt ""        //avoid the red color in the next line
					}
					else di "NA"
					//	 "{stata github update `name' :update}"                             
					//	   " / {stata github uninstall `name' :uninstall}"
					*sleep 500
				}
				di in text " {hline 74}"
				
				// check that the GITHUB module is in the database
				if missing("`name'") {
					qui keep if name == "github"
					local N : di _N
					if `N' == 0 {
						di as txt _n "type {bf:{stata gitget github}} to allow managing {help github} package"
					}
				}
				
			}
			else {
			  di as txt "no github package was found!"
				di as txt "type {bf:{stata gitget github}} to allow managing {help github} package"
			}
			
			restore
		}
	}
	
end
