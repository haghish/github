qui log using update, replace smcl

/***
Updating list of Stata repositories on GitHub
============================================================

The list of Stata repositories provides a valuable database for simplifying 
the syntax of the `github` package. You can update the package list from a 
starting reference date. the `reference("yyyy-mm-dd")` in the example below 
shows the __last update__ made for the *repolist.dta* dataset
***/

//OFF
timer clear 1
timer on 1
qui log off
clear

githublistpack , language(Stata) append replace save("update")                  ///
                 duration(1) all in(all) reference("2018-12-10") perpage(100)
timer off 1
qui log on
//ON

/***
Execution time
--------------

***/

timer list 1

use "update.dta", clear

txt "there are " _N " obserbations in the data set"


capture drop dependency
generate dependency = .

local j 0
local last = _N
forval N = 1/`last' {
	if installable[`N'] == 1 {
		display as txt "`N'/`last'" 
		local j = `j'+1
		local address : di address[`N']
		capture githubdependency `address'
		if `r(dependency)' == 1 {
			replace dependency = 1 in `N'
		}
	}
}


append using "repolist.dta"
duplicates drop address, force
saveold "repolist.dta", replace

erase update.dta

qui log c
