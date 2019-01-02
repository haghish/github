/***

Adding packages which are not primarily in Stata language, but are for Stata
============================================================================

Expected repositories
---------------------

***/

// expected repositories
githubsearch stata, language(all) in(all)  perpage(1) quiet


// mining stata-related repositories
githublistpack stata, language(all) append replace save("archive") ///
                 duration(1) all in(all) perpage(100)


//UPDATE					 
githublistpack stata, language(all) append replace save("update") ///
duration(1) all in(all) reference("2019-01-01") perpage(100)


use "archive.dta", clear
append using "update.dta"
append using "repolist.dta"
duplicates drop address, force
saveold "archive.dta", replace
erase update.dta


use "archive.dta", clear
keep if installable == 1
append using "repolist.dta"
duplicates drop address, force
saveold "repolist.dta", replace

use "archive.dta", clear
keep if installable == 1
append using "gitget.dta"
duplicates drop address, force
saveold "gitget.dta", replace


gsort - installable language

replace language="0" if language==""

tab installable language if installable == 1
