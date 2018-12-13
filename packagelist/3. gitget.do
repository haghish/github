quietly use "packagelist.dta", clear
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

saveold "packagelist.dta", replace


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










// .........................................................


/***
Creating packagelist.md file
============================
***/

use "gitget.dta", clear

quietly recode score (. = 0)
gsort -score -star
tempfile tmp1
tempname knot 

qui cap file open `knot' using "`tmp1'", write replace

local now : di %td_D-N-CY  date("$S_DATE", "DMY") " $S_TIME"
local now : di trim("`now'")

file write `knot' "_updated on " "``now'" "`" "_   " _n
file write `knot' "this is the complete list of *installable* Stata packages on GitHub, up to the date specified above. to install a Stata package included in this list, simply type:" _n(2)
file write `knot' "    gitget packagename" _n(2)
file write `knot' "- - -" _n(2)

file write `knot' "List of Stata Packages Recognized by `gitget` command" _n ///
                  "=====================================================" _n(2)
									
file write `knot' "packages are listed based on their __Hits__ score" _n(2)

file write `knot'  "#|Package|Hits|Updated|Dependecy|Size|Description" _n       ///
		"--------:|:--------|:--------|:--------|:--------|:--------|:--------" _n

local last = _N 
forval i = 1/`last' {
	local name = name[`i']
	local address = address[`i']
	local hits = score[`i']
	local updated : di %td dofc(updated[`i']) 
	local dependency = dependency[`i']
	if "`dependency'" == "1" {
		local dependency "[dependency.do](https://github.com/`address'/blob/master/dependency.do)"
	}
	else {
		local dependency 
	}
	local kb = kb[`i']
	local description = description[`i']
	local description : subinstr local description "`" "'", all
	local description : di substr(`"`macval(description)'"', 1, 180)
	file write `knot' `"`i'|[`name'](https://github.com/`address')|"'   ///
						`"`hits'|`updated'|`dependency'|`kb'kb|`description'"' _n
}

file close `knot'
copy "`tmp1'" gitget.md , replace
