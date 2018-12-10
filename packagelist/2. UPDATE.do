qui log using update, replace smcl

/***
Updating list of Stata repositories on GitHub
============================================================

The list of Stata repositories provides a valuable database for simplifying 
the syntax of the `github` package. You can update the package list from a 
starting reference date. the `reference("yyyy-mm-dd")` in the example below 
shows the __last update__ made for the *packagelist.dta* dataset
***/

//OFF
timer clear 1
timer on 1
qui log off
clear

githublistpack , language(Stata) append replace save("update")                  ///
                 duration(1) all in(all) reference("2018-12-01") perpage(100)
timer off 1
qui log on
//ON

/***
Execution time
--------------

***/

timer list 1

txt "there are " _N " obserbations in the data set"

use "packagelist.dta", clear
append using "update.dta"
duplicates drop address, force
saveold "packagelist.dta", replace
erase update.dta

qui log c
