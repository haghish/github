// this document uses commands provided by MarkDoc package

qui log using packagelist, replace smcl

/***
`github` package data sets
============================================================

Updating list of Stata repositories on GitHub
---------------------------------------------

The list of Stata repositories provides a valuable database for simplifying 
the syntax of the `github` package. You can update the package list from a 
starting reference date

***/

//OFF
qui log off
timer clear 1
timer on 1
githublistpack , language(Stata) append replace save("packagelist")             ///
                 duration(10) all in(all) 
timer off 1
qui log on
//ON

/***
Execution time
--------------

***/

timer list 1

txt "there are " _N " obserbations in the data set"

/***
Expected repositories
---------------------

***/
githubsearch , language(Stata) perpage(1) quiet

qui log c





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
                 duration(1) all in(all) reference("2018-01-01") perpage(100)
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


/***
Generating `gitget.dta` data set
============================================================

The `gitget` data set is used as a short-cut for installing Stata packages 
from the complete list of Stata repositories, stored in `packagelist.dta` data set.
In this document, I will create a subset of the installable repositories to be 
used by the `gitget` command
***/

use "packagelist.dta", clear
keep if installable == 1

saveold "gitget.dta", replace


