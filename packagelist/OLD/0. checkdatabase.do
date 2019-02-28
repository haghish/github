//this file is written for MarkDoc package

qui log using checkdatabase, replace smcl

/***
Count number of Stata repositories 
==================================
***/

forval i = 0/9 {
	di "{title:repositories created before 201`i'}"
	noisily githubsearch, language(Stata) perpage(1) quiet created("<201`i'")
	quietly use "repolist.dta", clear
	quietly gen year = year(dofc(created))
	quietly keep if year < 201`i'
	txt "the database has " _N " observations"
}

qui log c


