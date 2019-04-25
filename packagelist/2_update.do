/***
Updating the package List
=========================

The list of Stata repositories provides a valuable database for simplifying 
the syntax of the `github` package. You can update the package list from a 
starting reference date. the `reference("yyyy-mm-dd")` in the example below 
shows the __last update__ made for the *gitget.dta* dataset

> change the __date__ in the `reference("")` option using __yyyy-mm-dd__ format.


2.1 Updating the data with Stata language
-----------------------------------------

***/


//OFF
clear

githublistpack , language(Stata) append replace save("gitget_update")         ///
                 reference("2019-04-01") duration(1) all in(all) perpage(100)
//ON


/***
2.2 Adding packages which are not in Stata language
------------------------------------------------------------

***/

//OFF
// mining stata-related repositories
clear
githublistpack stata, language(all) append replace save("archive_update")       ///
                 reference("2019-04-01") duration(1) all in(all) perpage(100)
//ON


/***
Next, we will merge these data sets with the previously built data sets. To do 
so, first we will update _gitget_ and _archive_ with their updates. 
***/

// updating gitget & archive
use "gitget.dta", clear
append using "gitget_update.dta"
duplicates drop address, force
saveold "gitget.dta", replace

use "archive.dta", clear
append using "archive_update.dta"
duplicates drop address, force
saveold "archive.dta", replace

/***
Next, we will update archive and gitget by adding their unique packages
***/
use "archive.dta", clear
append using "gitget.dta"
duplicates drop address, force
saveold "archive.dta", replace

use "archive.dta", clear
keep if installable == 1
append using "gitget.dta"
duplicates drop address, force
saveold "gitget.dta", replace
