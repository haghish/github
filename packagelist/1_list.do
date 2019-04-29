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
1.1 list of Stata repositories on GitHub
----------------------------------------
***/

//OFF
githublistpack , language(Stata) append replace save("archive1") duration(1)    ///
    all in(all) perpage(100)
//ON

txt "there are " _N " obserbations in the data set"



/***
1.2 Adding packages which are not in Stata language
------------------------------------------------------------

***/

// mining stata-related repositories
githublistpack stata, language(all) append replace save("archive2") ///
                 duration(1) all in(all) perpage(100) 

/***
### Merging the data sets
***/							 
use "archive2.dta", clear
append using "archive1.dta"
duplicates drop address, force
drop _merge 
saveold "archive.dta", replace

*erase "archive1.dta"
*erase "archive2.dta"


/***
1.3 Check the pkg files and package names
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
generating the 'unique' data, update the data sets.

For now, I only support 'rcode.r'. this file also checks for 
_stata.toc_ files and thus is preferable. 
***/

/***

AFTER RUNNING rcode.r FILE, execute:

~~~
use unique.dta, clear
merge m:m address using "toc.dta"
drop _merge 
saveold "temp.dta", replace


use archive.dta, clear
duplicates drop address, force
drop package path
merge 1:m address using "temp.dta"
capture drop _merge 

replace installable = 0
replace installable = 1 if (packagename != "") & (toc == 1) 

saveold "archive.dta", replace
erase temp.dta
~~~

REMEMBER THAT FROM NOW ON, 'address' is no longer unique
***/








/***
1.4 Dependency
------------------------------------

We need to check whether the packages include dependencies. To do so, we search 
for _dependency.do_ file within each installable 
***/

use "archive.dta", clear
capture drop dependency
generate dependency = .

local j 0
local last = _N
forval N = 1/`last' {
	if installable[`N'] == 1 {
		local j = `j'+1
		local address : di address[`N']
		capture githubdependency `address'
		if `r(dependency)' == 1 {
			display as txt "`N'/`last'" 
			replace dependency = 1 in `N'
		}
	}
}

saveold "archive.dta", replace


/***
1.5 Creating gitget.dta file
--------------------------------
***/
use "archive.dta", clear
keep if installable == 1
saveold "gitget.dta", replace


/***
1.6 Creating packagelist.md file
--------------------------------
***/

use "gitget.dta", clear
gitgetlist, export("gitget.md")


// monitoring 
gsort - installable language
replace language="0" if language==""
tab installable language if installable == 1

/***
1.7 Creating githubfiles data
--------------------------------
***/

clear
tempfile githubfiles
qui generate str20 address = ""
qui generate str20 packagename = ""
qui generate str20 file = ""
qui save "githubfiles.dta", replace

quietly sysuse gitget, clear

//ATTENTION: currently it only searches the master branch...
tempfile confirm
local N : di _N
forval i = 1/`N' {
	
	tempfile api 
	tempname hitch 
	qui local link : display "https://raw.githubusercontent.com/" address[`i'] "/master/" path[`i']
  capture quietly copy  "`link'" `api', replace
	local loop = 0
	local count = 1
	local continue = 1
	
	if _rc != 0 {
		local continue = 0
		di as err "`link'"
		local loop = 1
		while `loop' == 1 {
			di as txt "wait a few seconds and try a gain (`count'/3)"
			sleep 3000
			local count = `count' + 1
			capture quietly copy  "`link'" `api', replace
			if _rc == 0 {
				local loop = 0
				local continue = 1
			}
			if `count' > 3 {
				local loop = 0
				di as err "no luck!"
			}
		}
	}
	
  if `continue' == 1 {
		display as txt "`i'"
		local address = address[`i']
		local packagename = packagename[`i']
		file open `hitch' using "`api'", read
		file read `hitch' line
		while r(eof) == 0 { 
			capture local line : subinstr local line "`" "", all
			capture if substr(trim(`"`macval(line)'"'),1,2) == "F " |       ///
			substr(trim(`"`macval(line)'"'),1,2) == "f " {
				preserve
				use githubfiles.dta, clear
				local NEXT : di _N + 1
				qui set obs `NEXT'
				qui replace address = "`address'" in `NEXT'
				qui replace packagename = "`packagename'" in `NEXT'
				qui replace file = substr(trim(`"`macval(line)'"'),3,.) in `NEXT'
				qui save "githubfiles.dta", replace
				restore
			}
			file read `hitch' line
    }
		file close `hitch'
		capture rm `"`api'"'
  }
	
	sleep 250
}


use githubfiles.dta, clear
