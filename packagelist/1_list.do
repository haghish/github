//this file is written for MarkDoc package v. 4.4.5

/***
PACKAGE LIST
============

This file includes a series of code for building an archive of all existing 
Stata packages and repositories on GitHub. The list of Stata repositories 
provides a valuable database for simplifying the syntax of the `github` package. 


The task is done by carrying out a comprehensive API search on GitHub and 
combining the results. Executing this file may take many hours. 

To the maintainers
------------------

After the first execution, you don't need to run the whole file again. Instead,
you can go to __SECTION 2: UPDATING__ and only update the archive, from the 
last date. 

---


SECTION 1: BUILDING THE ARCHIVE FOR THE FIRST TIME
================================================================================

Only run this section once. later on, you can update your datasets, instead of 
running the whole search again, which takes a long time. In addition, the search 
might also overwhelm GitHub API. Make sure you add enough delay seconds
***/


/***
1.1 Expected number of repositories
----------------------------------------
***/

githubsearch , language(Stata) perpage(1) quiet



/***
1.2 list of Stata repositories on GitHub
----------------------------------------
***/

//OFF
githublistpack , language(Stata) append replace save("gitget") duration(1)    ///
    all in(all) perpage(100)
//ON

txt "there are " _N " obserbations in the data set"



/***
1.3 Adding packages which are not in Stata language
------------------------------------------------------------

The expected number of repositories is:
***/

githubsearch stata, language(all) in(all)  perpage(1) quiet


// mining stata-related repositories
githublistpack stata, language(all) append replace save("archive") ///
                 duration(1) all in(all) perpage(100)

/***
### Merging the data sets
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


