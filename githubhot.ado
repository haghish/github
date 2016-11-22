prog githubhot
	syntax [anything] [, language(str) save(str) in(str) all Number(numlist max=1)] 
	preserve
	qui use "https://raw.githubusercontent.com/haghish/github/master/data/archive.dta", clear
	if missing("`all'") {
		qui keep if installable
	}	
	if !missing("`language'") {
		qui drop if language != "`language'"
	}
	gsort -installable -score -star
	
	if missing("`number'") {
		local number 10
	}
	
	capture keep in 1/`number'
	
	githuboutput `anything', in("`in'") `all' quiet language(`language') number(`number')
	restore
end 
