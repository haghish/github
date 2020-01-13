*cap prog drop githubcheckfilename

program githubcheckfilename
	
  version 13

  syntax anything [, filename(str)]

  //check whether the filename exists in other packages
  preserve
  sysuse githubfiles.dta, clear
  qui gen found = strpos(file, "`filename'")
  qui keep if found == 1 & packagename != `anything'
  local N = _N
  if `N' > 0 {
	di as err "{bf:`filename'} is used elsewhere. try: {stata github findfile `filename'}"
  }
  restore

end 
