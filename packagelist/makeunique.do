cd "C:\Users\haghish.fardzadeh\Documents\GitHub\github"

clear
tempfile githubfiles
qui generate str20 address = ""
qui generate str20 packagename = ""
qui generate str20 file = ""
qui save "githubfiles.dta", replace

quietly sysuse gitget, clear

tempfile confirm
	

 
local N : di _N

forval i = 1/`N' {
	
	tempfile api 
	tempname hitch 
	qui local link : display "https://raw.githubusercontent.com/" address[`i'] "/master/" path[`i']
  capture quietly copy  "`link'" `api', replace
	
  if _rc == 0 {
		display as txt "`i'"
		local address = address[`i']
		local packagename = packagename[`i']
		file open `hitch' using "`api'", read
		file read `hitch' line
		while r(eof) == 0 { 
			if substr(trim(`"`macval(line)'"'),1,2) == "F " |       ///
			substr(trim(`"`macval(line)'"'),1,2) == "f " {
				preserve
				use githubfiles.dta, clear
				local NEXT : di _N + 1
				qui set obs `NEXT'
				qui replace address = "`address'" in `NEXT'
				qui replace packagename = "`packagename'" in `NEXT'
				qui replace file = substr(trim(`"`macval(line)'"'),3,.) in `NEXT'
				qui save "githubfiles.dta", replace
				restore
			}
			file read `hitch' line
    }
		file close `hitch'
		capture rm "`api'"
  }
	else {
		di as err "`link'"
	}
	sleep 250
}


use githubfiles.dta, clear
