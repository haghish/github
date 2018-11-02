* E. F. Haghish 2018

*cap prog drop githubdb
program githubdb, rclass
	syntax anything, [address(str) username(str) reponame(str) name(str)]
	
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
		
		// add 
		// --------------
		if "`anything'" == "add" {
			preserve
			use "`r(fn)'", clear
			qui drop if address == "`address'"  // clean the database
			local nextN : di _N + 1
			qui set obs `nextN' 
			qui replace downloaded = "$S_DATE" in `nextN'
			qui replace address = "`address'" in `nextN'
			qui replace username = "`username'" in `nextN'
			qui replace reponame = "`reponame'" in `nextN'
			qui replace name = "`name'" in `nextN'
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
			local N : di _N
			if `N' > 0 {
				di in text " {hline 64}" _n										///
						   "  {bf:Date}" _col(16) 								///
						   "{bf:Name}" _col(28) 								///
						   "{bf:user/repository} " _col(48) 					///
						   "{bf:Action}"    _n                                 	///
						   " {hline 64}"
				forvalues i = 1/`N' {
					local address : di username[`i'] "/" reponame[`i']
					local short : di abbrev("`address'", 20) 
					local name : di name[`i']
					di " " downloaded[`i'] _col(16) name[`i'] _col(28)          ///
					   `"{browse "http://github.com/`address'":`short'}"'       ///
						   _col(48) "{stata github install `address' :update}"  ///
						   " / {stata github uninstall `name' :uninstall}"
				}
				di in text " {hline 64}"
			}
			else di as txt "no github package was found!"
			restore
		}
	}
	
end
