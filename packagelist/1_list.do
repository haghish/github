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
duplicates drop address, force
saveold "gitget.dta", replace


/***
1.4 Check the pkg files and package names
-----------------------------------------

we need to searche for all packages inside the 
repositories and also examines the package names. For 
example, if the package name is not identical to the 
repository name, this process will correct the package name 
in the data set. 

The results of this search are stored in the unique.dta 
data set. there are 2 ways to generate the unique data set: 

1. using rcode.do with RCALL package
2. running rcode.r in R console

both files are located in the packagelist directory. After
generating the UNIQUE data, update the data sets
***/

*use gitget.dta, clear
*merge 1:m address using "unique.dta"
*saveold "gitget.dta", replace



/***
1.4 Dependency
------------------------------------

We need to check whether the packages include dependencies. To do so, we search 
for _dependency.do_ file within each installable 
***/

use "gitget.dta", clear
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

saveold "gitget.dta", replace


/***
1.7 Creating packagelist.md file
--------------------------------
***/

use "gitget.dta", clear
gitgetlist, export("gitget.md")


// monitoring 
gsort - installable language
replace language="0" if language==""
tab installable language if installable == 1
