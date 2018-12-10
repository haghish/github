//by E. F. Haghish, 2018

*cap prog drop githubhot
program githubhot
	
	version 13
	
	syntax [anything]  //anything is an integer
	
	if missing("`anything'") local anything 10
	
	// find the gitget dataset
	// -----------------------------------------------------------------------
	capture findfile gitget.dta, path("`c(sysdir_plus)'g/")
	if _rc == 0 {
		preserve
		use "`r(fn)'", clear
		gsort -score
		if _N == 0 {
			display as err "{bf:gitget.dta} is empty!!!"
		}
		else {
			quietly gsort -score
			quietly keep in 1/`anything'
			githuboutput
		}
		restore
	}
	else {
		display as err "the {bf:gitget.dta} data set was not found!"
	}

end 
